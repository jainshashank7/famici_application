part of 'education_bloc.dart';

class EducationState extends Equatable {
  final List<EducationItem> items;
  final List<EducationItem> educationItems;
  final Status status;
  final List<EducationItem> searchResults;
  final Map<int, int> favorites;
  final int currRssId;

  const EducationState({
    required this.items,
    required this.status,
    required this.educationItems,
    required this.searchResults,
    required this.favorites,
    required this.currRssId,
  });

  factory EducationState.initial() => const EducationState(
        items: [],
        status: Status.loading,
        educationItems: [],
        searchResults: [],
        favorites: {},
    currRssId: 0,
      );

  EducationState copyWith({
    List<EducationItem>? items,
    Map<int, int>? favorites,
    Status? status,
    List<EducationItem>? educationItems,
    List<EducationItem>? searchResults,
    int? currRssId,
  }) {
    return EducationState(
        items: items ?? this.items,
        educationItems: educationItems ?? this.educationItems,
        favorites: favorites ?? this.favorites,
        status: status ?? this.status,
        searchResults: searchResults ?? this.searchResults,
      currRssId: currRssId ?? this.currRssId,
    );
  }

  @override
  List<Object?> get props => [
        items,
        status,
        searchResults,
        favorites,
        educationItems,
    currRssId,
      ];

  static List<EducationItem> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => EducationItem.fromJson(json)).toList();
  }
}

class EducationItem {
  final int id;
  final String title;
  final String link;
  final String type;
  final String rssfeedid;
  late int status;
  // bool showFeeds;
  List<RssFeedItem> rssFeeds;

  EducationItem({
    required this.id,
    required this.title,
    required this.link,
    required this.type,
    required this.rssfeedid,
    // required this.showFeeds,
    required this.status,
    required this.rssFeeds,
  });

  factory EducationItem.fromJson(Map<String, dynamic> json) {
    return EducationItem(
      id: json['id'],
      title: json['title'],
      link: json['link'] ?? "",
      type: json['type'],
      rssfeedid: json['rssfeedid'] != null ? json['rssfeedid'].toString() : "",
      status: json['status'],
      rssFeeds: [],
      // showFeeds: false,
    );
  }

  EducationItem copyWith({
    int? id,
    String? title,
    String? link,
    String? type,
    String? rssFeedId,
    int? status,
    List<RssFeedItem>? rssFeeds,
    bool? showFeeds,
  }) {
    return EducationItem(
        id: id ?? this.id,
        title: title ?? this.title,
        link: link ?? this.link,
        type: type ?? this.type,
        rssfeedid: rssFeedId ?? rssfeedid,
        status: status ?? this.status,
        rssFeeds: rssFeeds ?? this.rssFeeds,
        // showFeeds: showFeeds ?? this.showFeeds
    );
  }

  @override
  String toString() {
    return 'EducationItem(id: $id, title: $title, link: $link, type: $type, rssfeedid: $rssfeedid, status: $status)';
  }
}
