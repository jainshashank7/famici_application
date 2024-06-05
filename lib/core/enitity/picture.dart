import 'dart:convert';

class Picture {
  Picture({
    this.bucket,
    this.key = '',
    this.region,
    this.uploadUrl,
    this.url = '',
  });

  final String? bucket;
  final String key;
  final dynamic region;
  final String? uploadUrl;
  final String url;

  Picture copyWith({
    String? bucket,
    String? key,
    dynamic? region,
    String? uploadUrl,
    String? url,
  }) =>
      Picture(
        bucket: bucket ?? this.bucket,
        key: key ?? this.key,
        region: region ?? this.region,
        uploadUrl: uploadUrl ?? this.uploadUrl,
        url: url ?? this.url,
      );

  factory Picture.fromRawJson(String str) => Picture.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Picture.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Picture();
    }
    return Picture(
      bucket: json["bucket"] ?? '',
      key: json["key"] ?? '',
      region: json["region"] ?? '',
      uploadUrl: json["uploadUrl"] ?? '',
      url: json["url"] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "bucket": bucket,
        "key": key,
        "region": region,
        "uploadUrl": uploadUrl,
        "url": url,
      };
}
