// To parse this JSON data, do
//
//     final joinFamilyResponse = joinFamilyResponseFromJson(jsonString);

import 'dart:convert';

class JoinFamilyResponse {
  JoinFamilyResponse(
      {String? contactId,
      int? createdAt,
      String? createdBy,
      int? expireAt,
      String? familyName,
      String? familyId,
      String? givenName,
      String? inviteCode,
      String? status,
      String? username,
      bool? isAccepted})
      : contactId = contactId ?? '',
        createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch,
        createdBy = createdBy ?? '',
        expireAt = expireAt ?? DateTime.now().millisecondsSinceEpoch,
        familyName = familyName ?? '',
        familyId = familyId ?? '',
        givenName = givenName ?? '',
        inviteCode = inviteCode ?? '',
        status = status ?? '',
        username = username ?? '',
        isAccepted = isAccepted ?? false;

  final String contactId;
  final int createdAt;
  final String createdBy;
  final int expireAt;
  final String familyName;
  final String familyId;
  final String givenName;
  final String inviteCode;
  final String status;
  final String username;
  final bool isAccepted;

  JoinFamilyResponse copyWith({
    String? contactId,
    int? createdAt,
    String? createdBy,
    int? expireAt,
    String? familyName,
    String? familyId,
    String? givenName,
    String? inviteCode,
    String? status,
    String? username,
    bool? isAccepted,
  }) =>
      JoinFamilyResponse(
        contactId: contactId ?? this.contactId,
        createdAt: createdAt ?? this.createdAt,
        createdBy: createdBy ?? this.createdBy,
        expireAt: expireAt ?? this.expireAt,
        familyName: familyName ?? this.familyName,
        familyId: familyId ?? this.familyId,
        givenName: givenName ?? this.givenName,
        inviteCode: inviteCode ?? this.inviteCode,
        status: status ?? this.status,
        username: username ?? this.username,
        isAccepted: isAccepted ?? this.isAccepted,
      );

  factory JoinFamilyResponse.fromRawJson(String str) =>
      JoinFamilyResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory JoinFamilyResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return JoinFamilyResponse();
    }
    return JoinFamilyResponse(
      contactId: json["contactId"],
      createdAt: json["createdAt"],
      createdBy: json["createdBy"],
      expireAt: json["expireAt"],
      familyName: json["familyName"],
      familyId: json["familyId"],
      givenName: json["givenName"],
      inviteCode: json["inviteCode"],
      status: json["status"],
      username: json["username"],
      isAccepted: json["status"] == 'accepted',
    );
  }

  Map<String, dynamic> toJson() => {
        "contactId": contactId,
        "createdAt": createdAt,
        "createdBy": createdBy,
        "expireAt": expireAt,
        "familyName": familyName,
        "familyId": familyId,
        "givenName": givenName,
        "inviteCode": inviteCode,
        "status": status,
        "username": username,
      };
}
