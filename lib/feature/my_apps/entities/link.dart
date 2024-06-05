import 'dart:convert';

class UrlLink {
  UrlLink({
    String? createdBy,
    int? createdAt,
    String? description,
    String? familyId,
    String? link,
    String? linkId,
  })  : createdBy = createdBy ?? '',
        createdAt = createdAt ?? DateTime.now().millisecondsSinceEpoch,
        description = description ?? '',
        familyId = familyId ?? '',
        link = link ?? '',
        linkId = linkId ?? '';

  final String createdBy;
  final int createdAt;
  final String description;
  final String familyId;
  final String link;
  final String linkId;

  UrlLink copyWith({
    String? createdBy,
    int? createdAt,
    String? description,
    String? familyId,
    String? link,
    String? linkId,
  }) =>
      UrlLink(
        createdBy: createdBy ?? this.createdBy,
        createdAt: createdAt ?? this.createdAt,
        description: description ?? this.description,
        familyId: familyId ?? this.familyId,
        link: link ?? this.link,
        linkId: linkId ?? this.linkId,
      );

  factory UrlLink.fromRawJson(String str) => UrlLink.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UrlLink.fromJson(Map<String, dynamic> json) => UrlLink(
        createdBy: json["createdBy"],
        createdAt: json["createdAt"],
        description: json["description"],
        familyId: json["familyId"],
        link: json["link"],
        linkId: json["linkId"],
      );

  Map<String, dynamic> toJson() => {
        "createdBy": createdBy,
        "createdAt": createdAt,
        "description": description,
        "familyId": familyId,
        "link": link,
        "linkId": linkId,
      };
}
