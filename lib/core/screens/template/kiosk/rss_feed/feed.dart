import 'package:debug_logger/debug_logger.dart';
import 'package:equatable/equatable.dart';

class RssFeedItem extends Equatable {
  RssFeedItem({
    required this.id,
    String? title,
    String? description,
    String? imageUrl,
    String? link,
    String? pubDate,
    String? fileId,
    bool? selected,
    bool? seenStatus,
    String? publicationDate
  })  : title = title ?? '',
        description = description ?? '',
        imageUrl = imageUrl ?? '',
        link = link ?? '',
        pubDate = pubDate ?? "",
        fileId = fileId ?? "",
        selected = selected ?? false,
        seenStatus = seenStatus ?? false,
        publicationDate = publicationDate ?? "";

  final int id;
  final String title;
  final String description;
  String imageUrl;
  final String link;
  final String pubDate;
  final String fileId;
  late final bool selected;
  bool seenStatus;
  final String publicationDate;

  RssFeedItem copyWith({
    int? id,
    String? title,
    String? description,
    String? imageUrl,
    String? link,
    String? pubDate,
    String? fileId,
    bool? selected,
    bool? seenStatus,
    String? publicationDate
  }) {
    return RssFeedItem(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        imageUrl: imageUrl ?? this.imageUrl,
        link: link ?? this.link,
        pubDate: pubDate ?? this.pubDate,
        fileId: fileId ?? this.fileId,
        selected: selected ?? this.selected,
        seenStatus: seenStatus ?? this.seenStatus,
        publicationDate: publicationDate ?? this.publicationDate
    );
  }

  factory RssFeedItem.fromJson(Map<String, dynamic> json) {
    return RssFeedItem(
        id: json['id'] ?? "",
        title: json["title"],
        description: json["description"],
        imageUrl: json["imageUrl"],
        link: json["link"],
        pubDate: json['pubDate'],
        fileId: json['fileId'],
        selected: false,
        seenStatus: json["seenstatus"] ?? false,
        publicationDate: json['publicationDate'] ?? ""
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "imageUrl": imageUrl,
      "link": link,
      "pubDate": pubDate,
      "fileId": fileId,
      "seenstatus": seenStatus,
      "publicationDate": publicationDate
    };
  }

  @override
  List<Object?> get props => [id, title, description, imageUrl, link, seenStatus, publicationDate];

  static fromJsonList(List list) {
    return [];
  }
}
