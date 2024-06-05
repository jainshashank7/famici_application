import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:debug_logger/debug_logger.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import '../../../core/enitity/user.dart';
import '../../../core/screens/template/kiosk/rss_feed/feed.dart';
import '../../../core/screens/template/kiosk/rss_feed/fetch_feeds.dart';
import '../../../repositories/auth_repository.dart';
import '../../../utils/config/api_config.dart';
import '../../../utils/config/api_key.dart';
import '../../../utils/constants/enums.dart';

part 'education_event.dart';
part 'education_state.dart';

class EducationBloc extends Bloc<EducationEvent, EducationState> {
  bool _setStatus = false;
  EducationBloc({required User me})
      : _me = me,
        super(EducationState.initial()) {
    on<OnGetEducationData>(_onGetEducationData);
    // on<OnGetRssData>(_onGetRssData);
    on<OnSetPinStatus>(_onSetPinStatus);
    on<OnChangeLikeStatus>(_onChangeLikeStatus);
    on<OnGetLikesStatus>(_onGetLikesStatus);
    on<ShowEducationSearchResults>(_onSearchEducationResults);
    on<ResetSearchResults>(_onResetSearchResults);

  }

  final User _me;
  final AuthRepository _authRepository = AuthRepository();

  Future<FutureOr<void>> _onGetEducationData(
      OnGetEducationData event, Emitter<EducationState> emit) async {
    emit(state.copyWith(status: Status.loading, currRssId: 0));
    // add(ResetSearchResults());
    add(OnGetLikesStatus());

    print("enterred int to education");

    String? accessToken = await _authRepository.generateAccessToken();
    String clientId = _me.customAttribute2.userId;
    String companyId = _me.customAttribute2.companyId;

    if (accessToken != null) {
      var headers = {
        "x-api-key": ApiKey.webManagementConsoleApi,
        "Authorization": accessToken,
        "x-client-id": clientId,
        "x-company-id": companyId,
        "Content-Type": "application/json"
      };

      print("Dashboard Id ::: ${event.dashboardId}");
      var responseM = await http.get(
          Uri.parse(
              '${ApiConfig.baseUrl}/integrations/education/getEducationbyDashboard/${event.dashboardId}'),
          headers: headers);

      DebugLogger.debug("RESEPOSSSEEEE:::: ${responseM.body}");

      var rsp = jsonDecode(responseM.body);

      List<EducationItem> eds = EducationState.fromJsonList(rsp['message']!);

      emit(state.copyWith(
          status: Status.initial, items: eds, educationItems: eds));

      for (var rss in eds) {
        if (rss.type == "rssfeed") {
          var infoForRss = await getRssData(rss.rssfeedid);
          Map<String, dynamic> feedsDataMap =
              await fetchRssFeed(infoForRss, false);
          List<RssFeedItem> feeds = feedsDataMap["rssFeedItems"];

          rss.rssFeeds = feeds;
        }
      }

      emit(state.copyWith(
          status: Status.completed, items: eds, educationItems: eds));
    }
  }

  Future<Map<String, dynamic>> getRssData(String id) async {
    // print('rss data new');
    String? accessToken = await _authRepository.generateAccessToken();
    String clientId = _me.customAttribute2.userId;
    String companyId = _me.customAttribute2.companyId;
    try {
      if (accessToken != null) {
        String memberProfile =
            '${ApiConfig.baseUrl}/integrations/rss-feeds/rssfeed/$id';

        var headers = {
          "x-api-key": ApiKey.webManagementConsoleApi,
          "Authorization": accessToken,
          "x-client-id": clientId,
          "x-company-id": companyId,
        };

        var response =
            await http.get(Uri.parse(memberProfile), headers: headers);

        return jsonDecode(response.body)['info'];
      }
    } catch (err) {
      DebugLogger.error(err);
    }

    return {};
  }

  Future<FutureOr<void>> _onSetPinStatus(
      OnSetPinStatus event, Emitter<EducationState> emit) async {
    emit(state.copyWith(status: Status.loading));
    List<EducationItem> educationItems = state.educationItems;
    for (var ed in educationItems) {
      if (ed.id == event.id) {
        ed.status = event.status;
        break;
      }
    }

    emit(state.copyWith(
        educationItems: educationItems, status: Status.completed));

    String? accessToken = await _authRepository.generateAccessToken();
    String clientId = _me.customAttribute2.userId;
    String companyId = _me.customAttribute2.companyId;
    try {
      if (accessToken != null) {
        String memberProfile =
            '${ApiConfig.baseUrl}/integrations/education/changepinstatus/${event.id}';

        Map<String, String>? headers = {
          "x-api-key": ApiKey.webManagementConsoleApi,
          "Authorization": accessToken,
          "x-client-id": clientId,
          "x-company-id": companyId,
          "Content-Type": "application/json",
        };

        var body = jsonEncode({
          "status": event.status,
          "educationresource_id": event.id,
        });

        var response = await http.post(
          Uri.parse(memberProfile),
          headers: headers,
          body: body,
        );

        print('id :: ${event.id}  , status :: ${event.status}');
        print('pin status :: ${response.body}');
        // return jsonDecode(response.body)['info'];

        // if (response.statusCode == 201) {
        //   add(OnGetEducationData());
        // }
      }
    } catch (err) {
      DebugLogger.error(err);
    }
  }

  Future<FutureOr<void>> _onChangeLikeStatus(
      OnChangeLikeStatus event, Emitter<EducationState> emit) async {
    emit(state.copyWith(status: Status.initial, currRssId: event.rssId));
    String? accessToken = await _authRepository.generateAccessToken();
    String clientId = _me.customAttribute2.userId;
    String companyId = _me.customAttribute2.companyId;
    try {
      if (accessToken != null) {
        String memberProfile =
            '${ApiConfig.baseUrl}/integrations/rss-feeds/changefavourite';

        Map<String, String>? headers = {
          "x-api-key": ApiKey.webManagementConsoleApi,
          "Authorization": accessToken,
          "x-client-id": clientId,
          "x-company-id": companyId,
          "Content-Type": "application/json",
        };

        var body = jsonEncode({
          "status": event.status,
          "rssfeed_id": event.rssId,
          "rssfeed_item_id": event.feedItemId,
        });

        var response = await http.post(
          Uri.parse(memberProfile),
          headers: headers,
          body: body,
        );

        if (response.statusCode == 201) {
          _setStatus = true;
          add(OnGetLikesStatus());
        }

        // print(
        //     'rssid :: ${event.rssId} , feedid :: ${event.feedItemId}  , status :: ${event.status}');
        // print('pin status :: ${response.body}');
      }
    } catch (err) {
      DebugLogger.error(err);
    }
  }

  Future<FutureOr<void>> _onGetLikesStatus(
      OnGetLikesStatus event, Emitter<EducationState> emit) async {
    String? accessToken = await _authRepository.generateAccessToken();
    String clientId = _me.customAttribute2.userId;
    String companyId = _me.customAttribute2.companyId;

    if (accessToken != null) {
      var headers = {
        "x-api-key": ApiKey.webManagementConsoleApi,
        "Authorization": accessToken,
        "x-client-id": clientId,
        "x-company-id": companyId,
        "Content-Type": "application/json"
      };

      var responseM = await http.get(
          Uri.parse(
              '${ApiConfig.baseUrl}/integrations/rss-feeds/getfavouritestatus'),
          headers: headers);

      Map<int, int> resultMap = Map.from(json
          .decode(responseM.body)['info']
          .fold({},
              (map, item) => map..[item['rssfeed_item_id']] = item['status']));

      emit(state.copyWith(favorites: resultMap,));
      if(_setStatus) {
        emit(state.copyWith(status: Status.completed,));
        _setStatus = false;
      }
    }
  }

  Future<void> _onSearchEducationResults(
      ShowEducationSearchResults event, Emitter<EducationState> emit) async {
    emit(state.copyWith(status: Status.loading));
    List<EducationItem> matchedResults = [];
    List<EducationItem> educationFeedItems =
        state.items.where((item) => item.type == "rssfeed").toList();
    for (var educationItem in educationFeedItems) {
      List<RssFeedItem> feeds = educationItem.rssFeeds;
      List<RssFeedItem> matchedFeeds = [];

      if (feeds.isNotEmpty) {
        for (var rssfeed in feeds) {
          if (rssfeed.title.toLowerCase().contains(event.searchTerm) ||
              rssfeed.description.toLowerCase().contains(event.searchTerm)) {
            matchedFeeds.add(rssfeed);
          }
        }
        if (matchedFeeds.isNotEmpty) {
          educationItem.rssFeeds = matchedFeeds;
          matchedResults.add(educationItem);
        }
      }
    }

    emit(state.copyWith(
        status: matchedResults.isNotEmpty ? Status.completed : Status.failure,
        searchResults: matchedResults));
  }

  void _onResetSearchResults(
      ResetSearchResults event, Emitter<EducationState> emit) {
    emit(state.copyWith(status: Status.loading));
    emit(state.copyWith(
        searchResults: [],
        items: state.educationItems,
        status: Status.completed));
  }
}
