part of 'healthy_habits_bloc.dart';

const topStories = BlogCategory(id: "top_stories", name: "Top Stories");
const searchingForBlog = BlogCategory(id: "searching", name: "Search Results");

class HealthyHabitsState extends Equatable {
  const HealthyHabitsState({
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
  final List<Blog> stories;
  final List<BlogCategory> categories;
  final int storyViewSliderIndex;
  final bool detailsViewing;
  final BlogCategory selectedCategory;
  final TextEditingController searchController;
  final String lastItemId;

  factory HealthyHabitsState.initial() {
    return HealthyHabitsState(
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

  HealthyHabitsState copyWith({
    List<Blog>? stories,
    Status? status,
    int? storyViewSliderIndex,
    bool? detailsViewing,
    List<BlogCategory>? categories,
    BlogCategory? selectedCategory,
    TextEditingController? searchController,
    String? lastItemId,
  }) {
    return HealthyHabitsState(
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

  factory HealthyHabitsState.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return HealthyHabitsState.initial();
    }

    return HealthyHabitsState(
        status: Status.initial,
        selectedCategory: BlogCategory.fromJson(json['selectedCategory']),
        stories: Blog.fromJsonList(List.from(json['stories'] ?? [])),
        storyViewSliderIndex: 0,
        detailsViewing: false,
        lastItemId: '',
        categories: BlogCategory.fromJsonList(
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
