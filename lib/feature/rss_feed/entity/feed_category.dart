import 'dart:convert';

import 'package:equatable/equatable.dart';

class FeedCategory extends Equatable {
  const FeedCategory({
    String? id,
    String? name,
    String? link,
  })  : id = id ?? '',
        name = name ?? '',
        link = link ?? "";

  final String id;
  final String name;
  final String link;

  FeedCategory copyWith({
    String? id,
    String? name,
    String? link,
  }) {
    return FeedCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      link: link ?? this.link,
    );
  }

  factory FeedCategory.fromRawJson(String? str) {
    if (str == null) {
      return FeedCategory();
    }
    return FeedCategory.fromJson(json.decode(str));
  }

  String toRawJson() => json.encode(toJson());

  factory FeedCategory.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return FeedCategory();
    }
    return FeedCategory(
      id: json["id"].toString(),
      name: json["title"],
      link: json["link"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": name,
      "link": link,
    };
  }

  static List<FeedCategory> fromJsonList(List<dynamic>? jsonList) {
    if (jsonList == null) {
      return [];
    }
    return List<FeedCategory>.from(
      jsonList.map((e) => FeedCategory.fromJson(e)),
    );
  }

  static Map<String, FeedCategory> toMapFromList(
      List<FeedCategory>? categories) {
    if (categories == null) {
      return {};
    }
    return Map<String, FeedCategory>.fromIterable(
      categories.map((e) => MapEntry<String, FeedCategory>(e.id, e)),
    );
  }

  @override
  List<Object?> get props => [id, name, link];
}
