part of 'rss_feed_bloc.dart';

abstract class RssFeedEvent extends Equatable {
  const RssFeedEvent();

  @override
  List<Object> get props => [];
}

class ViewStoryEvent extends RssFeedEvent {
  final RssFeedItem story;
  final int index;

  const ViewStoryEvent(this.story, this.index);
  @override
  String toString() {
    return "ViewStory";
  }
}

class FetchCategoriesEvent extends RssFeedEvent {
  const FetchCategoriesEvent();
  @override
  String toString() {
    return "FetchCategoriesEvent";
  }
}

class BackFromViewStoryDetails extends RssFeedEvent {
  const BackFromViewStoryDetails();
  @override
  String toString() {
    return "BackViewStoryDetails";
  }
}

class FetchStoriesEvent extends RssFeedEvent {
  const FetchStoriesEvent();
  @override
  String toString() {
    return "FetchStoriesEvent";
  }
}

class ShowNextStory extends RssFeedEvent {
  const ShowNextStory();
  @override
  String toString() {
    return "ShowNextStory";
  }
}

class ShowPreviousStory extends RssFeedEvent {
  const ShowPreviousStory();
  @override
  String toString() {
    return "ShowPreviousStory";
  }
}

class ToggleLike extends RssFeedEvent {
  const ToggleLike();
  @override
  String toString() {
    return "ViewStory";
  }
}

class SearchBlogEvent extends RssFeedEvent {
  final String term;
  const SearchBlogEvent({this.term = ''});
  @override
  String toString() {
    return "FetchStoriesEvent";
  }
}

class ViewBlogsByCategoryEvent extends RssFeedEvent {
  final FeedCategory category;
  const ViewBlogsByCategoryEvent(this.category);
  @override
  String toString() {
    return "FetchStoriesEvent";
  }
}

class LoadMoreBlogsEvent extends RssFeedEvent {
  @override
  String toString() {
    return "LoadMoreStoriesEvent";
  }
}

class ResetRssFeedEvent extends RssFeedEvent {
  @override
  String toString() {
    return "LoadMoreStoriesEvent";
  }
}
