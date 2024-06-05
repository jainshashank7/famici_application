import 'package:amplify_api/amplify_api.dart';
import 'package:debug_logger/debug_logger.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:famici/core/enitity/barrel.dart';
import 'package:famici/feature/health_and_wellness/healthy_habits/entity/barrel.dart';
import 'package:famici/utils/barrel.dart';

import '../../../repositories/rss_feed_repository.dart';
import '../entity/feed.dart';
import '../entity/feed_category.dart';
import '../entity/fetch_feeds.dart';

part 'rss_feed_event.dart';

part 'rss_feed_state.dart';

class RssFeedBloc extends HydratedBloc<RssFeedEvent, RssFeedState> {
  RssFeedBloc({
    required User me,
  })  : _me = me,
        super(RssFeedState.initial()) {
    on<ViewStoryEvent>(_onViewStoryEvent);
    on<BackFromViewStoryDetails>(_onBackViewStory);
    on<FetchStoriesEvent>(_onFetchStoriesEvent);
    on<FetchCategoriesEvent>(_onFetchCategoriesEvent);
    on<ViewBlogsByCategoryEvent>(_onViewBlogsByCategoryEvent);
    on<ShowNextStory>(_onShowNextStory);
    on<ShowPreviousStory>(_onShowPreviousStory);
    on<LoadMoreBlogsEvent>(_onLoadMoreBlogsEvent);
    on<ResetRssFeedEvent>(_onResetRssFeedEvent);
    // on<ToggleLike>(_onToggleLike);
  }

  final User _me;
  final RssFeedRepository _feedRepo = RssFeedRepository();

  void _onViewStoryEvent(ViewStoryEvent event, Emitter emit) {
    List<RssFeedItem> _stories = List<RssFeedItem>.from(state.stories);

    _stories[event.index] = _stories[event.index].copyWith(selected: true);

    emit(state.copyWith(
      storyViewSliderIndex: event.index,
      detailsViewing: true,
      stories: _stories,
    ));
  }

  void _onResetRssFeedEvent(ResetRssFeedEvent event, Emitter emit) {
    state.searchController.clear();
    emit(state.copyWith(
      status: Status.initial,
      storyViewSliderIndex: 0,
      detailsViewing: false,
      stories: [],
      selectedCategory: topStories,
      lastItemId: '',
    ));
  }

  void _onBackViewStory(BackFromViewStoryDetails event, Emitter emit) {
    List<RssFeedItem> _stories = List.from(state.stories);
    int _index = state.storyViewSliderIndex;

    if (_stories.isNotEmpty) {
      _stories[_index] = _stories[_index].copyWith(selected: false);
      _stories[0] = _stories[0].copyWith(
        selected: true,
      );
    }

    emit(state.copyWith(
      storyViewSliderIndex: 0,
      detailsViewing: false,
      stories: _stories,
    ));
  }

  Future<void> _onFetchCategoriesEvent(
    FetchCategoriesEvent event,
    Emitter emit,
  ) async {
    try {
      emit(state.copyWith(status: Status.loading));

      List<FeedCategory>? _categories = await _feedRepo.fetchFeedCategories();

      if(_categories != null){
        add(
          ViewBlogsByCategoryEvent(_categories[0]),
        );
      }

      emit(state.copyWith(categories: _categories, status: Status.success));
    } on GraphQLResponseError catch (err) {
      DebugLogger.error(err);
      emit(state.copyWith(status: Status.failure));
    } catch (er) {
      emit(state.copyWith(status: Status.failure));
    }
  }

  Future<void> _onFetchStoriesEvent(
    FetchStoriesEvent event,
    Emitter emit,
  ) async {
    try {
      emit(state.copyWith(status: Status.loading));
//todo
//       List<Blog> _stories = await _feedRepo.fetchTopStories();

      state.searchController.clear();

      // emit(state.copyWith(
      //   stories: _stories,
      //   status: Status.success,
      //   detailsViewing: false,
      //   storyViewSliderIndex: 0,
      //   selectedCategory: topStories,
      //   lastItemId: '',
      // ));
    } on GraphQLResponseError catch (err) {
      DebugLogger.error(err);
      emit(state.copyWith(
        status: Status.failure,
        selectedCategory: topStories,
      ));
    } catch (er) {
      emit(state.copyWith(
        status: Status.failure,
        selectedCategory: topStories,
      ));
    }
  }

  Future<void> _onSearchBlogEvent(
    SearchBlogEvent event,
    Emitter emit,
  ) async {
    try {
      String searchKey = event.term.trim();
      state.searchController.text = searchKey;
      if (searchKey.isNotEmpty) {
        emit(state.copyWith(status: Status.loading));

        //todo
        // List<Blog> _stories = await _feedRepo.search(searchKey: searchKey);
        // emit(state.copyWith(
        //   stories: _stories,
        //   status: Status.success,
        //   selectedCategory: searchingForBlog,
        //   lastItemId: '',
        //   detailsViewing: false,
        //   storyViewSliderIndex: 0,
        // ));
      }
    } on GraphQLResponseError catch (err) {
      DebugLogger.error(err);
      // emit(state.copyWith(
      //   status: Status.failure,
      //   selectedCategory: searchingForBlog,
      // ));
    } catch (er) {
      // emit(state.copyWith(
      //   status: Status.failure,
      //   selectedCategory: searchingForBlog,
      // ));
    }
  }

  Future<void> _onLoadMoreBlogsEvent(
    LoadMoreBlogsEvent event,
    Emitter emit,
  ) async {
    try {
      //todo
      // List<Blog> _stories = List.from(state.stories);
      // FeedCategory _selected = state.selectedCategory;
      // String lastItemId = state.lastItemId;
      // if (lastItemId != _stories.last.id) {
      //   emit(state.copyWith(lastItemId: _stories.last.id));
      //   if (_selected.id == topStories.id) {
      //     List<Blog> _fetched = await _feedRepo.fetchTopStories(
      //       lastItemId: _stories.last.id,
      //     );
      //     _stories.addAll(_fetched);
      //   } else if (_selected.id == searchingForBlog.id) {
      //     List<Blog> _fetched = await _feedRepo.search(
      //       searchKey: state.searchController.text,
      //       lastItemId: _stories.last.id,
      //     );
      //
      //     _stories.addAll(_fetched);
      //   } else {
      //     List<Blog> _fetched = await _feedRepo.fetchBlogs(
      //         lastItemId: _stories.last.id, FeedCategoryId: _selected.id);
      //     _stories.addAll(_fetched);
      //   }
      //
      //   emit(state.copyWith(
      //     stories: _stories,
      //     status: Status.success,
      //     lastItemId: _stories.last.id,
      //   ));
      // }
    } on GraphQLResponseError catch (err) {
      DebugLogger.error(err);
      emit(state.copyWith(
        status: Status.failure,
      ));
    } catch (er) {
      emit(state.copyWith(
        status: Status.failure,
      ));
    }
  }

  Future<void> _onViewBlogsByCategoryEvent(
    ViewBlogsByCategoryEvent event,
    Emitter emit,
  ) async {
    try {
      emit(state.copyWith(
        status: Status.loading,
        selectedCategory: event.category,
      ));
      List<RssFeedItem> feeds = await fetchRssFeed(event.category.link);

      state.searchController.clear();

      // List<Blog> _stories = await _feedRepo.fetchBlogs(
      //   FeedCategoryId: event.category.id,
      // );
      //
      emit(state.copyWith(
        stories: feeds,
        status: Status.success,
        detailsViewing: false,
        storyViewSliderIndex: 0,
        selectedCategory: event.category,
        lastItemId: '',
      ));
    } on GraphQLResponseError catch (err) {
      DebugLogger.error(err);
      emit(state.copyWith(
        status: Status.failure,
        selectedCategory: event.category,
      ));
    } catch (er) {
      emit(state.copyWith(
        status: Status.failure,
        selectedCategory: event.category,
      ));
    }
  }

  Future<void> _onShowNextStory(
    ShowNextStory event,
    Emitter emit,
  ) async {
    int current = state.storyViewSliderIndex;
    List<RssFeedItem> stories = state.stories;

    if (stories.length - 1 > current) {
      current = current + 1;
      emit(state.copyWith(storyViewSliderIndex: current));
    }
  }

  Future<void> _onShowPreviousStory(
    ShowPreviousStory event,
    Emitter emit,
  ) async {
    int current = state.storyViewSliderIndex;

    if (current > 0) {
      current = current - 1;
      emit(state.copyWith(storyViewSliderIndex: current));
    }
  }

  @override
  RssFeedState? fromJson(Map<String, dynamic> json) {
    return RssFeedState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(RssFeedState state) {
    return state.toJson();
  }

// Future<void> _onToggleLike(
//   ToggleLike event,
//   Emitter emit,
// ) async {
//   bool liked = state.stories[state.storyViewSliderIndex].isLiked ?? false;
//   List<Blog>? _selected = state.stories;
//   _selected = state.stories.map((story) {
//     if (story.id == state.stories[state.storyViewSliderIndex].id) {
//       return story.copyWith(isLiked: !liked);
//     }
//     return story;
//   }).toList();
//   emit(state.copyWith(stories: _selected));
// }
}
