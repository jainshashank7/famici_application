import 'dart:convert';

class Memory {
  Memory({
    this.contactId,
    this.createdAt,
    this.familyId,
    this.mediaCount,
    this.type,
    this.uploadId,
    this.metadata
  });

  final String? contactId;
  final dynamic createdAt;
  final String? familyId;
  final int? mediaCount;
  final String? type;
  final String? uploadId;
  final MetaData? metadata;

  Memory copyWith({
    String? contactId,
    dynamic createdAt,
    String? familyId,
    int? mediaCount,
    String? type,
    String? uploadId,
    MetaData? metadata
  }) =>
      Memory(
        contactId: contactId ?? this.contactId,
        createdAt: createdAt ?? this.createdAt,
        familyId: familyId ?? this.familyId,
        mediaCount: mediaCount ?? this.mediaCount,
        type: type ?? this.type,
        uploadId: uploadId ?? this.uploadId,
          metadata:metadata??this.metadata
      );

  factory Memory.fromRawJson(String str) => Memory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Memory.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Memory();
    }
    return Memory(
      contactId: json["contactId"],
      createdAt: json["createdAt"],
      familyId: json["familyId"],
      mediaCount: json["mediaCount"],
      type: json["type"],
      uploadId: json["uploadId"],
      metadata:MetaData.fromJson(json["media"][0]),

    );
  }

  Map<String, dynamic> toJson() => {
    "contactId": contactId,
    "createdAt": createdAt,
    "familyId": familyId,
    "mediaCount": mediaCount,
    "type": type,
    "uploadId": uploadId,
  };
}
class MetaData {
  MetaData({
    this.key,
    this.mediaId,
    this.uploadUrl,
  });

  final String? key;
  final String? mediaId;
  final String? uploadUrl;

  MetaData copyWith({
    String? key,
    String? mediaId,
    String? uploadUrl
  }) =>
      MetaData(
        key: key ?? this.key,
        mediaId: mediaId ?? this.mediaId,
        uploadUrl: uploadUrl ?? this.uploadUrl,
      );

  factory MetaData.fromRawJson(String str) => MetaData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MetaData.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return MetaData();
    }
    return MetaData(
      key: json["key"],
      mediaId: json["mediaId"],
      uploadUrl: json["uploadUrl"],
    );
  }

  Map<String, dynamic> toJson() => {
    "key": key,
    "mediaId": mediaId,
    "uploadUrl": uploadUrl,
  };
}