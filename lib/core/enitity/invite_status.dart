// To parse this JSON data, do
//
//     final inviteStatus = inviteStatusFromJson(jsonString);

import 'dart:convert';

class InviteStatus {
  InviteStatus({
    String? contactId,
    int? createdAt,
    String? createdBy,
    int? expireAt,
    String? familyId,
    String? familyName,
    String? givenName,
    String? status,
    String? username,
    bool? isActive,
  })  : contactId = contactId ?? '',
        createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch,
        createdBy = createdBy ?? '',
        expireAt = expireAt ?? DateTime.now().millisecondsSinceEpoch,
        familyId = familyId ?? '',
        familyName = familyName ?? '',
        givenName = givenName ?? '',
        status = status ?? '',
        username = username ?? '',
        isActive = isActive ?? false;

  final String contactId;
  final int createdAt;
  final dynamic createdBy;
  final int expireAt;
  final String familyId;
  final dynamic familyName;
  final dynamic givenName;
  final String status;
  final String username;
  final bool isActive;

  InviteStatus copyWith({
    String? contactId,
    int? createdAt,
    String? createdBy,
    int? expireAt,
    String? familyId,
    String? familyName,
    String? givenName,
    String? status,
    String? username,
    bool? isActive,
  }) =>
      InviteStatus(
        contactId: contactId ?? this.contactId,
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy ?? this.createdBy,
        expireAt: expireAt ?? this.expireAt,
        familyId: familyId ?? this.familyId,
        familyName: familyName ?? this.familyName,
        givenName: givenName ?? this.givenName,
        status: status ?? this.status,
        username: username ?? this.username,
        isActive: isActive ?? this.isActive,
      );

  factory InviteStatus.fromRawJson(String? str) {
    if (str == null) {
      return InviteStatus();
    }
    return InviteStatus.fromJson(json.decode(str));
  }

  String toRawJson() => json.encode(toJson());

  factory InviteStatus.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return InviteStatus();
    }
    return InviteStatus(
      contactId: json["contactId"] ?? '',
      createdAt: json["createdAt"] ?? DateTime.now().millisecondsSinceEpoch,
      createdBy: json["createdBy"] ?? "",
      expireAt: json["expireAt"] ?? DateTime.now().millisecondsSinceEpoch,
      familyId: json["familyId"] ?? '',
      familyName: json["familyName"] ?? '',
      givenName: json["givenName"] ?? '',
      status: json["status"] ?? '',
      username: json["username"] ?? '',
      isActive: (json["status"] ?? "").toString() == 'accepted',
    );
  }

  Map<String, dynamic> toJson() => {
        "contactId": contactId,
        "createdAt": createdAt,
        "createdBy": createdBy,
        "expireAt": expireAt,
        "familyId": familyId,
        "familyName": familyName,
        "givenName": givenName,
        "status": status,
        "username": username,
        "isActive": isActive,
      };
}
