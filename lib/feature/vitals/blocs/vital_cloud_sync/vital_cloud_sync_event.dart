part of 'vital_cloud_sync_bloc.dart';

@immutable
abstract class VitalCloudSyncEvent {}

class RegisterDevice implements VitalCloudSyncEvent {
  final VitalDevice device;

  RegisterDevice(this.device);
}

class UnregisterDevice implements VitalCloudSyncEvent {
  final VitalDevice device;

  UnregisterDevice(this.device);
}

class AddDeviceReading implements VitalCloudSyncEvent {
  final VitalDevice device;

  AddDeviceReading(this.device);
}

class SaveManualReadingToCloud implements VitalCloudSyncEvent {
  final Vital vital;
  final List<NewManualReading> readings;

  SaveManualReadingToCloud(this.vital, this.readings);
}

class CloudSyncStarted implements VitalCloudSyncEvent {}

class RegisteredDeviceWhenOffline implements VitalCloudSyncEvent {}

class UnregisteredDeviceWhenOffline implements VitalCloudSyncEvent {}

class SyncAddedReadingWhenOffline implements VitalCloudSyncEvent {}

class SyncManualAddedReadingWhenOffline implements VitalCloudSyncEvent {}
