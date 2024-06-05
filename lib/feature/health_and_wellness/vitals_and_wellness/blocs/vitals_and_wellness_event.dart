part of 'vitals_and_wellness_bloc.dart';

abstract class VitalsAndWellnessEvent extends Equatable {
  const VitalsAndWellnessEvent();

  @override
  List<Object> get props => [];
}

class ToggleShowVitals extends VitalsAndWellnessEvent {
  @override
  String toString() {
    return "toggle Show vitals event";
  }
}

class FetchVitals extends VitalsAndWellnessEvent {
  @override
  String toString() {
    return "fetch vitals";
  }
}

class FetchWellness extends VitalsAndWellnessEvent {
  @override
  String toString() {
    return "fetch wellness";
  }
}

class SyncVitalDeviceData extends VitalsAndWellnessEvent {
  final VitalDevice device;

  const SyncVitalDeviceData(this.device);
}

class SyncConnectedVital extends VitalsAndWellnessEvent {
  final VitalDevice device;

  const SyncConnectedVital(this.device);
}

class SyncDisconnectedVital extends VitalsAndWellnessEvent {
  final VitalDevice device;

  const SyncDisconnectedVital(this.device);
}

class SyncWellnessDeviceData extends VitalsAndWellnessEvent {
  final VitalDevice device;

  const SyncWellnessDeviceData(this.device);
}

class SyncConnectedWellness extends VitalsAndWellnessEvent {
  final VitalDevice device;

  const SyncConnectedWellness(this.device);
}

class SyncDisconnectedWellness extends VitalsAndWellnessEvent {
  final VitalDevice device;

  const SyncDisconnectedWellness(this.device);
}

class SyncUpdatedManualReading extends VitalsAndWellnessEvent {
  final Vital vital;

  const SyncUpdatedManualReading(this.vital);
}
