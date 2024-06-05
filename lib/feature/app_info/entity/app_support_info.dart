// To parse this JSON data, do
//
//     final appSupportInfo = appSupportInfoFromJson(jsonString);

import 'dart:convert';

class AppSupportInfo {
  AppSupportInfo({
    SupportDoc? help,
    SupportDoc? privacy,
    SupportDoc? terms,
    String? version,
  })  : help = help ?? SupportDoc(),
        privacy = privacy ?? SupportDoc(),
        terms = terms ?? SupportDoc(),
        version = version ?? '';

  final SupportDoc help;
  final SupportDoc privacy;
  final SupportDoc terms;
  final String version;

  AppSupportInfo copyWith({
    SupportDoc? help,
    SupportDoc? privacy,
    SupportDoc? terms,
    String? version,
  }) =>
      AppSupportInfo(
        help: help ?? this.help,
        privacy: privacy ?? this.privacy,
        terms: terms ?? this.terms,
        version: version ?? this.version,
      );

  factory AppSupportInfo.fromRawJson(String str) =>
      AppSupportInfo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AppSupportInfo.fromJson(Map<String, dynamic> json) => AppSupportInfo(
        help: SupportDoc.fromJson(json["help"]),
        privacy: SupportDoc.fromJson(json["privacy"]),
        terms: SupportDoc.fromJson(json["terms"]),
        version: json["version"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "help": help.toJson(),
        "privacy": privacy.toJson(),
        "terms": terms.toJson(),
        "version": version,
      };
}

class SupportDoc {
  SupportDoc({
    String? name,
    String? url,
  })  : name = name ?? '',
        url = url ?? '';

  final String name;
  final String url;

  SupportDoc copyWith({
    String? name,
    String? url,
  }) =>
      SupportDoc(
        name: name ?? this.name,
        url: url ?? this.url,
      );

  factory SupportDoc.fromRawJson(String str) =>
      SupportDoc.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SupportDoc.fromJson(Map<String, dynamic> json) => SupportDoc(
        name: json["documentName"] ?? '',
        url: json["documentUrl"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "documentName": name,
        "documentUrl": url,
      };
}
