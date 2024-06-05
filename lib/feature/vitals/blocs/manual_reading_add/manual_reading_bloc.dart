import 'package:bloc/bloc.dart';
import 'package:livecare/livecare.dart';
import 'package:meta/meta.dart';
import 'package:famici/feature/health_and_wellness/vitals_and_wellness/entity/vital.dart';
import 'package:famici/feature/vitals/blocs/vital_sync_bloc/vital_sync_bloc.dart';
import 'package:famici/utils/barrel.dart';

import '../../../../utils/helpers/events_track.dart';
import '../../entities/new_manual_reading.dart';

part 'manual_reading_event.dart';

part 'manual_reading_state.dart';

class ManualReadingBloc extends Bloc<ManualReadingEvent, ManualReadingState> {
  ManualReadingBloc({
    required VitalSyncBloc vitalSyncBloc,
    required Vital vital,
  })  : _vitalSyncBloc = vitalSyncBloc,
        super(ManualReadingState.initial(vital: vital)) {
    on<ManualReadingEvent>((event, emit) {});
    on<AddMoreReading>(_onAddMoreReadings);
    on<RemoveNewManualReading>(_onRemoveNewManualReading);
    on<ManualReadingInputAdded>(_onAddReadingInput);
    on<ManualReadingTimeUpdated>(_onManualReadingTimeUpdated);
    on<ValidateNewReading>(_onValidateNewReading);
    on<SaveNewManualReadings>(_onSaveManualReadings);
    on<ValidateNewReadingTime>(_onValidateNewReadingTime);
  }

  final VitalSyncBloc _vitalSyncBloc;

  void _onAddMoreReadings(AddMoreReading event, emit) async {
    List<NewManualReading> _readings = state.readings;
    _readings.add(NewManualReading(
      readAt: DateTime.now().millisecondsSinceEpoch,
    ));
    emit(state.copyWith(readings: _readings));
    add(ValidateNewReading());
  }

  void _onRemoveNewManualReading(RemoveNewManualReading event, emit) async {
    List<NewManualReading> _readings = state.readings;
    _readings.removeAt(event.index);
    emit(state.copyWith(readings: _readings));
    add(ValidateNewReading());
  }

  void _onAddReadingInput(ManualReadingInputAdded event, emit) async {
    List<NewManualReading> _readings = state.readings;
    _readings[event.index] = event.reading;
    emit(state.copyWith(readings: _readings));
    add(ValidateNewReading());
  }

  void _onValidateNewReading(ValidateNewReading event, emit) async {
    Vital vital = state.vital;
    List<NewManualReading> _readings = state.readings;
    bool isValid = true;
    bool exceededReadingCount = !(_readings.length > 5);
    for (var reading in _readings) {
      switch (vital.vitalType) {
        case VitalType.bp:
          isValid =
              double.parse(reading.sys) > 0 && double.parse(reading.dia) > 0;
          break;
        case VitalType.heartRate:
          isValid = double.parse(reading.pulse) > 0;
          break;
        case VitalType.spo2:
          isValid = double.parse(reading.oxygen) > 0;
          break;
        case VitalType.temp:
          double temp = double.parse(reading.temperature);
          isValid = temp > -200 && temp < 200;
          break;
        case VitalType.gl:
          isValid = double.parse(reading.bgValue) > 0;
          break;
        case VitalType.ws:
          isValid = double.parse(reading.weight) > 0;
          break;
        case VitalType.activity:
          isValid = double.parse(reading.steps) > 0;
          break;
        case VitalType.sleep:
          isValid = double.parse(reading.hr) > 0;
          break;
        default:
          isValid = true;
          break;
      }
      if (!isValid) {
        break;
      }
    }

    emit(state.copyWith(isValid: isValid && exceededReadingCount));
    add(ValidateNewReadingTime());
  }

  void _onValidateNewReadingTime(ValidateNewReadingTime event, emit) async {
    List<NewManualReading> _readings = state.readings;
    bool isValid = true;
    int index = -1;
    int timeNow = DateTime.now().millisecondsSinceEpoch;
    for (int i = 0; i < _readings.length; i++) {
      isValid = _readings[i].readAt < timeNow;
      if (!isValid) {
        index = i;
        break;
      }
    }
    emit(state.copyWith(validTime: isValid, invalidTimeIndex: index));
  }

  void _onManualReadingTimeUpdated(ManualReadingTimeUpdated event, emit) async {
    List<NewManualReading> _readings = state.readings;

    DateTime _newTime = event.time;
    _readings[event.index] = _readings[event.index].copyWith(
      readAt: _newTime.millisecondsSinceEpoch,
    );
    emit(state.copyWith(readings: _readings));
    add(ValidateNewReadingTime());
  }

  void _onSaveManualReadings(SaveNewManualReadings event, emit) async {
    List<NewManualReading> _readings = state.readings;
    Vital _vital = state.vital;
    _vitalSyncBloc.add(SyncManualReadings(_vital, _readings));
    emit(state.copyWith(readings: [], status: Status.success));

    for (var reading in _readings) {
      var properties = TrackEvents().setProperties(
          fromDate: '',
          toDate: '',
          reading: vitalReadingHelper(_vital, reading),
          readingDateTime: DateTime.fromMillisecondsSinceEpoch(reading.readAt),
          vital: _vital.name,
          appointmentDate: '',
          appointmentTime: '',
          appointmentCounselors: '',
          appointmentType: '',
          callDuration: '',
          readingType: 'Manual');
      TrackEvents().trackEvents('Manual Entry Readings', properties);
    }
  }

  String vitalReadingHelper(Vital vital, NewManualReading readings) {
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
