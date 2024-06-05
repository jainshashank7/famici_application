import 'dart:convert';

import 'package:famici/feature/chat/entities/message.dart';

class MediaContent {
  MediaContent({
    String? key,
    String? url,
    String? bucketName,
    String? mediaId,
    String? local,
    String? callerTitle,
    String? calleeTitle,
    String? time,
    String? caller,
    String? body,
    CallReceiptType? type,
  })  : key = key ?? '',
        url = url ?? '',
        bucketName = bucketName ?? '',
        mediaId = mediaId ?? '',
        local = local ?? '',
        callerTitle = callerTitle ?? '',
        calleeTitle = calleeTitle ?? '',
        time = time ?? '',
        caller = caller ?? '',
        body = body ?? '',
        type = type ?? CallReceiptType.unknown;

  final String key;
  final String url;
  final String bucketName;
  final String mediaId;
  final String local;

  final String callerTitle;
  final String calleeTitle;
  final String time;
  final String caller;
  final String body;
  final CallReceiptType type;

  MediaContent copyWith({
    String? key,
    String? url,
    String? bucketName,
    String? mediaId,
    String? local,
    String? callerTitle,
    String? calleeTitle,
    String? time,
    String? caller,
    String? body,
    CallReceiptType? type,
  }) =>
      MediaContent(
        key: key ?? this.key,
        url: url ?? this.url,
        bucketName: bucketName ?? this.bucketName,
        mediaId: mediaId ?? this.mediaId,
        local: local ?? this.local,
        callerTitle: callerTitle ?? this.callerTitle,
        calleeTitle: calleeTitle ?? this.calleeTitle,
        time: time ?? this.time,
        caller: caller ?? this.caller,
        body: body ?? this.body,
        type: type ?? this.type,
      );

  factory MediaContent.fromRawJson(String? str) {
    if (str == null) {
      return MediaContent();
    }
    return MediaContent.fromJson(jsonDecode(str));
  }

  String toRawJson() => jsonEncode(toJson());

  factory MediaContent.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return MediaContent();
    }
    return MediaContent(
      key: json["key"] ?? '',
      url: json["url"] ?? '',
      bucketName: json["bucketName"] ?? '',
      mediaId: json["mediaId"] ?? '',
      local: json["local"] ?? '',
      callerTitle: json["callerTitle"] ?? '',
      calleeTitle: json["calleeTitle"] ?? '',
      time: json["time"] ?? '',
      caller: json["caller"] ?? '',
      body: json["body"] ?? '',
      type: (json["type"] ?? '').toString().toCallReceipt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "key": key,
      "url": url,
      "bucketName": bucketName,
      "mediaId": mediaId,
      "local": local,
      "callerTitle": callerTitle,
      "calleeTitle": calleeTitle,
      "time": time,
      "caller": caller,
      "body": body,
      "type": type.name,
    };
  }
}
