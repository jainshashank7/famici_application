import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/enitity/user.dart';
import '../feature/rss_feed/entity/feed_category.dart';
import '../utils/config/api_config.dart';
import '../utils/config/api_key.dart';
import 'amplify_service.dart';
import 'auth_repository.dart';

class RssFeedRepository {
  final AmplifyService _amplifyAPI = AmplifyService();
  final AuthRepository _authRepository = AuthRepository();

  Future<List<FeedCategory>?> fetchFeedCategories() async {
    User current = await _authRepository.currentUser();

    String? accessToken = await _authRepository.generateAccessToken();
    var headers;
    if (accessToken != null) {
      headers = {
        "x-api-key": ApiKey.webManagementConsoleApi,
        "Authorization": accessToken,
        "x-client-id": current.customAttribute2.userId,
        "x-company-id": current.customAttribute2.companyId,
        "Content-Type": "application/json"
      };
    } else {
      headers = {};
    }
    if (accessToken != null) {
      try {
        var response = await http.get(
            Uri.parse(
                '${ApiConfig.baseUrl}/integrations/rss-feeds/feed-list'),
            headers: headers);

        Map<String, dynamic> jsonData = json.decode(response.body);
        List<dynamic> infoList = jsonData['info'];

        List<FeedCategory> feeds = FeedCategory.fromJsonList(infoList);

        return feeds;
      } catch (e) {
        return [];
      }
    }

    return [];
  }
}
