import 'dart:convert';

import 'package:famici/utils/barrel.dart';

class UploadStatus {
  UploadStatus({
    this.status = Status.initial,
    this.progress = 0.0,
  });

  final Status? status;
  final double? progress;

  UploadStatus copyWith({
    Status? status,
    double? progress,
  }) =>
      UploadStatus(
        status: status ?? this.status,
        progress: progress ?? this.progress,
      );

  factory UploadStatus.fromRawJson(String str) =>
      UploadStatus.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UploadStatus.fromJson(Map<String, dynamic> json) => UploadStatus(
        status: Status.values.firstWhere(
            (state) => state.name == json["status"],
            orElse: () => Status.unknown),
        progress: json["progress"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "progress": progress,
      };
}
