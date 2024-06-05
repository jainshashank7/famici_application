import 'package:equatable/equatable.dart';

class RssFeedItem extends Equatable {
  const RssFeedItem({
    String? title,
    String? description,
    String? imageUrl,
    String? link,
    bool? selected,
  })  : title = title ?? '',
        description = description ?? '',
        imageUrl = imageUrl ?? '',
        link = link ?? '',
  selected = selected ?? false;

  final String title;
  final String description;
  final String imageUrl;
  final String link;
  final bool selected;

  RssFeedItem copyWith({
    String? title,
    String? description,
    String? imageUrl,
    String? link,
    bool? selected,
  }) {
    return RssFeedItem(
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      link: link ?? this.link,
      selected: selected ?? this.selected,
    );
  }

  factory RssFeedItem.fromJson(Map<String, dynamic> json) {
    return RssFeedItem(
      title: json["title"],
      description: json["description"],
      imageUrl: json["imageUrl"],
      link: json["link"],
      selected: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "imageUrl": imageUrl,
      "link": link,
    };
  }

  @override
  List<Object?> get props => [title, description, imageUrl, link];

  static fromJsonList(List list) {
    return [];
  }
}
