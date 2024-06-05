part of 'vital_sync_bloc.dart';

class VitalSyncState {
  VitalSyncState({
    required this.myDevices,
    required this.availableDevices,
    required this.bluetoothEnabled,
    required this.selectedAvailableDevice,
    required this.scanning,
  });

  Map<String, VitalDevice> myDevices;
  Map<String, VitalDevice> availableDevices;
  bool bluetoothEnabled;
  VitalDevice selectedAvailableDevice;
  bool scanning;

  factory VitalSyncState.initial() {
    return VitalSyncState(
      myDevices: {},
      availableDevices: {},
      bluetoothEnabled: false,
      selectedAvailableDevice: VitalDevice(),
      scanning: false,
    );
  }

  VitalSyncState copyWith({
    Map<String, VitalDevice>? myDevices,
    Map<String, VitalDevice>? availableDevices,
    bool? bluetoothEnabled,
    VitalDevice? selectedAvailableDevice,
    bool? scanning,
    bool? shouldFetch,
  }) {
    return VitalSyncState(
      myDevices: myDevices ?? this.myDevices,
      availableDevices: availableDevices ?? this.availableDevices,
      bluetoothEnabled: bluetoothEnabled ?? this.bluetoothEnabled,
      selectedAvailableDevice:
          selectedAvailableDevice ?? this.selectedAvailableDevice,
      scanning: scanning ?? this.scanning,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "myDevices": myDevices.map((key, value) => MapEntry(key, value.toJson()))
    };
  }

  factory VitalSyncState.fromJson(dynamic json) {
    VitalSyncState _state = VitalSyncState.initial();

    return _state.copyWith(
      myDevices: (json['myDevices'] as Map).map(
        (key, value) => MapEntry(key, VitalDevice.fromJson(value)),
      ),
    );
  }
}
