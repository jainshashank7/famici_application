import 'dart:convert';

import 'package:debug_logger/debug_logger.dart';
import 'package:equatable/equatable.dart';

import 'notification_body.dart';

class Notification extends Equatable {
  Notification({
    String? type,
    String? notificationId,
    String? familyId,
    String? contactId,
    String? title,
    String? description,
    String? senderContactId,
    String? senderName,
    String? senderPicture,
    String? status,
    String? groupKey,
    DateTime? createdAt,
    DateTime? updatedAt,
    NotificationBody? body,
  })  : type = type ?? '',
        notificationId = notificationId ?? '',
        familyId = familyId ?? '',
        contactId = contactId ?? '',
        title = title ?? '',
        description = description ?? '',
        senderContactId = senderContactId ?? '',
        senderName = senderName ?? '',
        senderPicture = senderPicture ?? '',
        status = status ?? '',
        updatedAt = updatedAt ?? DateTime.now(),
        createdAt = createdAt ?? DateTime.now(),
        body = body ?? NotificationBody(),
        groupKey = groupKey ?? '';

  final String type;
  final String notificationId;
  final String senderContactId;
  final String familyId;
  final String contactId;
  final String title;
  final String description;
  final String senderName;
  final String senderPicture;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final NotificationBody body;
  final String groupKey;

  Notification copyWith({
    String? type,
    String? notificationId,
    String? familyId,
    String? contactId,
    String? title,
    String? description,
    String? senderContactId,
    String? senderName,
    String? senderPicture,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    NotificationBody? body,
    String? groupKey,
  }) {
    return Notification(
      type: type ?? this.type,
      notificationId: notificationId ?? this.notificationId,
      familyId: familyId ?? this.familyId,
      contactId: contactId ?? this.contactId,
      title: title ?? this.title,
      description: description ?? this.description,
      senderName: senderName ?? this.senderName,
      senderPicture: senderPicture ?? this.senderPicture,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      body: body ?? this.body,
      senderContactId: senderContactId ?? this.senderContactId,
      groupKey: groupKey ?? this.groupKey,
    );
  }

  factory Notification.fromRawJson(String? str) {
    if (str == null) {
      return Notification();
    }
    return Notification.fromJson(json.decode(str));
  }

  String toRawJson() => json.encode(toJson());

  factory Notification.fromJson(Map<String, dynamic>? json) {
    DebugLogger.info("notification: $json");
    if (json == null) {
      return Notification();
    }

    DateTime _createAt = DateTime.now();
    DateTime _updateAt = DateTime.now();

    dynamic createdAtValue = json["createdAt"];
    try {
      int? createdAtMilliseconds = createdAtValue;
      if (createdAtMilliseconds != null) {
        _createAt = DateTime.fromMillisecondsSinceEpoch(createdAtMilliseconds,
                isUtc: true)
            .toLocal();
      }
    } catch (err) {
      int createdAtNanoseconds = createdAtValue ?? 0;
      _createAt = DateTime.fromMicrosecondsSinceEpoch(
              createdAtNanoseconds ~/ 1000,
              isUtc: true)
          .toLocal();
    }

    dynamic updatedAtValue = json["updatedAt"];
    try {
      int? createdAtMilliseconds = updatedAtValue;
      if (createdAtMilliseconds != null) {
        _updateAt = DateTime.fromMillisecondsSinceEpoch(createdAtMilliseconds,
                isUtc: true)
            .toLocal();
      }
    } catch (err) {
      int createdAtNanoseconds = updatedAtValue ?? 0;
      _updateAt = DateTime.fromMicrosecondsSinceEpoch(
              createdAtNanoseconds ~/ 1000,
              isUtc: true)
          .toLocal();
    }

    return Notification(
      type: json["type"] ?? '',
      notificationId: json["notificationId"] ?? '',
      familyId: json["familyId"] ?? '',
      contactId: json["contactId"] ?? '',
      title: json["title"] ?? '',
      description: json["description"] ?? '',
      senderContactId: json["senderContactId"] ?? '',
      senderName: json["senderName"] ?? '',
      senderPicture: json["senderPicture"] ?? '',
      status: json["status"],
      createdAt: _createAt,
      updatedAt: _updateAt,
      body: NotificationBody.fromJson(json['data']),
      groupKey: json['groupKey'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "type": type,
        "notificationId": notificationId,
        "familyId": familyId,
        "contactId": contactId,
        "title": title,
        "description": description,
        "senderName": senderName,
        "senderContactId": senderContactId,
        "senderPicture": senderPicture,
        "status": status,
        "createdAt": createdAt.microsecondsSinceEpoch,
        "updatedAt": updatedAt.microsecondsSinceEpoch,
        "data": body.toJson(),
        "groupKey": groupKey,
      };

  @override
  List<Object?> get props => [
        title,
        type,
        notificationId,
        familyId,
        contactId,
        description,
        senderContactId,
        senderName,
        senderPicture,
        status,
        createdAt,
        updatedAt,
        body,
        groupKey,
      ];
}
