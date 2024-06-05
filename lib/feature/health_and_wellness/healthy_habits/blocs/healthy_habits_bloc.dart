import 'package:amplify_api/amplify_api.dart';
import 'package:debug_logger/debug_logger.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:famici/core/enitity/barrel.dart';
import 'package:famici/repositories/blog_repo/blog_repository.dart';
import 'package:famici/utils/barrel.dart';

import '../entity/barrel.dart';

part 'healthy_habits_event.dart';
part 'healthy_habits_state.dart';

class HealthyHabitsBloc
    extends HydratedBloc<HealthyHabitsEvent, HealthyHabitsState> {
  HealthyHabitsBloc({
    required User me,
  })  : _me = me,
        super(HealthyHabitsState.initial()) {
    on<ViewStoryEvent>(_onViewStoryEvent);
    on<BackFromViewStoryDetails>(_onBackViewStory);
    on<FetchStoriesEvent>(_onFetchStoriesEvent);
    on<FetchCategoriesEvent>(_onFetchCategoriesEvent);
    on<SearchBlogEvent>(_onSearchBlogEvent);
    on<ViewBlogsByCategoryEvent>(_onViewBlogsByCategoryEvent);
    on<ShowNextStory>(_onShowNextStory);
    on<ShowPreviousStory>(_onShowPreviousStory);
    on<LoadMoreBlogsEvent>(_onLoadMoreBlogsEvent);
    on<ResetHealthyHabitsEvent>(_onResetHealthyHabitsEvent);
    // on<ToggleLike>(_onToggleLike);
  }
  final User _me;
  final BlogRepository _blogRepo = BlogRepository();

  void _onViewStoryEvent(ViewStoryEvent event, Emitter emit) {
    List<Blog> _stories = List<Blog>.from(state.stories);

    _stories[event.index] = _stories[event.index].copyWith(isSelected: true);

    emit(state.copyWith(
      storyViewSliderIndex: event.index,
      detailsViewing: true,
      stories: _stories,
    ));
  }

  void _onResetHealthyHabitsEvent(ResetHealthyHabitsEvent event, Emitter emit) {
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
    List<Blog> _stories = List.from(state.stories);
    int _index = state.storyViewSliderIndex;

    if (_stories.isNotEmpty) {
      _stories[_index] = _stories[_index].copyWith(isSelected: false);
      _stories[0] = _stories[0].copyWith(
        isSelected: true,
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

      List<BlogCategory> _categories = await _blogRepo.fetchCategories();
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

      List<Blog> _stories = await _blogRepo.fetchTopStories();

      state.searchController.clear();

      emit(state.copyWith(
        stories: _stories,
        status: Status.success,
        detailsViewing: false,
        storyViewSliderIndex: 0,
        selectedCategory: topStories,
        lastItemId: '',
      ));
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

        List<Blog> _stories = await _blogRepo.search(searchKey: searchKey);
        emit(state.copyWith(
          stories: _stories,
          status: Status.success,
          selectedCategory: searchingForBlog,
          lastItemId: '',
          detailsViewing: false,
          storyViewSliderIndex: 0,
        ));
      }
    } on GraphQLResponseError catch (err) {
      DebugLogger.error(err);
      emit(state.copyWith(
        status: Status.failure,
        selectedCategory: searchingForBlog,
      ));
    } catch (er) {
      emit(state.copyWith(
        status: Status.failure,
        selectedCategory: searchingForBlog,
      ));
    }
  }

  Future<void> _onLoadMoreBlogsEvent(
    LoadMoreBlogsEvent event,
    Emitter emit,
  ) async {
    try {
      List<Blog> _stories = List.from(state.stories);
      BlogCategory _selected = state.selectedCategory;
      String lastItemId = state.lastItemId;
      if (lastItemId != _stories.last.id) {
        emit(state.copyWith(lastItemId: _stories.last.id));
        if (_selected.id == topStories.id) {
          List<Blog> _fetched = await _blogRepo.fetchTopStories(
            lastItemId: _stories.last.id,
          );
          _stories.addAll(_fetched);
        } else if (_selected.id == searchingForBlog.id) {
          List<Blog> _fetched = await _blogRepo.search(
            searchKey: state.searchController.text,
            lastItemId: _stories.last.id,
          );

          _stories.addAll(_fetched);
        } else {
          List<Blog> _fetched = await _blogRepo.fetchBlogs(
              lastItemId: _stories.last.id, blogCategoryId: _selected.id);
          _stories.addAll(_fetched);
        }

        emit(state.copyWith(
          stories: _stories,
          status: Status.success,
          lastItemId: _stories.last.id,
        ));
      }
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

      state.searchController.clear();

      List<Blog> _stories = await _blogRepo.fetchBlogs(
        blogCategoryId: event.category.id,
      );

      emit(state.copyWith(
        stories: _stories,
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
    List<Blog> stories = state.stories;

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
  HealthyHabitsState? fromJson(Map<String, dynamic> json) {
    return HealthyHabitsState.fromJson(json);
  }

  @override
  Map<String, dynamic>? toJson(HealthyHabitsState state) {
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
