part of 'rss_feed_bloc.dart';

const topStories = FeedCategory(id: "", name : "", link : "");

class RssFeedState extends Equatable {
  const RssFeedState({
    required this.status,
    required this.stories,
    required this.storyViewSliderIndex,
    required this.detailsViewing,
    required this.categories,
    required this.selectedCategory,
    required this.searchController,
    required this.lastItemId,
  });

  final Status status;
  final List<RssFeedItem> stories;
  final List<FeedCategory> categories;
  final int storyViewSliderIndex;
  final bool detailsViewing;
  final FeedCategory selectedCategory;
  final TextEditingController searchController;
  final String lastItemId;

  factory RssFeedState.initial() {
    return RssFeedState(
      stories: [],
      status: Status.initial,
      storyViewSliderIndex: 0,
      detailsViewing: false,
      categories: [],
      selectedCategory: topStories,
      searchController: TextEditingController(),
      lastItemId: '',
    );
  }

  RssFeedState copyWith({
    List<RssFeedItem>? stories,
    Status? status,
    int? storyViewSliderIndex,
    bool? detailsViewing,
    List<FeedCategory>? categories,
    FeedCategory? selectedCategory,
    TextEditingController? searchController,
    String? lastItemId,
  }) {
    return RssFeedState(
      stories: stories ?? this.stories,
      status: status ?? this.status,
      storyViewSliderIndex: storyViewSliderIndex ?? this.storyViewSliderIndex,
      detailsViewing: detailsViewing ?? this.detailsViewing,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchController: searchController ?? this.searchController,
      lastItemId: lastItemId ?? this.lastItemId,
    );
  }

  bool get isLoading => status == Status.loading || status == Status.initial;

  bool get hasNoResult => status != Status.loading && stories.isEmpty;

  @override
  List<Object> get props => [
        stories,
        status,
        storyViewSliderIndex,
        detailsViewing,
        categories,
        selectedCategory,
        lastItemId,
      ];

  factory RssFeedState.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return RssFeedState.initial();
    }

    return RssFeedState(
        status: Status.initial,
        selectedCategory: FeedCategory.fromJson(json['selectedCategory']),
        stories: RssFeedItem.fromJsonList(List.from(json['stories'] ?? [])),
        storyViewSliderIndex: 0,
        detailsViewing: false,
        lastItemId: '',
        categories: FeedCategory.fromJsonList(
          List.from(json['categories'] ?? []),
        ),
        searchController: TextEditingController());
  }

  Map<String, dynamic> toJson() {
    return {
      "stories": stories.map((e) => e.toJson()).toList(),
      "categories": categories.map((e) => e.toJson()).toList(),
      "selectedCategory": selectedCategory.toJson(),
    };
  }

  @override
  String toString() {
    return ''' Healthy Habits : {
      stories          : ${stories.length}
      status          : ${status.toString()}
      storyViewSliderIndex : ${storyViewSliderIndex.toString()}
      detailsViewing :${detailsViewing.toString()}
      categories :${categories.toString()}
      searchKey :${searchController.text},
      latItemId :$lastItemId
    }''';
  }
}
