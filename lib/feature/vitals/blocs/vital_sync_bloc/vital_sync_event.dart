part of 'vital_sync_bloc.dart';

@immutable
abstract class VitalSyncEvent {}

class SyncMyDevices extends VitalSyncEvent {}

class ListenToLiveCareStream extends VitalSyncEvent {}

class Scanning extends VitalSyncEvent {
  final bool isScanning;

  Scanning(this.isScanning);
}

class DeviceConnected extends VitalSyncEvent {
  final Device device;

  DeviceConnected(this.device);
}

class DataReceived extends VitalSyncEvent {
  final Device device;

  DataReceived(this.device);
}

class DeviceDisconnected extends VitalSyncEvent {
  final Device device;

  DeviceDisconnected(this.device);
}

class AddToMyDevice extends VitalSyncEvent {}

class SelectDeviceToAdd extends VitalSyncEvent {
  final VitalDevice device;

  SelectDeviceToAdd(this.device);
}

class RemoveDeviceFromMyDevices extends VitalSyncEvent {
  final VitalDevice device;

  RemoveDeviceFromMyDevices(this.device);
}

class DeviceRegisteredOnCloud extends VitalSyncEvent {
  final VitalDevice device;

  DeviceRegisteredOnCloud(this.device);
}

class DeviceUnregisteredOnCloud extends VitalSyncEvent {
  final VitalDevice device;

  DeviceUnregisteredOnCloud(this.device);
}

class ReadingUpdatedOnCloud extends VitalSyncEvent {
  final VitalDevice device;
  ReadingUpdatedOnCloud(this.device);
}

class SyncManualReadings extends VitalSyncEvent {
  final Vital vital;
  final List<NewManualReading> readings;
  SyncManualReadings(this.vital, this.readings);
}

class CancelLiveCareStream extends VitalSyncEvent {}
