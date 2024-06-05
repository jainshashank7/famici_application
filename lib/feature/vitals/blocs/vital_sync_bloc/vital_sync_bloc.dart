import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:debug_logger/debug_logger.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:livecare/livecare.dart';
import 'package:meta/meta.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:famici/core/blocs/connectivity_bloc/connectivity_bloc.dart';
import 'package:famici/feature/health_and_wellness/vitals_and_wellness/blocs/vitals_and_wellness_bloc.dart';
import 'package:famici/feature/vitals/blocs/vital_cloud_sync/vital_cloud_sync_bloc.dart';
import 'package:famici/feature/vitals/entities/new_manual_reading.dart';
import 'package:famici/feature/vitals/entities/vital_device.dart';
import 'package:famici/repositories/barrel.dart';

import '../../../../core/enitity/barrel.dart';
import '../../../health_and_wellness/vitals_and_wellness/entity/vital.dart';

part 'vital_sync_event.dart';
part 'vital_sync_state.dart';

class VitalSyncBloc extends HydratedBloc<VitalSyncEvent, VitalSyncState> {
  VitalSyncBloc({
    required VitalsAndWellnessBloc vitalsAndWellnessBloc,
    required User me,
    required ConnectivityBloc connectivityBloc,
  })  : _vitalsAndWellnessBloc = vitalsAndWellnessBloc,
        _connectivityBloc = connectivityBloc,
        _me = me,
        super(VitalSyncState.initial()) {
    _cloudSyncBloc = VitalCloudSyncBloc(
      connectivityBloc: connectivityBloc,
      vitalSyncBloc: this,
      me: me,
    );
    on<SyncMyDevices>(_onSyncMyDevices);
    on<ListenToLiveCareStream>(_onListenToLiveCareStream);
    on<DeviceConnected>(_onDeviceConnected);
    on<DataReceived>(_onDataReceived);
    on<DeviceDisconnected>(_onDeviceDisconnected);
    on<AddToMyDevice>(_onAddToMyDevice);
    on<SelectDeviceToAdd>(_onSelectDeviceToAdd);
    on<RemoveDeviceFromMyDevices>(_onRemoveDeviceFromMyDevices);
    on<Scanning>(_onScanning);
    on<DeviceRegisteredOnCloud>(_onDeviceRegisteredOnCloud);
    on<DeviceUnregisteredOnCloud>(_onDeviceUnregisteredOnCloud);
    on<SyncManualReadings>(_onSyncManualReadings);
    on<CancelLiveCareStream>(_onCancelLiveCareStream);
  }

  StreamSubscription? _subscription;
  final VitalsAndWellnessBloc _vitalsAndWellnessBloc;

  final ConnectivityBloc _connectivityBloc;

  late VitalCloudSyncBloc _cloudSyncBloc;

  final DeviceRepository _deviceRepo = DeviceRepository();
  final User _me;

  bool shouldStartScanning = true;
  Future<void> _onSyncMyDevices(
    SyncMyDevices event,
    Emitter emit,
  ) async {
    try {
      Map<String, VitalDevice> _myDevices = Map.from(state.myDevices);
      List<VitalDevice> _fetched = await _deviceRepo.fetchMyDevices(
        familyId: _me.familyId,
        userId: _me.id,
      );

      for (VitalDevice device in _fetched) {
        if (_myDevices[device.hardwareId] != null) {
          _myDevices[device.hardwareId!]!.deviceId = device.deviceId;
        } else {
          _myDevices[device.hardwareId!] = device;
        }
      }

      emit(state.copyWith(myDevices: _myDevices));

      add(ListenToLiveCareStream());
    } catch (err) {
      add(ListenToLiveCareStream());
      DebugLogger.error(err);
    }
  }

  Future<void> _onListenToLiveCareStream(
    ListenToLiveCareStream event,
    Emitter emit,
  ) async {

    // print("this is started first note");

    // try{
    //
    //   var cameraStatus = await Permission.camera.status;
    //   var microPhoneStatus = await Permission.microphone.status;
    //   var notificationStatus = await Permission.notification.status;
    //
    //   if (cameraStatus.isDenied ||
    //       microPhoneStatus.isDenied ||
    //       notificationStatus.isDenied ||
    //       await Permission.bluetoothScan.isDenied ||
    //       await Permission.bluetooth.isDenied ||
    //       await Permission.location.isDenied) {
    //     await [
    //       Permission.camera,
    //       Permission.microphone,
    //       Permission.notification,
    //       Permission.location,
    //       Permission.bluetoothScan,
    //       Permission.bluetooth,
    //       Permission.bluetoothConnect,
    //       Permission.locationAlways,
    //       Permission.locationWhenInUse,
    //     ].request();
    //   }
    // } on Exception catch (e) {
    //   DebugLogger.error(e);
    // }

    var device = await DeviceInfoPlugin().androidInfo;
    bool isSupportedDevice = device.isPhysicalDevice != null;
    isSupportedDevice = isSupportedDevice && (device.isPhysicalDevice ?? false);

    if (isSupportedDevice) {
      // List<Permission> permissions = [
      //   Permission.location,
      //   Permission.bluetoothScan,
      //   Permission.bluetooth,
      //   Permission.bluetoothConnect,
      //   Permission.locationAlways,
      //   Permission.locationWhenInUse,
      //   Permission.camera,
      //   Permission.microphone,
      // ];
      //
      // for (var permission in permissions) {
      //   try {
      //     if(await permission.isDenied) {
      //       await permission.request();
      //     }
      //   } catch(err){
      //     DebugLogger.error(err);
      //   }
      // }

      if (await Permission.location.isGranted) {
        await LiveCare.initialize();
        _subscription ??= LiveCare.onEvent.listen((LiveCareEvent lcEvent) {
          if (lcEvent is LiveDeviceConnected) {
            add(DeviceConnected(lcEvent.device));
          } else if (lcEvent is LiveDeviceDisconnected) {
            add(DeviceDisconnected(lcEvent.device));
          } else if (lcEvent is LiveDataReceived) {
            add(DataReceived(lcEvent.device));
          } else if (lcEvent is LiveScanning) {
            add(Scanning(true));
          } else if (lcEvent is LiveScanCompleted) {
            add(Scanning(false));
          }
        });
      }
    }
  }

  Future<void> _onDeviceConnected(
    DeviceConnected event,
    Emitter emit,
  ) async {
    Map<String, VitalDevice> _existing = Map.from(state.myDevices);
    Map<String, VitalDevice> _available = Map.from(state.availableDevices);

    VitalDevice? _connected = _existing[event.device.id];

    if (_connected != null) {
      _vitalsAndWellnessBloc.add(SyncConnectedVital(_connected));
      _connected.connected = event.device.connected;
    } else {
      _available[event.device.id] = VitalDevice(
        hardwareId: event.device.id,
        deviceName: event.device.name,
        deviceType: event.device.type,
        connected: event.device.connected,
      );
    }

    emit(state.copyWith(
      availableDevices: _available,
      myDevices: _existing,
    ));
  }

  Future<void> _onDataReceived(
    DataReceived event,
    Emitter emit,
  ) async {
    Map<String, VitalDevice> _existing = Map.from(state.myDevices);
    VitalDevice? _device = _existing[event.device.id];
    if (_device != null) {
      _device.connected = event.device.connected;
      _device.lastReading = event.device.latestReading;
      _device.readAt = event.device.lastReadAt?.millisecondsSinceEpoch;
      _vitalsAndWellnessBloc.add(SyncVitalDeviceData(_device));

      _cloudSyncBloc.add(AddDeviceReading(_device));

      if (_device.deviceType == VitalType.bp ||
          _device.deviceType == VitalType.spo2) {
        _cloudSyncBloc.add(AddDeviceReading(
            _device.copyWith(deviceType: VitalType.heartRate)));
      }

      emit(state.copyWith(myDevices: _existing));
    }
  }

  Future<void> _onScanning(
    Scanning event,
    Emitter emit,
  ) async {
    if (shouldStartScanning && event.isScanning) {
      emit(state.copyWith(scanning: event.isScanning));
      shouldStartScanning = false;
    } else if (event.isScanning) {
      emit(state.copyWith(scanning: event.isScanning));
      Future.delayed(Duration(minutes: 1), () {
        shouldStartScanning = true;
      });
    }
  }

  Future<void> _onDeviceDisconnected(
    DeviceDisconnected event,
    Emitter emit,
  ) async {
    Map<String, VitalDevice> _existing = Map.from(state.myDevices);
    Map<String, VitalDevice> _available = Map.from(state.availableDevices);
    VitalDevice _selected = state.selectedAvailableDevice.copyWith();

    VitalDevice? _disconnected = _existing[event.device.id];

    if (_disconnected != null) {
      _vitalsAndWellnessBloc.add(SyncDisconnectedVital(_disconnected));
      _disconnected.connected = event.device.connected;
    } else if (_available[event.device.id] != null) {
      _available.remove(event.device.id);

      if (_selected.hardwareId == event.device.id) {
        _selected = VitalDevice();
      }
    }
    emit(state.copyWith(
      availableDevices: _available,
      myDevices: _existing,
      selectedAvailableDevice: _selected,
    ));
  }

  Future<void> _onAddToMyDevice(
    AddToMyDevice event,
    Emitter emit,
  ) async {
    Map<String, VitalDevice> _existing = Map.from(state.myDevices);
    Map<String, VitalDevice> _available = Map.from(state.availableDevices);
    VitalDevice _selectedDevice = state.selectedAvailableDevice.copyWith();

    if (_selectedDevice.hardwareId != null) {
      _existing[_selectedDevice.hardwareId!] = _selectedDevice;
      _available.remove(_selectedDevice.hardwareId!);
      _vitalsAndWellnessBloc.add(SyncConnectedVital(_selectedDevice));
      _cloudSyncBloc.add(RegisterDevice(_selectedDevice));
    }

    emit(state.copyWith(
      availableDevices: _available,
      myDevices: _existing,
      selectedAvailableDevice: VitalDevice(),
    ));
  }

  Future<void> _onSelectDeviceToAdd(
    SelectDeviceToAdd event,
    Emitter emit,
  ) async {
    emit(state.copyWith(
      selectedAvailableDevice: event.device,
    ));
  }

  Future<void> _onDeviceRegisteredOnCloud(
    DeviceRegisteredOnCloud event,
    Emitter emit,
  ) async {
    Map<String, VitalDevice> myDevices = Map.from(state.myDevices);
    if (myDevices[event.device.hardwareId] != null) {
      myDevices[event.device.hardwareId!] = event.device;
      emit(state.copyWith(myDevices: myDevices));
    }
  }

  Future<void> _onRemoveDeviceFromMyDevices(
    RemoveDeviceFromMyDevices event,
    Emitter emit,
  ) async {
    Map<String, VitalDevice> myDevices = Map.from(state.myDevices);
    if (myDevices[event.device.hardwareId] != null) {
      myDevices.remove(event.device.hardwareId);
      emit(state.copyWith(myDevices: myDevices));
      _cloudSyncBloc.add(UnregisterDevice(event.device));
    }
  }

  Future<void> _onDeviceUnregisteredOnCloud(
    DeviceUnregisteredOnCloud event,
    Emitter emit,
  ) async {
    Map<String, VitalDevice> myDevices = Map.from(state.myDevices);
    if (myDevices[event.device.hardwareId] != null) {
      myDevices.remove(event.device.hardwareId);
      emit(state.copyWith(myDevices: myDevices));
    }
  }

  Future<void> _onSyncManualReadings(
    SyncManualReadings event,
    Emitter emit,
  ) async {
    List<NewManualReading> _readings = event.readings;
    _readings.sort((a, b) => b.readAt - a.readAt);
    NewManualReading latestManualReading = _readings.first;
    Vital _vital = event.vital;

    _vitalsAndWellnessBloc.add(SyncUpdatedManualReading(
      _vital.copyWith(
        time: latestManualReading.readAt,
        reading: latestManualReading.toReading(),
      ),
    ));

    _cloudSyncBloc.add(SaveManualReadingToCloud(_vital, _readings));
  }

  Future<void> _onCancelLiveCareStream(
    CancelLiveCareStream event,
    Emitter emit,
  ) async {
    _subscription?.cancel();
    _subscription = null;
    LiveCare.cancel();
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  @override
  VitalSyncState? fromJson(Map<String, dynamic> json) {
    return VitalSyncState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(VitalSyncState state) {
    return state.toJson();
  }
}
