// To parse this JSON data, do
//
//     final safetyDisclaimer = safetyDisclaimerFromJson(jsonString);

// To parse this JSON data, do
//
//     final safetyDisclaimer = safetyDisclaimerFromJson(jsonString);

import 'dart:convert';

class SafetyDisclaimer {
  SafetyDisclaimer({
    Config? config,
    String? content,
  })  : config = config ?? Config(),
        content = content ?? '';

  final Config config;
  final String content;

  SafetyDisclaimer copyWith({
    Config? config,
    String? content,
  }) =>
      SafetyDisclaimer(
        config: config ?? this.config,
        content: content ?? this.content,
      );

  factory SafetyDisclaimer.fromRawJson(String str) =>
      SafetyDisclaimer.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SafetyDisclaimer.fromJson(Map<String, dynamic> json) =>
      SafetyDisclaimer(
        config: Config.fromJson(json["config"]),
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "config": config.toJson(),
        "content": content,
      };

  bool get isAccepted => config.medicationDisclaimer != null;
}

class Config {
  Config({
    this.medicationDisclaimer,
  });

  final dynamic medicationDisclaimer;

  Config copyWith({
    dynamic medicationDisclaimer,
  }) =>
      Config(
        medicationDisclaimer: medicationDisclaimer ?? this.medicationDisclaimer,
      );

  factory Config.fromRawJson(String str) => Config.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Config.fromJson(Map<String, dynamic> json) => Config(
        medicationDisclaimer: json["medicationDisclaimer"],
      );

  Map<String, dynamic> toJson() => {
        "medicationDisclaimer": medicationDisclaimer,
      };
}
