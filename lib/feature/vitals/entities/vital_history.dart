// To parse this JSON data, do
//
//     final vitalHistory = vitalHistoryFromJson(jsonString);

import 'dart:convert';

import 'package:livecare/livecare.dart';

class VitalHistory {
  VitalHistory({
    String? avg,
    MinMaxReading? min,
    MinMaxReading? max,
    List<Reading>? readings,
  })  : avg = avg ?? '0',
        min = min ?? MinMaxReading(),
        max = max ?? MinMaxReading(),
        readings = readings ?? [];

  final String avg;
  final MinMaxReading min;
  final MinMaxReading max;
  final List<Reading> readings;

  VitalHistory copyWith({
    String? avg,
    MinMaxReading? min,
    MinMaxReading? max,
    List<Reading>? readings,
  }) {
    return VitalHistory(
      avg: avg ?? this.avg,
      min: min ?? this.min,
      max: max ?? this.max,
      readings: readings ?? this.readings,
    );
  }

  factory VitalHistory.fromRawJson(String str) {
    return VitalHistory.fromJson(json.decode(str));
  }

  String toRawJson() => json.encode(toJson());

  factory VitalHistory.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return VitalHistory();
    }
    List<dynamic> _readings = json["readings"] ?? [];
    return VitalHistory(
      avg: json["avg"],
      min: MinMaxReading.fromJson(json["min"]),
      max: MinMaxReading.fromJson(json["max"]),
      readings: _readings
          .map<Reading>((e) => Reading.fromRawJson(e['reading']))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "avg": avg,
      "min": min.toJson(),
      "max": max.toJson(),
      "readings": readings,
    };
  }
}

class MinMaxReading {
  MinMaxReading({
    int? readAt,
    String? value,
  })  : readAt = readAt ?? DateTime.now().millisecondsSinceEpoch,
        value = value ?? '';

  final int readAt;
  final String value;

  MinMaxReading copyWith({
    int? readAt,
    String? value,
  }) {
    return MinMaxReading(
      readAt: readAt ?? this.readAt,
      value: value ?? this.value,
    );
  }

  factory MinMaxReading.fromRawJson(String str) {
    return MinMaxReading.fromJson(json.decode(str));
  }

  String toRawJson() => json.encode(toJson());

  factory MinMaxReading.fromJson(Map<String, dynamic>? json) {
    if (json == null) return MinMaxReading();
    return MinMaxReading(
      readAt: json["readAt"],
      value: json["value"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "readAt": readAt,
      "value": value,
    };
  }
}
