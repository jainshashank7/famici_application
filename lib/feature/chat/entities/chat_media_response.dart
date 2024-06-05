import 'dart:convert';

class ChatMediaResponse {
  ChatMediaResponse({
    String? contactId,
    int? createdAt,
    String? familyId,
    String? type,
    String? uploadId,
    List<ChatMedia>? media,
  })  : contactId = contactId ?? '',
        createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch,
        familyId = familyId ?? '',
        type = type ?? '',
        uploadId = uploadId ?? '',
        media = media ?? [];

  final String contactId;
  final int createdAt;
  final String familyId;
  final String type;
  final String uploadId;
  final List<ChatMedia> media;

  ChatMediaResponse copyWith({
    String? contactId,
    int? createdAt,
    String? familyId,
    String? type,
    String? uploadId,
    List<ChatMedia>? media,
  }) =>
      ChatMediaResponse(
        contactId: contactId ?? this.contactId,
        createdAt: createdAt ?? this.createdAt,
        familyId: familyId ?? this.familyId,
        type: type ?? this.type,
        uploadId: uploadId ?? this.uploadId,
        media: media ?? this.media,
      );

  factory ChatMediaResponse.fromRawJson(String? str) {
    if (str == null) return ChatMediaResponse();
    return ChatMediaResponse.fromJson(json.decode(str));
  }

  String toRawJson() => json.encode(toJson());

  factory ChatMediaResponse.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ChatMediaResponse();
    return ChatMediaResponse(
      contactId: json["contactId"],
      createdAt: json["createdAt"],
      familyId: json["familyId"],
      type: json["type"],
      uploadId: json["uploadId"],
      media: List<ChatMedia>.from(
        json["media"]?.map((x) => ChatMedia.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        "contactId": contactId,
        "createdAt": createdAt,
        "familyId": familyId,
        "type": type,
        "uploadId": uploadId,
        "media": List<dynamic>.from(media.map((x) => x.toJson())),
      };
}

class ChatMedia {
  ChatMedia({
    String? bucket,
    String? key,
    String? mediaId,
    String? uploadUrl,
  })  : bucket = bucket ?? '',
        key = key ?? '',
        mediaId = mediaId ?? '',
        uploadUrl = uploadUrl ?? '';

  final String bucket;
  final String key;
  final String mediaId;
  final String uploadUrl;

  ChatMedia copyWith({
    String? bucket,
    String? key,
    String? mediaId,
    String? uploadUrl,
  }) {
    return ChatMedia(
      bucket: bucket ?? this.bucket,
      key: key ?? this.key,
      mediaId: mediaId ?? this.mediaId,
      uploadUrl: uploadUrl ?? this.uploadUrl,
    );
  }

  factory ChatMedia.fromRawJson(String? str) {
    if (str == null) return ChatMedia();
    return ChatMedia.fromJson(json.decode(str));
  }

  String toRawJson() => json.encode(toJson());

  factory ChatMedia.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ChatMedia();
    return ChatMedia(
      bucket: json["bucket"],
      key: json["key"],
      mediaId: json["mediaId"],
      uploadUrl: json["uploadUrl"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "bucket": bucket,
      "key": key,
      "mediaId": mediaId,
      "uploadUrl": uploadUrl,
    };
  }
}
