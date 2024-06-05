import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:connectivity_checker/connectivity_checker.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:livecare/livecare.dart';
import 'package:famici/core/enitity/barrel.dart';
import 'package:famici/feature/health_and_wellness/vitals_and_wellness/entity/vital.dart';

import 'package:famici/feature/vitals/blocs/vital_history_bloc/vital_history_bloc.dart';
import 'package:famici/feature/vitals/entities/vital_device.dart';

import 'package:famici/repositories/barrel.dart';
import 'package:famici/repositories/vitals_and_wellness_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'vitals_and_wellness_event.dart';

part 'vitals_and_wellness_state.dart';

class VitalsAndWellnessBloc
    extends HydratedBloc<VitalsAndWellnessEvent, VitalsAndWellnessState> {
  VitalsAndWellnessBloc({
    required User me,
    required VitalHistoryBloc vitalHistoryBloc,
  })  : _me = me,
        _historyBloc = vitalHistoryBloc,
        super(VitalsAndWellnessState.initial()) {
    on<ToggleShowVitals>(_onToggleShowVitals);
    on<FetchVitals>(_onFetchVitals);
    on<FetchWellness>(_onFetchWellness);
    on<SyncConnectedVital>(_onSyncConnectedVital);
    on<SyncDisconnectedVital>(_onSyncDisconnectedVital);
    on<SyncVitalDeviceData>(_onSyncVitalDeviceData);
    on<SyncWellnessDeviceData>(_onSyncWellnessData);
    on<SyncConnectedWellness>(_onSyncConnectedWellness);
    on<SyncDisconnectedWellness>(_onSyncDisconnectedWellness);
    on<SyncUpdatedManualReading>(_onSyncUpdatedManualReading);
    _vitalsProviderToHistory = stream.listen((event) {
      List<Vital> _vitals = List.from(event.vitalList);
      _vitals.addAll(event.wellnessList);
      _historyBloc.add(SyncListOfVitals(_vitals));
    });
  }

  final User? _me;
  StreamSubscription? vitalSyncBlocSubscription;
  VitalsAndWellnessRepository _vitalsAndWellnessRepository =
      VitalsAndWellnessRepository();

  final VitalHistoryBloc _historyBloc;

  StreamSubscription? _vitalsProviderToHistory;

  void _onToggleShowVitals(ToggleShowVitals event, Emitter emit) {
    bool isShowingVitals = state.showingVitals;
    emit(state.copyWith(showingVitals: !isShowingVitals));
  }

  void _onFetchVitals(FetchVitals event, Emitter emit) async {
    try {
      emit(state.copyWith(status: VitalsAndWellnessStatus.initial));
      emit(state.copyWith(status: VitalsAndWellnessStatus.loading));

      _vitalsAndWellnessRepository = VitalsAndWellnessRepository();

      List<Vital> _wellnessList = state.wellnessList;
      List<Vital> _vitals = [];

      // if (await _isConnectTOInternet()) {
      _vitals = await _vitalsAndWellnessRepository.fetchVitals(
        familyId: _me?.familyId,
        userId: _me?.id,
      );
      // } else {
      // final prefs = await SharedPreferences.getInstance();
      // var list = prefs.getStringList('${_me?.id}_vitals');
      //
      // print(list);
      //
      // if (list != null) {
      //   for (var vital in list) {
      //     Vital item = Vital.fromJson(jsonDecode(vital));
      //     _vitals.add(item);
      //   }
      // }
      // print("%%%%%%%%%%%%%%%%%%%% vitals offline ");
      // print(_vitals);
      // }

      emit(state.copyWith(
        vitalList: _vitals,
        status: VitalsAndWellnessStatus.success,
      ));

      List<Vital> _listForHistory = List.from(_vitals);
      _listForHistory.addAll(_wellnessList);
      _historyBloc.add(SyncListOfVitals(
        _listForHistory,
      ));

      emit(state.copyWith(status: VitalsAndWellnessStatus.success));
    } catch (er) {
      if (kDebugMode) {
        print(er.toString());
      }
      emit(state.copyWith(status: VitalsAndWellnessStatus.failure));
    }
  }

  void _onFetchWellness(FetchWellness event, Emitter emit) async {
    try {
      emit(state.copyWith(status: VitalsAndWellnessStatus.initial));
      emit(state.copyWith(status: VitalsAndWellnessStatus.loading));

      _vitalsAndWellnessRepository = VitalsAndWellnessRepository();


      List<Vital> vitals = state.vitalList;
      List<Vital> _wellnessList = [];

      List<Vital> _wellness = await _vitalsAndWellnessRepository.fetchWellness(
        familyId: _me?.familyId,
        userId: _me?.id,
      );

      emit(state.copyWith(
        wellnessList: _wellness,
        status: VitalsAndWellnessStatus.success,
      ));

      List<Vital> _listForHistory = List.from(vitals);
      _listForHistory.addAll(_wellnessList);
      _historyBloc.add(SyncListOfVitals(
        _listForHistory,
      ));
      emit(state.copyWith(status: VitalsAndWellnessStatus.success));
    } catch (er) {
      if (kDebugMode) {
        print(er.toString());
      }
      emit(state.copyWith(status: VitalsAndWellnessStatus.failure));
    }
  }

  void _onSyncVitalDeviceData(
    SyncVitalDeviceData event,
    Emitter emit,
  ) async {
    List<Vital> _vitals = List.from(state.vitalList);
    VitalDevice _device = event.device;

    if (_device.deviceType == VitalType.bp ||
        _device.deviceType == VitalType.spo2) {
      add(SyncVitalDeviceData(
        _device.copyWith(deviceType: VitalType.heartRate),
      ));
    }

    int index = _vitals.indexWhere(
      (vital) => vital.vitalType == _device.deviceType,
    );

    if (index > -1) {
      List<VitalDevice> _devices = List.from(_vitals[index].connectedDevices);
      int _vdIndex =
          _devices.indexWhere((vd) => vd.hardwareId == _device.hardwareId);

      if (_vdIndex > -1) {
        _vitals[index] = _vitals[index].copyWith(
          connected: _devices.isNotEmpty,
          reading: _device.lastReading,
          time: _device.readAt,
          count: _vitals[index].count + 1,
        );
      } else {
        _devices.add(_device);
        _vitals[index] = _vitals[index].copyWith(
          connected: _devices.isNotEmpty,
          reading: _device.lastReading,
          time: _device.readAt,
          connectedDevices: _devices,
          count: _vitals[index].count + 1,
        );
      }
    }
    emit(state.copyWith(vitalList: _vitals));
  }

  void _onSyncConnectedVital(SyncConnectedVital event, Emitter emit) async {
    List<Vital> _vitals = List.from(state.vitalList);
    VitalDevice _device = event.device;

    if (_device.deviceType == VitalType.bp ||
        _device.deviceType == VitalType.spo2) {
      add(SyncConnectedVital(
        _device.copyWith(deviceType: VitalType.heartRate),
      ));
    }

    int _vitalIndex = _vitals.indexWhere(
      (vital) => vital.vitalType == _device.deviceType,
    );
    if (_vitalIndex > -1) {
      List<VitalDevice> _devices =
          List.from(_vitals[_vitalIndex].connectedDevices);
      int _deviceIndex =
          _devices.indexWhere((vd) => vd.hardwareId == _device.hardwareId);

      if (_deviceIndex > -1) {
        int count = _vitals[_vitalIndex].count;
        if (_device.deviceType == VitalType.fallDetection &&
            _vitals[_vitalIndex].reading.fallDetection) {
          count += 1;
        }

        _vitals[_vitalIndex] = _vitals[_vitalIndex].copyWith(
          connected: _devices.isNotEmpty,
          connectedDevices: _devices,
          count: count,
        );
      } else {
        _devices.add(_device);
        int count = _vitals[_vitalIndex].count;
        if (_device.deviceType == VitalType.fallDetection &&
            _vitals[_vitalIndex].reading.fallDetection) {
          count += 1;
        }
        _vitals[_vitalIndex] = _vitals[_vitalIndex].copyWith(
          connected: _devices.isNotEmpty,
          connectedDevices: _devices,
          count: count,
        );
      }
    }

    emit(state.copyWith(vitalList: _vitals));
  }

  void _onSyncDisconnectedVital(
    SyncDisconnectedVital event,
    Emitter emit,
  ) async {
    List<Vital> _vitals = List.from(state.vitalList);
    VitalDevice _device = event.device;

    if (_device.deviceType == VitalType.bp ||
        _device.deviceType == VitalType.spo2) {
      add(SyncDisconnectedVital(
        _device.copyWith(deviceType: VitalType.heartRate),
      ));
    }
    int index = _vitals.indexWhere(
      (vital) => vital.vitalType == _device.deviceType,
    );
    if (index > -1) {
      List<VitalDevice> _devices = List.from(_vitals[index].connectedDevices);
      _devices.removeWhere((dev) => dev.hardwareId == _device.hardwareId);
      _vitals[index] = _vitals[index].copyWith(
        connected: _devices.isNotEmpty,
        connectedDevices: _devices,
      );
    }

    emit(state.copyWith(vitalList: _vitals));
  }

  //wellness
  void _onSyncConnectedWellness(
      SyncConnectedWellness event, Emitter emit) async {
    List<Vital> _wellnessList = List.from(state.wellnessList);
    VitalDevice _device = event.device;

    if (_device.deviceType == VitalType.fitness) {
      add(SyncConnectedVital(
        _device.copyWith(deviceType: VitalType.activity),
      ));
      add(SyncConnectedVital(
        _device.copyWith(deviceType: VitalType.sleep),
      ));
    } else {
      int index = _wellnessList.indexWhere(
        (vital) => vital.vitalType == _device.deviceType,
      );
      if (index > -1) {
        List<VitalDevice> _devices = List.from(
          _wellnessList[index].connectedDevices,
        );
        int _vdIndex =
            _devices.indexWhere((vd) => vd.hardwareId == _device.hardwareId);
        if (_vdIndex > -1) {
          _wellnessList[index] = _wellnessList[index].copyWith(
            connected: _devices.isNotEmpty,
            connectedDevices: _devices,
          );
        } else {
          _devices.add(_device);
          _wellnessList[index] = _wellnessList[index].copyWith(
            connected: _devices.isNotEmpty,
            connectedDevices: _devices,
          );
        }
      }

      emit(state.copyWith(vitalList: _wellnessList));
    }
  }

  void _onSyncDisconnectedWellness(
    SyncDisconnectedWellness event,
    Emitter emit,
  ) async {
    List<Vital> _wellnessList = List.from(state.wellnessList);
    VitalDevice _device = event.device;

    if (_device.deviceType == VitalType.fitness) {
      add(SyncDisconnectedVital(
        _device.copyWith(deviceType: VitalType.sleep),
      ));
      add(SyncDisconnectedVital(
        _device.copyWith(deviceType: VitalType.activity),
      ));
    } else {
      int index = _wellnessList.indexWhere(
        (vital) => vital.vitalType == _device.deviceType,
      );
      if (index > -1) {
        List<VitalDevice> _devices =
            List.from(_wellnessList[index].connectedDevices);
        _devices.removeWhere((dev) => dev.hardwareId == _device.hardwareId);
        _wellnessList[index] = _wellnessList[index].copyWith(
          connected: _devices.isNotEmpty,
          connectedDevices: _devices,
        );
      }

      emit(state.copyWith(vitalList: _wellnessList));
    }
  }

  void _onSyncWellnessData(
    SyncWellnessDeviceData event,
    Emitter emit,
  ) async {
    List<Vital> _wellnessList = List.from(state.wellnessList);
    VitalDevice _device = event.device;

    if (_device.deviceType == VitalType.fitness) {
      add(SyncVitalDeviceData(
        _device.copyWith(deviceType: VitalType.sleep),
      ));
      add(SyncVitalDeviceData(
        _device.copyWith(deviceType: VitalType.activity),
      ));
    }

    int index = _wellnessList.indexWhere(
      (vital) => vital.vitalType == _device.deviceType,
    );

    if (index > -1) {
      List<VitalDevice> _devices =
          List.from(_wellnessList[index].connectedDevices);
      int _vdIndex =
          _devices.indexWhere((vd) => vd.hardwareId == _device.hardwareId);

      if (_vdIndex > -1) {
        _wellnessList[index] = _wellnessList[index].copyWith(
          connected: _devices.isNotEmpty,
          reading: _device.lastReading,
          time: _device.readAt,
          count: _wellnessList[index].count + 1,
        );
      } else {
        _devices.add(_device);
        _wellnessList[index] = _wellnessList[index].copyWith(
          connected: _devices.isNotEmpty,
          reading: _device.lastReading,
          time: _device.readAt,
          connectedDevices: _devices,
          count: _wellnessList[index].count + 1,
        );
      }
    }
    emit(state.copyWith(vitalList: _wellnessList));
  }

  void _onSyncUpdatedManualReading(
    SyncUpdatedManualReading event,
    Emitter emit,
  ) async {
    List<Vital> vitals = List.of(state.vitalList);
    List<Vital> wellnessList = List.of(state.wellnessList);
    int index = vitals.indexWhere((e) => e.vitalType == event.vital.vitalType);
    if (index > -1) {
      if (vitals[index].time == null ||
          vitals[index].time! < event.vital.time!) {
        vitals[index] = vitals[index].copyWith(
          reading: event.vital.reading,
          time: event.vital.time,
          count: vitals[index].count + 1,
        );
      }
    } else {
      int _wellnessIndex = wellnessList.indexWhere(
        (e) => e.vitalType == event.vital.vitalType,
      );
      if (_wellnessIndex > -1) {
        if (wellnessList[_wellnessIndex].time == null ||
            wellnessList[_wellnessIndex].time! < event.vital.time!) {
          wellnessList[_wellnessIndex] = wellnessList[_wellnessIndex].copyWith(
            reading: event.vital.reading,
            time: event.vital.time,
            count: wellnessList[_wellnessIndex].count + 1,
          );
        }
      }
    }
    emit(state.copyWith(vitalList: vitals, wellnessList: wellnessList));
  }

  @override
  VitalsAndWellnessState? fromJson(Map<String, dynamic> json) {
    VitalsAndWellnessState saved = VitalsAndWellnessState.fromJson(json);
    List<Vital> _vitals = List.from(saved.vitalList);
    _vitals.addAll(saved.wellnessList);
    _historyBloc.add(SyncListOfVitals(
      _vitals,
    ));
    return saved;
  }

  @override
  Map<String, dynamic>? toJson(VitalsAndWellnessState state) {
    return state.toJson();
  }

  @override
  Future<void> close() {
    _vitalsProviderToHistory?.cancel();
    return super.close();
  }
}

Future<bool> _isConnectTOInternet() async {
  return await ConnectivityWrapper.instance.isConnected;
}
