import 'dart:convert';

class MediaUploadStatus {
  MediaUploadStatus({
    this.mediaId,
    this.url,
    this.key
  });

  final String? mediaId;
  final String? key;
  final String? url;
  MediaUploadStatus copyWith({
    String? mediaId,
    String? key,
    String? url,
  }) =>
      MediaUploadStatus(
          mediaId: mediaId ?? this.mediaId,
        key: key??this.key,
        url: url??this.url
      );

  factory MediaUploadStatus.fromRawJson(String str) => MediaUploadStatus.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MediaUploadStatus.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return MediaUploadStatus();
    }
    return MediaUploadStatus(
      mediaId: json["mediaId"],
      url: json["url"],
      key: json["key"]

    );
  }

  Map<String, dynamic> toJson() => {
    "mediaId": mediaId,
    "url": url,
    "key": key,

  };
}