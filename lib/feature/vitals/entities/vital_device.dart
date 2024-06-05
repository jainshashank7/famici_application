import 'dart:convert';

import 'package:livecare/livecare.dart';
import 'package:famici/feature/health_and_wellness/vitals_and_wellness/entity/vital.dart';

class VitalDevice {
  VitalDevice({
    this.contactId,
    this.familyId,
    this.createdAt,
    this.readAt,
    this.deviceId,
    this.deviceName,
    VitalType? deviceType,
    this.connected = false,
    this.hardwareId,
    this.lastReading,
  }) : deviceType = deviceType ?? VitalType.unknown;

  String? contactId;
  String? familyId;
  int? createdAt;
  int? readAt;
  String? deviceId;
  String? deviceName;
  VitalType deviceType;
  bool connected;
  String? hardwareId;
  Reading? lastReading;

  VitalDevice copyWith({
    String? contactId,
    String? familyId,
    int? createdAt,
    int? readAt,
    String? deviceId,
    String? deviceName,
    VitalType? deviceType,
    bool? connected,
    String? hardwareId,
    Reading? lastReading,
  }) =>
      VitalDevice(
        contactId: contactId ?? this.contactId,
        familyId: familyId ?? this.familyId,
        createdAt: createdAt ?? this.createdAt,
        readAt: readAt ?? this.readAt,
        deviceId: deviceId ?? this.deviceId,
        deviceName: deviceName ?? this.deviceName,
        deviceType: deviceType ?? this.deviceType,
        connected: connected ?? this.connected,
        hardwareId: hardwareId ?? this.hardwareId,
        lastReading: lastReading ?? this.lastReading,
      );

  factory VitalDevice.fromRawJson(String str) =>
      VitalDevice.fromJson(json.decode(str));

  static List<VitalDevice> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map<VitalDevice>((device) {
      return VitalDevice.fromJson(device);
    }).toList();
  }

  String toRawJson() => json.encode(toJson());

  factory VitalDevice.fromJson(Map<String, dynamic> json) => VitalDevice(
        contactId: json["contactId"],
        familyId: json["familyId"],
        createdAt: json["createdAt"],
        readAt: json["readAt"],
        deviceId: json["deviceId"],
        hardwareId: json["hardwareId"],
        deviceName: json["deviceName"],
        lastReading: Reading.fromJson(json['lastReading']),
        deviceType: ((json["vitalTypeIds"] ?? []) as List)
            .first
            ?.toString()
            .toVitalType(),
      );

  Map<String, dynamic> toJson() {
    return {
      "contactId": contactId,
      "familyId": familyId,
      "createdAt": createdAt,
      "readAt": readAt,
      "deviceId": deviceId,
      "hardwareId": hardwareId,
      "deviceName": deviceName,
      "vitalTypeIds": [deviceType.name],
      "lastReading": lastReading?.toJson(),
    };
  }

  Map<String, dynamic> toRegisterJson() {
    List<String> _types = [deviceType.name];
    if (deviceType == VitalType.bp || deviceType == VitalType.spo2) {
      _types.add(VitalType.heartRate.name);
    }
    return {
      "hardwareId": hardwareId,
      "deviceName": deviceName,
      "vitalTypeIds": _types,
    };
  }

  factory VitalDevice.fromReadingJson(Map<String, dynamic> json) => VitalDevice(
        contactId: json["contactId"],
        familyId: json["familyId"],
        createdAt: json["createdAt"],
        readAt: json["readAt"],
        deviceId: json["deviceId"],
        hardwareId: json["hardwareId"],
        deviceName: json["deviceName"],
        lastReading: Reading.fromJson(jsonDecode(json['reading'])),
        deviceType: (json["vitalTypeId"] ?? '')?.toString().toVitalType(),
      );
}
