import 'dart:convert';

import '../../../core/screens/template/kiosk/rss_feed/feed.dart';
import 'education_feed.dart';

class EducationType {
  final String title;
  final String id;
  final List<RssFeedItem> feeds;
  bool shouldShowList;

  EducationType({
    required this.title,
    required this.id,
    required this.feeds,
    required this.shouldShowList,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'id': id,
      'feeds': feeds.map((feed) => feed.toJson()).toList(),
      'shouldShowList':shouldShowList,
    };
  }

  factory EducationType.fromJson(Map<String, dynamic> json) {
    return EducationType(
      title: json['title'],
      id: json['id'],
      feeds: (json['feeds'] as List<dynamic>)
          .map((feedJson) => RssFeedItem.fromJson(feedJson))
          .toList(),
      shouldShowList: false,
    );
  }
}
