part of 'vital_cloud_sync_bloc.dart';

enum SyncStatus {
  initial,
  syncing,
  done,
}

enum DeviceRequestAction {
  none,
  create,
  update,
  delete,
  addReading,
}

extension DeviceRequestActionExt on String {
  DeviceRequestAction toRequestActionType() {
    return DeviceRequestAction.values.firstWhere(
      (value) => this == value.name,
      orElse: () => DeviceRequestAction.none,
    );
  }
}

class VitalCloudSyncState {
  VitalCloudSyncState({
    required this.status,
    required this.offlineDeviceRequest,
  });

  List<OfflineSavedRequest> offlineDeviceRequest;

  final SyncStatus status;

  factory VitalCloudSyncState.initial() {
    return VitalCloudSyncState(
      status: SyncStatus.initial,
      offlineDeviceRequest: [],
    );
  }

  VitalCloudSyncState copyWith({
    SyncStatus? status,
    List<OfflineSavedRequest>? offlineDeviceRequest,
  }) {
    return VitalCloudSyncState(
      status: status ?? this.status,
      offlineDeviceRequest: offlineDeviceRequest ?? this.offlineDeviceRequest,
    );
  }

  factory VitalCloudSyncState.fromJson(Map<String, dynamic> json) {
    VitalCloudSyncState state = VitalCloudSyncState.initial();

    List<OfflineSavedRequest> _req = ((json['persisted'] ?? []) as List)
        .map<OfflineSavedRequest>((e) => OfflineSavedRequest.fromJson(e))
        .toList();

    return state.copyWith(offlineDeviceRequest: _req);
  }

  Map<String, dynamic> toJson() {
    return {"persisted": offlineDeviceRequest.map((e) => e.toJson()).toList()};
  }
}
