part of 'healthy_habits_bloc.dart';

abstract class HealthyHabitsEvent extends Equatable {
  const HealthyHabitsEvent();

  @override
  List<Object> get props => [];
}

class ViewStoryEvent extends HealthyHabitsEvent {
  final Blog story;
  final int index;

  const ViewStoryEvent(this.story, this.index);
  @override
  String toString() {
    return "ViewStory";
  }
}

class FetchCategoriesEvent extends HealthyHabitsEvent {
  const FetchCategoriesEvent();
  @override
  String toString() {
    return "FetchCategoriesEvent";
  }
}

class BackFromViewStoryDetails extends HealthyHabitsEvent {
  const BackFromViewStoryDetails();
  @override
  String toString() {
    return "BackViewStoryDetails";
  }
}

class FetchStoriesEvent extends HealthyHabitsEvent {
  const FetchStoriesEvent();
  @override
  String toString() {
    return "FetchStoriesEvent";
  }
}

class ShowNextStory extends HealthyHabitsEvent {
  const ShowNextStory();
  @override
  String toString() {
    return "ShowNextStory";
  }
}

class ShowPreviousStory extends HealthyHabitsEvent {
  const ShowPreviousStory();
  @override
  String toString() {
    return "ShowPreviousStory";
  }
}

class ToggleLike extends HealthyHabitsEvent {
  const ToggleLike();
  @override
  String toString() {
    return "ViewStory";
  }
}

class SearchBlogEvent extends HealthyHabitsEvent {
  final String term;
  const SearchBlogEvent({this.term = ''});
  @override
  String toString() {
    return "FetchStoriesEvent";
  }
}

class ViewBlogsByCategoryEvent extends HealthyHabitsEvent {
  final BlogCategory category;
  const ViewBlogsByCategoryEvent(this.category);
  @override
  String toString() {
    return "FetchStoriesEvent";
  }
}

class LoadMoreBlogsEvent extends HealthyHabitsEvent {
  @override
  String toString() {
    return "LoadMoreStoriesEvent";
  }
}

class ResetHealthyHabitsEvent extends HealthyHabitsEvent {
  @override
  String toString() {
    return "LoadMoreStoriesEvent";
  }
}
