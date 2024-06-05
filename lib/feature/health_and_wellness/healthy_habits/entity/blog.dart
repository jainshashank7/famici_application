part of 'barrel.dart';

class Blog extends Equatable {
  Blog({
    String? author,
    String? blogCategoryId,
    DateTime? createdAt,
    String? description,
    String? id,
    String? image,
    String? title,
    DateTime? updatedAt,
    String? url,
    bool? isLiked,
    bool? isSelected,
  })  : author = author ?? '',
        blogCategoryId = blogCategoryId ?? '',
        createdAt = createdAt ?? DateTime.now(),
        description = description ?? '',
        id = id ?? '',
        image = image ?? '',
        title = title ?? '',
        updatedAt = updatedAt ?? DateTime.now(),
        url = url ?? '',
        isLiked = isLiked ?? false,
        isSelected = isSelected ?? false;

  final String author;
  final String blogCategoryId;
  final DateTime createdAt;
  final String description;
  final String id;
  final String image;
  final String title;
  final DateTime updatedAt;
  final String url;
  final bool isLiked;
  final bool isSelected;

  Blog copyWith({
    String? author,
    String? blogCategoryId,
    DateTime? createdAt,
    String? description,
    String? id,
    String? image,
    String? title,
    DateTime? updatedAt,
    String? url,
    bool? isLiked,
    bool? isSelected,
  }) =>
      Blog(
        author: author ?? this.author,
        blogCategoryId: blogCategoryId ?? this.blogCategoryId,
        createdAt: createdAt ?? this.createdAt,
        description: description ?? this.description,
        id: id ?? this.id,
        image: image ?? this.image,
        title: title ?? this.title,
        updatedAt: updatedAt ?? this.updatedAt,
        url: url ?? this.url,
        isSelected: isSelected ?? this.isSelected,
        isLiked: isLiked ?? this.isLiked,
      );

  factory Blog.fromRawJson(String? str) {
    if (str == null) {
      return Blog();
    }
    return Blog.fromJson(jsonDecode(str));
  }

  String toRawJson() => jsonEncode(toJson());

  factory Blog.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Blog();
    }
    return Blog(
      author: json["author"],
      blogCategoryId: json["blogCategoryId"],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json["createdAt"]),
      description: json["description"],
      id: json["blogId"],
      image: json["image"],
      title: json["title"],
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json["updatedAt"] ?? 0),
      url: json["url"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "author": author,
      "blogCategoryId": blogCategoryId,
      "createdAt": createdAt.millisecondsSinceEpoch,
      "description": description,
      "blogId": id,
      "image": image,
      "title": title,
      "updatedAt": updatedAt.millisecondsSinceEpoch,
      "url": url
    };
  }

  static List<Blog> fromJsonList(List<dynamic>? jsonList) {
    if (jsonList == null) {
      return [];
    }
    return List<Blog>.from(jsonList.map((e) => Blog.fromJson(e)));
  }

  static Map<String, Blog> toMapFromList(
    List<Blog>? blogs,
  ) {
    if (blogs == null) {
      return {};
    }
    return Map<String, Blog>.fromIterable(
      blogs.map((e) => MapEntry<String, Blog>(e.id, e)),
    );
  }

  @override
  List<Object?> get props => [
        author,
        blogCategoryId,
        createdAt,
        description,
        id,
        image,
        title,
        updatedAt,
        url,
      ];
}
