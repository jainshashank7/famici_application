import 'dart:convert';

import 'package:amplify_api/amplify_api.dart';
import 'package:famici/feature/health_and_wellness/healthy_habits/entity/barrel.dart';
import 'package:famici/repositories/blog_repo/blog_repository_interface.dart';

import '../../utils/helpers/amplify_helper.dart';
import '../amplify_service.dart';

class BlogRepository implements IBlogRepository {
  final AmplifyService _amplifyAPI = AmplifyService();

  @override
  Future<List<BlogCategory>> fetchCategories() async {
    String graphQLDocument = '''query GetBlogCategories{
            getBlogCategories{
              blogCategoryId
              blogCategoryName
            }
        }''';

    GraphQLResponse resp = await _amplifyAPI.query(
      document: graphQLDocument,
      apiName: AmplifyApiName.defaultApi,
    );

    if (resp.errors.isNotEmpty) {
      throw resp.errors.first;
    }
    return BlogCategory.fromJsonList(
      jsonDecode(resp.data)['getBlogCategories'],
    );
  }

  @override
  Future<List<Blog>> fetchTopStories({
    String lastItemId = '',
    String sortOrder = 'Desc',
    int limit = 25,
  }) async {
    String graphQLDocument =
        '''query GetTopStories(\$lastItemId: ID, \$limit: Int, \$sortOrder: SortOrder){
            getTopStories(lastItemId: \$lastItemId, limit: \$limit, sortOrder: \$sortOrder) {
              author
              blogCategoryId
              blogId
              createdAt
              description
              image
              title
              updatedAt
              url
            }
        }''';

    GraphQLResponse resp = await _amplifyAPI.query(
      document: graphQLDocument,
      apiName: AmplifyApiName.defaultApi,
      variables: {
        "lastItemId": lastItemId,
        "limit": limit,
        "sortOrder": sortOrder,
      },
    );

    if (resp.errors.isNotEmpty) {
      throw resp.errors.first;
    }
    return Blog.fromJsonList(jsonDecode(resp.data)['getTopStories']);
  }

  @override
  Future<List<Blog>> search({
    String searchKey = '',
    String lastItemId = '',
    String sortOrder = 'Desc',
    int limit = 25,
  }) async {
    String graphQLDocument =
        '''query SearchBlogs(\$searchKey: String!,\$lastItemId: ID,\$sortOrder:SortOrder,\$limit:Int) {
            searchBlogs (searchKey:\$searchKey, lastItemId:\$lastItemId, sortOrder:\$sortOrder, limit:\$limit) {
              author
              blogCategoryId
              createdAt
              description
              blogId
              image
              title
              updatedAt
              url
            }
      }''';

    GraphQLResponse resp = await _amplifyAPI.query(
      document: graphQLDocument,
      variables: {
        "searchKey": searchKey,
        "lastItemId": lastItemId,
        "limit": limit,
        "sortOrder": sortOrder,
      },
      apiName: AmplifyApiName.defaultApi,
    );

    if (resp.errors.isNotEmpty) {
      throw resp.errors.first;
    }
    return Blog.fromJsonList(jsonDecode(resp.data)['searchBlogs']);
  }

  @override
  Future<List<Blog>> fetchBlogs({
    String blogCategoryId = '',
    String lastItemId = '',
    String sortOrder = 'Desc',
    int limit = 25,
  }) async {
    String graphQLDocument =
        '''query GetBlogs(\$blogCategoryId: ID!,\$lastItemId: ID,\$sortOrder:SortOrder,\$limit:Int) {
            getBlogs(blogCategoryId:\$blogCategoryId, lastItemId:\$lastItemId, sortOrder:\$sortOrder, limit:\$limit) {
              author
              blogCategoryId
              createdAt
              description
              blogId
              image
              title
              updatedAt
              url
            }
      }''';

    GraphQLResponse resp = await _amplifyAPI.query(
      document: graphQLDocument,
      variables: {
        "blogCategoryId": blogCategoryId,
        "lastItemId": lastItemId,
        "limit": limit,
        "sortOrder": sortOrder,
      },
      apiName: AmplifyApiName.defaultApi,
    );

    if (resp.errors.isNotEmpty) {
      throw resp.errors.first;
    }
    return Blog.fromJsonList(jsonDecode(resp.data)['getBlogs']);
  }
}
