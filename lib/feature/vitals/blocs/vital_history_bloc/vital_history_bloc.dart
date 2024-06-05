import 'dart:async';
import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:debug_logger/debug_logger.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:livecare/livecare.dart';
import 'package:meta/meta.dart';
import 'package:famici/core/enitity/barrel.dart';
import 'package:famici/feature/health_and_wellness/vitals_and_wellness/entity/vital.dart';
import 'package:famici/feature/vitals/blocs/vital_sync_bloc/vital_sync_bloc.dart';
import 'package:famici/feature/vitals/entities/vital_history.dart';
import 'package:famici/repositories/barrel.dart';
import 'package:famici/utils/barrel.dart';
import 'dart:math' as math;

import '../../../../utils/helpers/events_track.dart';

part 'vital_history_event.dart';

part 'vital_history_state.dart';

class VitalHistoryBloc extends Bloc<VitalHistoryEvent, VitalHistoryState> {
  VitalHistoryBloc({
    required User me,
  })  : _me = me,
        super(VitalHistoryState.initial()) {
    on<SyncListOfVitals>(_onSyncListOfVitals);
    on<SyncSelectedVital>(_onSyncSelectedVital);
    on<SyncSelectedDate>(_onSyncSelectedDate);
  }

  final VitalsAndWellnessRepository _vitalsAndWellnessRepository =
      VitalsAndWellnessRepository();
  final User _me;

  void _onSyncListOfVitals(SyncListOfVitals event, emit) async {
    List<Vital> _vitals = [];
    for (Vital vital in List<Vital>.from(event.vitals)) {
      switch (vital.vitalType) {
        case VitalType.unknown:
          break;
        case VitalType.feelingToday:
          break;
        default:
          _vitals.add(vital);
          break;
      }
    }

    emit(state.copyWith(vitals: _vitals.toSet().toList()));
    add(SyncSelectedVital(
      _vitals.isEmpty ? VitalType.heartRate : _vitals.first.vitalType,
      isRefreshed: true,
    ));
  }

  void _onSyncSelectedDate(SyncSelectedDate event, emit) async {
    Vital _vital = state.selectedVital;
    emit(state.copyWith(startDate: event.startDate, endDate: event.endDate));
    // print('ishu meme hi ishumeme ${event.startDate}');
    if (event.mergeTempToSelected) {
      emit(state.copyWith(
          startDate: state.tempStartDate, endDate: state.tempEndDate));
    }
    if (event.shouldRefresh) {
      add(SyncSelectedVital(
        _vital.vitalType,
        isRefreshed: false,
      ));
    }
  }

  void _onSyncSelectedVital(SyncSelectedVital event, emit) async {
    emit(state.copyWith(status: Status.loading));
    List<Vital> _vitalList = state.vitals;
    Vital _selected = state.selectedVital;
    DateTime _startDate = state.startDate.toUtc();
    DateTime _endDate = state.endDate.toUtc();
    if (_vitalList.isNotEmpty) {
      try {
        _selected = _vitalList.firstWhere(
          (e) => e.vitalType == event.vitalType,
        );
      } catch (err) {
        DebugLogger.debug(err);
      }
    }

    try {
      // AndroidDeviceInfo device = await DeviceInfoPlugin().androidInfo;
      // if (device.isPhysicalDevice == null ||
      //     !(device.isPhysicalDevice ?? false)) {
      //   throw Exception("emulator not supported");
      // }
      VitalHistory? _history;
      if (!event.isRefreshed) {
        _history = await _vitalsAndWellnessRepository.fetchVitalHistory(
          vital: _selected,
          startDate: DateFormat(apiDateFormat).format(_startDate),
          endDate: DateFormat(apiDateFormat).format(_endDate),
          familyId: _me.familyId,
          contactId: _me.id,
        );

        var historicDataType = '';
        var dateDifference = _endDate.difference(_startDate).inDays + 1;
        if (dateDifference == 7) {
          historicDataType = 'Last 7 Days';
        } else if (dateDifference == 30 || dateDifference == 31) {
          historicDataType = 'Last 30 Days';
        } else {
          historicDataType = 'Custom Days';
        }

        for (var reading in _history.readings) {
          var properties = TrackEvents().setProperties(
              fromDate: _startDate,
              toDate: _endDate,
              reading: vitalReadingHelper(_selected, reading),
              readingDateTime:
                  DateTime.fromMillisecondsSinceEpoch(reading.readAt)
                      .toString(),
              vital: _selected.name,
              appointmentDate: '',
              appointmentTime: '',
              appointmentCounselors: '',
              appointmentType: '',
              callDuration: '',
              readingType: 'Historic');
          TrackEvents().trackEvents(
              'Historic Data - $historicDataType Selected', properties);
        }
      }
      _history?.readings.sort((a, b) => b.readAt - a.readAt);

      LineChartBarData _data = await syncHistory({
        'readings': _history?.readings ?? [],
        'type': event.vitalType,
      });

      LineChartData _chart = await VitalChartHelper().chartData(
        double.parse(_history!.min.value),
        double.parse(_history.max.value),
        _history.readings.first.readAt,
        _history.readings.last.readAt,
        _data,
      );

      emit(state.copyWith(
        selectedVital: _selected,
        status: Status.success,
        history: _history,
        lineChartBarData: _data,
        chart: _chart,
      ));
    } catch (err) {
      LineChartBarData _data = await syncHistory({
        'readings': [],
        'type': event.vitalType,
      });

      emit(state.copyWith(
        selectedVital: _selected,
        status: Status.failure,
        history: VitalHistory(),
        lineChartBarData: _data,
        chart: LineChartData(),
      ));
    }
  }

  String vitalReadingHelper(Vital vital, Reading readings) {
    var reading = '';
    if (vital.vitalType == VitalType.bp) {
      reading = '${readings.sys}/${readings.dia}';
    } else if (vital.vitalType == VitalType.spo2) {
      reading = '${readings.oxygen}${vital.measureUnit!}';
    } else if (vital.vitalType == VitalType.gl) {
      reading = '${readings.bgValue}';
    } else if (vital.vitalType == VitalType.heartRate) {
      reading = '${readings.pulse}';
    } else if (vital.vitalType == VitalType.temp) {
      reading = '${readings.temperature} ${vital.measureUnit!}';
    } else if (vital.vitalType == VitalType.fallDetection) {
      reading = '${readings.fallDetection ? 1 : 0} ${vital.measureUnit!}';
    } else if (vital.vitalType == VitalType.activity) {
      reading = readings.steps;
    } else if (vital.vitalType == VitalType.ws) {
      reading = readings.weight;
    } else if (vital.vitalType == VitalType.sleep) {
      reading = readings.hr;
    }
    return reading;
  }
}

class VitalChartHelper {
  static FlSpot getSpotFrom(Reading reading, VitalType type) {
    FlSpot spot = FlSpot.zero;
    switch (type) {
      case VitalType.heartRate:
        spot = FlSpot(
          reading.readAt.toDouble(),
          double.tryParse(reading.pulse) ?? 0.0,
        );
        break;
      case VitalType.spo2:
        spot = FlSpot(
          reading.readAt.toDouble(),
          double.tryParse(reading.oxygen) ?? 0.0,
        );
        break;
      case VitalType.bp:
        double sys = double.tryParse(reading.sys) ?? 0.0;
        double dia = double.tryParse(reading.dia) ?? 0.0;
        spot = FlSpot(reading.readAt.toDouble(), sys / (dia == 0.0 ? 1 : dia));
        break;
      case VitalType.gl:
        spot = FlSpot(
          reading.readAt.toDouble(),
          double.tryParse(reading.bgValue) ?? 0.0,
        );
        break;

      case VitalType.temp:
        spot = FlSpot(
          reading.readAt.toDouble(),
          double.tryParse(reading.temperature) ?? 0.0,
        );
        break;
      case VitalType.ws:
        spot = FlSpot(
          reading.readAt.toDouble(),
          double.tryParse(reading.weight) ?? 0.0,
        );
        break;
      case VitalType.activity:
        spot = FlSpot(
          reading.readAt.toDouble(),
          double.tryParse(reading.steps) ?? 0.0,
        );
        break;
      case VitalType.sleep:
        spot = FlSpot(
          reading.readAt.toDouble(),
          double.tryParse(reading.hr) ?? 0.0,
        );
        break;
      default:
        break;
    }
    return spot;
  }

  static Future<LineChartBarData> chartBarData(
    List<Reading> readings,
    VitalType type,
  ) async {
    return LineChartBarData(
      isCurved: true,
      curveSmoothness: 0.05,
      colors: [ColorPallet.kRed],
      barWidth: 6,
      isStrokeCapRound: true,
      dotData: FlDotData(show: true),
      belowBarData: BarAreaData(show: false),
      spots: readings.map((e) => getSpotFrom(e, type)).toList(),
      preventCurveOverShooting: true,
    );
  }

  Future<FlBorderData> borderData() async {
    return FlBorderData(
      show: true,
      border: Border(
        top: BorderSide(color: ColorPallet.kPrimaryTextColor, width: 0.5),
        bottom: BorderSide(color: ColorPallet.kPrimaryTextColor, width: 0.5),
      ),
    );
  }

  Future<LineChartData> chartData(
    double min,
    double max,
    int startDate,
    int endDate,
    LineChartBarData lineChartBarData,
  ) async {
    LineTouchData _lineTooltipData = await tooltipWrapperData();

    FlGridData _gridData = await gridData(min, max);
    FlTitlesData _tilesData = await titlesData(min, max, startDate, endDate);
    FlBorderData _borderData = await borderData();
    LineChartData _data = LineChartData(
      lineTouchData: _lineTooltipData,
      gridData: _gridData,
      titlesData: _tilesData,
      borderData: _borderData,
      lineBarsData: [lineChartBarData],
      maxY: max,
      minY: min == max ? 0 : min,
      minX: startDate.toDouble(),
      maxX: endDate.toDouble(),
    );

    return _data;
  }

  Future<LineTouchData> tooltipWrapperData() async => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: ColorPallet.kRed,
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            // showOnTopOfTheChartBoxArea: true,
            getTooltipItems: (items) {
              return items.map((e) => getTooltipItem(e)).toList();
            }),
        getTouchLineStart: (d, i) {
          return 0;
        },
        getTouchLineEnd: (d, i) {
          return 0;
        },
      );

  LineTooltipItem getTooltipItem(LineBarSpot spot) {
    return LineTooltipItem(
      '',
      FCStyle.textStyle.copyWith(color: ColorPallet.kWhite),
      children: [
        TextSpan(
          text: '${spot.y.toString()}\n',
        ),
        TextSpan(
          text: DateFormat().add_MEd().format(
                DateTime.fromMillisecondsSinceEpoch(
                  spot.x.toInt(),
                ),
              ),
        )
      ],
    );
  }

  Future<SideTitles> leftTitles(double min, double max) async => SideTitles(
        getTitles: (value) {
          return NumberFormat.compact().format(value).toString();
        },
        showTitles: true,
        margin: 24.0,
        // interval: max == min
        //     ? 10.0
        //     : (max - min).abs() > 5
        //         ? ((max - min).abs() / 5).floorToDouble()
        //         : 10.0,
        reservedSize: FCStyle.xLargeFontSize,
        getTextStyles: (context, value) => FCStyle.textStyle.copyWith(
          fontSize: FCStyle.defaultFontSize,
          fontWeight: FontWeight.bold,
        ),
        checkToShowTitle: (
          double minValue,
          double maxValue,
          SideTitles sideTitles,
          double appliedInterval,
          double value,
        ) {
          if (value > minValue && minValue + appliedInterval > value) {
            return false;
          }
          if (maxValue > value && value > (maxValue - appliedInterval).abs()) {
            return false;
          }
          return true;
        },
      );

  Future<SideTitles> bottomTitles(int startDate, int endDate) async =>
      SideTitles(
        getTitles: (value) {
          var dateFormat = DateFormat().add_jm();
          DateTime _date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
          return dateFormat.format(_date);
        },
        showTitles: true,
        margin: 10,
        interval: endDate == startDate
            ? 1.0
            : ((endDate - startDate).abs()) > 6
                ? (((endDate - startDate).abs()) / 6).floorToDouble()
                : 1.0,
        reservedSize: FCStyle.xLargeFontSize,
        getTextStyles: (context, value) => FCStyle.textStyle.copyWith(
          fontSize: FCStyle.defaultFontSize,
          fontWeight: FontWeight.bold,
        ),
        checkToShowTitle: (
          double minValue,
          double maxValue,
          SideTitles sideTitles,
          double appliedInterval,
          double value,
        ) {
          if (startDate == endDate) {
            return true;
          }
          if (minValue == value) {
            return false;
          }
          if (maxValue == value) {
            return false;
          }
          return true;
        },
      );

  Future<FlTitlesData> titlesData(
    double min,
    double max,
    int startDate,
    int endDate,
  ) async {
    SideTitles _left = await leftTitles(min, max);
    SideTitles _bottom = await bottomTitles(startDate, endDate);
    return FlTitlesData(
      bottomTitles: _bottom,
      rightTitles: SideTitles(showTitles: false),
      topTitles: SideTitles(showTitles: false),
      leftTitles: _left,
    );
  }

  Future<FlGridData> gridData(double min, double max) async {
    FlGridData _data = FlGridData(
      show: true,
      drawHorizontalLine: true,
      drawVerticalLine: false,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: ColorPallet.kPrimaryTextColor,
          strokeWidth: 0.5,
        );
      },
      checkToShowHorizontalLine: (value) {
        if (min == value) {
          return false;
        } else if (max == value) {
          return false;
        } else {
          return true;
        }
      },
    );
    return _data;
  }
}

class VitalLogsHelper {
  static String getVitalReading(Reading reading, VitalType type) {
    var vitalReading;
    switch (type) {
      case VitalType.heartRate:
        vitalReading = reading.pulse ?? 0;

        break;
      case VitalType.spo2:
        vitalReading = (reading.oxygen) ?? 0.0;

        break;
      case VitalType.bp:
        int sys = int.parse(reading.sys) ?? 0;
        int dia = int.parse(reading.dia) ?? 0;
        vitalReading = ' ${sys} / ${(dia == 0 ? 1 : dia)}';
        break;
      case VitalType.gl:
        vitalReading = (reading.bgValue) ?? 0;

        break;

      case VitalType.temp:
        vitalReading = (reading.temperature) ?? 0;
        break;
      case VitalType.ws:
        vitalReading = (reading.weight) ?? 0;
        break;
      case VitalType.activity:
        vitalReading = (reading.steps) ?? 0;
        break;
      case VitalType.sleep:
        vitalReading = (reading.hr) ?? 0;
        break;
      default:
        break;
    }
    return vitalReading;
  }
}

Future<LineChartBarData> syncHistory(dynamic data) async {
  return await VitalChartHelper.chartBarData(
    List<Reading>.from(data['readings']),
    data['type'] as VitalType,
  );
}
