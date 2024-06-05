import 'dart:async';
import 'dart:developer';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:debug_logger/debug_logger.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:livecare/livecare.dart';
import 'package:meta/meta.dart';
import 'package:famici/core/blocs/connectivity_bloc/connectivity_bloc.dart';
import 'package:famici/core/enitity/barrel.dart';
import 'package:famici/feature/vitals/blocs/vital_sync_bloc/vital_sync_bloc.dart';
import 'package:famici/feature/vitals/entities/new_manual_reading.dart';
import 'package:famici/feature/vitals/entities/offline_vital_request.dart';
import 'package:famici/feature/vitals/entities/vital_device.dart';
import 'package:famici/repositories/barrel.dart';

import '../../../health_and_wellness/vitals_and_wellness/entity/vital.dart';

part 'vital_cloud_sync_event.dart';
part 'vital_cloud_sync_state.dart';

class VitalCloudSyncBloc
    extends HydratedBloc<VitalCloudSyncEvent, VitalCloudSyncState> {
  VitalCloudSyncBloc({
    required ConnectivityBloc connectivityBloc,
    required VitalSyncBloc vitalSyncBloc,
    required User me,
  })  : _me = me,
        _connectivityBloc = connectivityBloc,
        _vitalSyncBloc = vitalSyncBloc,
        super(VitalCloudSyncState.initial()) {
    on<RegisterDevice>(_onRegisterDevice);
    on<UnregisterDevice>(_onUnregisterDevice);
    on<AddDeviceReading>(_onAddDeviceReading);
    on<SaveManualReadingToCloud>(_onSaveManualReadingToCloud);
    on<CloudSyncStarted>(_onCloudSyncStart);
    connectivityBloc.stream.listen((event) {
      isOnline = event.hasInternet;
      if (event.hasInternet) {
        add(CloudSyncStarted());
      }
    });
  }

  final ConnectivityBloc _connectivityBloc;
  final VitalSyncBloc _vitalSyncBloc;
  final User _me;

  final DeviceRepository _deviceRepo = DeviceRepository();
  bool isOnline = false;

  void _onRegisterDevice(RegisterDevice event, emit) async {
    if (isOnline) {
      try {
        VitalDevice _registered = await _deviceRepo.register(
          familyId: _me.familyId,
          device: event.device,
        );
        _vitalSyncBloc.add(DeviceRegisteredOnCloud(_registered));
      } catch (err) {
        DebugLogger.error(err);
      }
    } else {
      List<OfflineSavedRequest> _offlineBackup = state.offlineDeviceRequest;
      OfflineSavedRequest request = OfflineSavedRequest(
        qId: DateTime.now().microsecondsSinceEpoch,
        device: event.device,
        fId: _me.familyId!,
        action: DeviceRequestAction.create,
      );

      _offlineBackup.add(request);
      emit(state.copyWith(offlineDeviceRequest: _offlineBackup));
    }
  }

  void _onUnregisterDevice(UnregisterDevice event, emit) async {
    if (isOnline) {
      try {
        VitalDevice _registered =
            await _deviceRepo.removeDevice(deviceId: event.device.deviceId!);
        _vitalSyncBloc.add(DeviceUnregisteredOnCloud(_registered));
      } catch (err) {
        DebugLogger.error(err);
      }
    } else {
      List<OfflineSavedRequest> _offlineBackup = state.offlineDeviceRequest;
      OfflineSavedRequest request = OfflineSavedRequest(
        qId: DateTime.now().microsecondsSinceEpoch,
        device: event.device,
        fId: _me.familyId!,
        action: DeviceRequestAction.create,
      );

      _offlineBackup.add(request);
      emit(state.copyWith(offlineDeviceRequest: _offlineBackup));
    }
  }

  void _onAddDeviceReading(AddDeviceReading event, emit) async {
    if (isOnline) {
      try {
        VitalDevice _added = await _deviceRepo.saveDeviceReading(
          familyId: _me.familyId,
          device: event.device,
        );
      } catch (err) {
        DebugLogger.error(err);
      }
    } else {
      List<OfflineSavedRequest> _offlineBackup = state.offlineDeviceRequest;

      OfflineSavedRequest request = OfflineSavedRequest(
        qId: DateTime.now().microsecondsSinceEpoch,
        device: event.device,
        fId: _me.familyId!,
        action: DeviceRequestAction.addReading,
      );

      _offlineBackup.add(request);

      emit(state.copyWith(offlineDeviceRequest: _offlineBackup));
    }
  }

  void _onSaveManualReadingToCloud(SaveManualReadingToCloud event, emit) async {
    if (_connectivityBloc.state.hasInternet) {
      try {
        await _deviceRepo.addManualReadings(
          familyId: _me.familyId,
          vital: event.vital,
          readings: event.readings,
        );
      } catch (err) {
        DebugLogger.error(err);
      }
    } else {
      List<OfflineSavedRequest> _offlineBackup = state.offlineDeviceRequest;

      OfflineSavedRequest request = OfflineSavedRequest(
        qId: DateTime.now().microsecondsSinceEpoch,
        device: VitalDevice(),
        fId: _me.familyId!,
        action: DeviceRequestAction.addReading,
        isManual: true,
        vital: event.vital,
        readings: event.readings,
      );

      _offlineBackup.add(request);
      emit(state.copyWith(offlineDeviceRequest: _offlineBackup));
    }
  }

  void _onCloudSyncStart(CloudSyncStarted event, emit) async {
    if (state.status != SyncStatus.syncing) {
      emit(state.copyWith(status: SyncStatus.syncing));
      List<OfflineSavedRequest> _saved = List.from(state.offlineDeviceRequest);
      List<OfflineSavedRequest> _next = List.from(state.offlineDeviceRequest);
      for (OfflineSavedRequest request in _saved) {
        if (isOnline && _saved.isNotEmpty) {
          if (request.action == DeviceRequestAction.create) {
            try {
              VitalDevice _registered = await _deviceRepo.register(
                familyId: request.fId,
                device: request.device,
              );
              _vitalSyncBloc.add(DeviceRegisteredOnCloud(_registered));
              _next.removeWhere((e) => e.qId == request.qId);
            } catch (err) {
              DebugLogger.error(err);
            }
          } else if (request.action == DeviceRequestAction.addReading) {
            try {
              if (request.isManual) {
                await _deviceRepo.addManualReadings(
                  familyId: _me.familyId,
                  vital: request.vital!,
                  readings: request.readings,
                );
              } else {
                VitalDevice _added = await _deviceRepo.saveDeviceReading(
                  familyId: request.fId,
                  device: request.device,
                  isManual: request.isManual,
                );
              }

              _next.removeWhere((e) => e.qId == request.qId);
            } catch (err) {
              DebugLogger.error(err);
            }
          } else if (request.action == DeviceRequestAction.delete) {
            try {
              VitalDevice _registered = await _deviceRepo.removeDevice(
                  deviceId: request.device.deviceId!);
              _vitalSyncBloc.add(DeviceUnregisteredOnCloud(_registered));
            } catch (err) {
              DebugLogger.error(err);
            }
          }
        } else {
          emit(state.copyWith(status: SyncStatus.initial));
          return;
        }
      }
      emit(state.copyWith(
          offlineDeviceRequest: _next, status: SyncStatus.initial));
    }
  }

  @override
  VitalCloudSyncState? fromJson(Map<String, dynamic> json) {
    return VitalCloudSyncState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(VitalCloudSyncState state) {
    return state.toJson();
  }
}
