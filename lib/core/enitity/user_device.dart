// To parse this JSON data, do
//
//     final mediaContent = mediaContentFromJson(jsonString);

import 'dart:convert';

class UserDevice {
  UserDevice({
    this.contactId = '',
    this.createdAt = 0,
    this.deviceName = '',
    this.deviceType = 'Primary',
    this.metadata = '{}',
    this.updatedAt = 0,
    this.userDeviceId = '',
  });

  final String contactId;
  final int createdAt;
  final String deviceName;
  final String deviceType;
  final String metadata;
  final int updatedAt;
  final String userDeviceId;

  UserDevice copyWith({
    String? contactId,
    int? createdAt,
    String? deviceName,
    String? deviceType,
    String? metadata,
    int? updatedAt,
    String? userDeviceId,
  }) =>
      UserDevice(
        contactId: contactId ?? this.contactId,
        createdAt: createdAt ?? this.createdAt,
        deviceName: deviceName ?? this.deviceName,
        deviceType: deviceType ?? this.deviceType,
        metadata: metadata ?? this.metadata,
        updatedAt: updatedAt ?? this.updatedAt,
        userDeviceId: userDeviceId ?? this.userDeviceId,
      );

  factory UserDevice.fromRawJson(String? str) {
    if (str == null) {
      return UserDevice();
    }
    return UserDevice.fromJson(json.decode(str));
  }

  String toRawJson() => json.encode(toJson());

  factory UserDevice.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return UserDevice();
    }
    return UserDevice(
      contactId: json["contactId"] ?? '',
      createdAt: json["createdAt"] ?? 0,
      deviceName: json["deviceName"] ?? '',
      deviceType: json["deviceType"] ?? '',
      metadata: json["metadata"] ?? '{}',
      updatedAt: json["updatedAt"] ?? 0,
      userDeviceId: json["userDeviceId"] ?? '',
    );
  }
  Map<String, dynamic> toJson() => {
        "contactId": contactId,
        "createdAt": createdAt,
        "deviceName": deviceName,
        "deviceType": deviceType,
        "metadata": metadata,
        "userDeviceId": userDeviceId,
      };

  Map<String, dynamic> toDeviceInput() => {
        "deviceName": deviceName,
        "deviceType": deviceType,
        "metadata": metadata,
      };
}

class DeviceStatus {
  DeviceStatus({
    this.wifi = 'NotConnected',
    this.userDeviceId = '',
    this.contactId = '',
    this.bluetooth = 'NotConnected',
    this.battery = 0,
  });

  final String wifi;
  final String userDeviceId;
  final String contactId;
  final String bluetooth;
  final int battery;

  DeviceStatus copyWith({
    String? wifi,
    String? userDeviceId,
    String? contactId,
    String? bluetooth,
    int? battery,
  }) =>
      DeviceStatus(
        wifi: wifi ?? this.wifi,
        userDeviceId: userDeviceId ?? this.userDeviceId,
        contactId: contactId ?? this.contactId,
        bluetooth: bluetooth ?? this.bluetooth,
        battery: battery ?? this.battery,
      );

  factory DeviceStatus.fromRawJson(String str) =>
      DeviceStatus.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DeviceStatus.fromJson(Map<String, dynamic> json) => DeviceStatus(
        wifi: json["wifi"] ?? 'NotConnected',
        userDeviceId: json["userDeviceId"] ?? '',
        contactId: json["contactId"] ?? '',
        bluetooth: json["bluetooth"] ?? 'NotConnected',
        battery: json["battery"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "wifi": wifi,
        "userDeviceId": userDeviceId,
        "contactId": contactId,
        "bluetooth": bluetooth,
        "battery": battery,
      };

  Map<String, dynamic> toStatusInput() => {
        "wifi": wifi,
        "bluetooth": bluetooth,
        "battery": battery,
      };
}
