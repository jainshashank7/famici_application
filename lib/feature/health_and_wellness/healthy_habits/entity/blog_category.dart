part of 'barrel.dart';

class BlogCategory extends Equatable {
  const BlogCategory({
    String? id,
    String? name,
  })  : id = id ?? '',
        name = name ?? '';

  final String id;
  final String name;

  BlogCategory copyWith({
    String? id,
    String? name,
  }) {
    return BlogCategory(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  factory BlogCategory.fromRawJson(String? str) {
    if (str == null) {
      return BlogCategory();
    }
    return BlogCategory.fromJson(json.decode(str));
  }

  String toRawJson() => json.encode(toJson());

  factory BlogCategory.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return BlogCategory();
    }
    return BlogCategory(
      id: json["blogCategoryId"],
      name: json["blogCategoryName"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "blogCategoryId": id,
      "blogCategoryName": name,
    };
  }

  static List<BlogCategory> fromJsonList(List<dynamic>? jsonList) {
    if (jsonList == null) {
      return [];
    }
    return List<BlogCategory>.from(
      jsonList.map((e) => BlogCategory.fromJson(e)),
    );
  }

  static Map<String, BlogCategory> toMapFromList(
      List<BlogCategory>? categories) {
    if (categories == null) {
      return {};
    }
    return Map<String, BlogCategory>.fromIterable(
      categories.map((e) => MapEntry<String, BlogCategory>(e.id, e)),
    );
  }

  @override
  List<Object?> get props => [id, name];
}
