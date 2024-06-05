import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../feature/health_and_wellness/healthy_habits/entity/barrel.dart';

abstract class IBlogRepository {
  Future<List<BlogCategory>> fetchCategories();

  Future<List<Blog>> fetchTopStories();

  Future<List<Blog>> search({
    String searchKey = '',
    String lastItemId = '',
    String sortOrder = '',
    int limit = 25,
  });

  Future<List<Blog>> fetchBlogs({
    String blogCategoryId = '',
    String lastItemId = '',
    String sortOrder = '',
    int limit = 25,
  });
}
