import 'dart:convert';

import 'package:livecare/livecare.dart';
import 'package:famici/feature/health_and_wellness/vitals_and_wellness/entity/vital.dart';
import 'package:famici/feature/vitals/blocs/vital_cloud_sync/vital_cloud_sync_bloc.dart';
import 'package:famici/feature/vitals/entities/new_manual_reading.dart';
import 'package:famici/feature/vitals/entities/vital_device.dart';

class OfflineSavedRequest {
  OfflineSavedRequest({
    required this.qId,
    required this.device,
    required this.fId,
    required this.action,
    this.readings = const [],
    this.isManual = false,
    this.vital,
  });

  final int qId;
  final VitalDevice device;
  final List<NewManualReading> readings;
  final Vital? vital;
  final String fId;
  final DeviceRequestAction action;
  final bool isManual;

  OfflineSavedRequest copyWith({
    int? qId,
    VitalDevice? device,
    String? fId,
    DeviceRequestAction? action,
    bool? isManual,
    List<NewManualReading>? readings,
    Vital? vital,
  }) =>
      OfflineSavedRequest(
        qId: qId ?? this.qId,
        device: device ?? this.device,
        fId: fId ?? this.fId,
        action: action ?? this.action,
        isManual: isManual ?? this.isManual,
        vital: vital ?? this.vital,
        readings: readings ?? this.readings,
      );

  factory OfflineSavedRequest.fromRawJson(String str) =>
      OfflineSavedRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OfflineSavedRequest.fromJson(Map<String, dynamic> json) =>
      OfflineSavedRequest(
        qId: json["qId"],
        device: VitalDevice.fromJson(json["device"]),
        fId: json["fId"],
        action: ((json["action"] ?? '') as String).toRequestActionType(),
        isManual: json["isManual"],
        vital: json['vital'] != null ? Vital.fromJson(json['vital']) : null,
        readings: (json['readings'] as List)
            .map<NewManualReading>((e) => NewManualReading.fromJson(json))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        "qId": qId,
        "device": device.toJson(),
        "fId": fId,
        "action": action.name,
        "isManual": isManual,
        "readings": readings.map((e) => e.toJson()).toList(),
        "vital": vital?.toJson(),
      };
}
