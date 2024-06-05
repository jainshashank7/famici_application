// To parse this JSON data, do
//
//     final heartBeat = heartBeatFromJson(jsonString);

import 'dart:convert';

class HeartBeat {
  HeartBeat({
    String? activeStatus,
    String? contactId,
    String? familyId,
    DateTime? lastActiveTime,
  })  : activeStatus = activeStatus ?? '',
        contactId = contactId ?? '',
        familyId = familyId ?? '',
        lastActiveTime = lastActiveTime ?? DateTime.now();

  final String activeStatus;
  final String contactId;
  final String familyId;
  final DateTime lastActiveTime;

  HeartBeat copyWith({
    String? activeStatus,
    String? contactId,
    String? familyId,
    DateTime? lastActiveTime,
  }) =>
      HeartBeat(
        activeStatus: activeStatus ?? this.activeStatus,
        contactId: contactId ?? this.contactId,
        familyId: familyId ?? this.familyId,
        lastActiveTime: lastActiveTime ?? this.lastActiveTime,
      );

  factory HeartBeat.fromRawJson(String? str) {
    if (str == null) {
      return HeartBeat();
    }
    return HeartBeat.fromJson(json.decode(str));
  }

  String toRawJson() => json.encode(toJson());

  factory HeartBeat.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return HeartBeat();
    }
    return HeartBeat(
      activeStatus: json["presenceStatus"],
      contactId: json["contactId"],
      familyId: json["familyId"],
      lastActiveTime: json["lastActiveTime"] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              json["lastActiveTime"],
            )
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        "presenceStatus": activeStatus,
        "contactId": contactId,
        "familyId": familyId,
        "lastActiveTime": lastActiveTime,
      };
}
