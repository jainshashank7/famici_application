import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:connectivity_checker/connectivity_checker.dart';
import 'package:debug_logger/debug_logger.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../feature/kiosk_generic/entity/sub_module_link.dart';
import '../../../../../repositories/auth_repository.dart';
import '../../../../../utils/config/api_config.dart';
import '../../../../../utils/config/api_key.dart';
import '../../../../../utils/constants/enums.dart';
import '../../../../blocs/theme_builder_bloc/theme_builder_bloc.dart';
import '../../../../enitity/user.dart';
import '../entity/main_module_info.dart';
import '../entity/main_module_item.dart';
import '../entity/sub_module_info.dart';
import '../entity/sub_module_item.dart';
import '../rss_feed/feed.dart';
import '../rss_feed/fetch_feeds.dart';

part 'kiosk_dashboard_event.dart';
part 'kiosk_dashboard_state.dart';

class KioskDashboardBloc
    extends Bloc<KioskDashboardEvent, KioskDashboardState> {
  KioskDashboardBloc({
    required User me,
  })  : _me = me,
        super(KioskDashboardState.initial()) {
    on<FetchMainModuleDetailsEvent>(_onFetchMainModuleDetailsEvent);
    on<FetchMainModuleInfoEvent>(_onFetchMainModuleInfoEvent);
    on<FetchSubModuleDetailsEvent>(_onFetchSubModuleDetailsEvent);
    on<FetchSubModuleInfoEvent>(_onFetchSubModuleInfoEvent);
    on<FetchSubModuleLinksEvent>(_onFetchSubModuleLinksEvent);
    on<FetchSubModuleLinksInfoEvent>(_onFetchSubModuleLinksInfoEvent);
    on<ResetDashboardMainModuleState>(_onResetDashboardMainModuleState);
    on<LoadMoreRSSFeeds>(_loadMoreRSSFeeds);
    on<ResetRSSFeedsCount>(_resetRSSFeedsCount);
  }

  final User _me;
  final AuthRepository _authRepository = AuthRepository();
  bool enableQR = false;

  DateTime? _dateTime;

  Future<FutureOr<void>> _onFetchMainModuleDetailsEvent(
      FetchMainModuleDetailsEvent event,
      Emitter<KioskDashboardState> emit) async {
    // if (event.hasUpdate) {
    print("heyy successs");
    emit(state.copyWith(status: Status.loading));
    // }
    String? accessToken = await _authRepository.generateAccessToken();
    String clientId = _me.customAttribute2.userId;
    String companyId = _me.customAttribute2.companyId;

    List<MainModuleItem> mainModuleItems = [];
    List<String> fileIds = [];

    if (await isConnectedToInternet() && accessToken != null) {
      var headers = {
        "x-api-key": ApiKey.webManagementConsoleApi,
        "Authorization": accessToken,
        "x-client-id": clientId,
        "x-company-id": companyId,
        "Content-Type": "application/json"
      };

      // var imageBody1 = json.encode({
      //   "ids": [clientId]
      // });
      // var clientResponse = await http.post(
      //     Uri.parse('${ApiConfig.baseUrl}/integrations/clients/clients-by-ids'),
      //     body: imageBody1,
      //     headers: headers);
      //
      // DebugLogger.info(
      //     "hi dashboard used $clientId ${json.decode(clientResponse.body)}");
      var dashboardUsed = event.dashboardUsed;

      emit(state.copyWith(dashboardId: dashboardUsed));

      var mainModuleResponse = await http.get(
          Uri.parse(
              '${ApiConfig.baseUrl}/integrations/generic-modules/modulelist/kiosk/$dashboardUsed'),
          headers: headers);

      var responseT = await http.get(
          Uri.parse(
              '${ApiConfig.baseUrl}/integrations/dashboard-builder/template/$dashboardUsed'),
          headers: headers);

      emit(state.copyWith(themeDataJson: responseT));

      try {
        if (responseT.statusCode == 200 || responseT.statusCode == 201) {
          var responseData =
              json.decode(responseT.body)["templateMeta"]["data"];
          var responseTheme = json.decode(responseData);
          var logoData = responseTheme["page3"]["logo"]["fileId"];
          var backgroundData = responseTheme["page3"]["background"]["file_id"];
          var imageBody = json.encode({
            "fileIds": [logoData, backgroundData]
          });

          DebugLogger.info(responseTheme["page3"]);

          try {
            var responseImages = await http.post(
                Uri.parse(
                    '${ApiConfig.baseUrl}/integrations/dashboard-builder/get-urls'),
                body: imageBody,
                headers: headers);

            var reponseImageData = json.decode(responseImages.body);
            if (responseImages.statusCode == 200 ||
                responseImages.statusCode == 200) {
              responseTheme["page3"]["logo"]["image"] =
                  reponseImageData["data"][0]["image"];
              responseTheme["page3"]["background"]["image"] =
                  reponseImageData["data"][1]["image"];
            } else {
              responseTheme["page3"]["logo"]["image"] = "";
              responseTheme["page3"]["background"]["image"] = "";
            }

            DebugLogger.info(reponseImageData["data"][1]);
          } catch (e) {
            print(e);
            responseTheme["page3"]["logo"]["image"] = "";
            responseTheme["page3"]["background"]["image"] = "";
          }
          // ThemeBuilderState current =
          //     ThemeBuilderState.fromJson((responseTheme));
          print("hey this is the background AND LOGO" +
              state.background +
              " ff " +
              state.logo);

          print(responseTheme["page3"]["colorScheme"]);
          Map<String, dynamic> colorScheme =
              responseTheme["page3"]["colorScheme"];

          // Get the selected option
          String selectedOption = colorScheme['selectedOption'];

          // Get the corresponding colors array
          List<dynamic> colors;
          if (selectedOption == 'primary_colors') {
            colors = colorScheme['primary_colors'];
          } else if (selectedOption == 'secondary_colors') {
            colors = colorScheme['secondary_colors'];
          } else {
            colors = colorScheme['customized_colors'];
          }

          // Set the primary and secondary colors
          String primaryColor = colors.isNotEmpty
              ? colors[0]
              : '#000000'; // Default to black if colors array is empty
          String secondaryColor = colors.length > 1
              ? colors[1]
              : '#000000'; // Default to black if colors array has only one color
          emit(state.copyWith(
              background: responseTheme["page3"]["background"]["image"],
              logo: responseTheme["page3"]["logo"]["image"],
              primaryColor: ColorData.parseColor(primaryColor),
              secondaryColor: ColorData.parseColor(secondaryColor)));

          // Now you can use primaryColor and secondaryColor in your app
          print('Primary Color: $primaryColor');
          print('Secondary Color: $secondaryColor');

          // secondaryColor: ColorData.parseColor( responseTheme["page3"]["colorScheme"]["colors"][1]),
          // primaryColor: ColorData.parseColor( responseTheme["page3"]["colorScheme"]["colors"][0])));

          // KioskColorPallet.setKSecondary = current.themeData.colors.secondary;
          // KioskColorPallet.setKPrimary = current.themeData.colors.primary;
        } else {}
      } catch (err) {
        DebugLogger.error(err);
      }

      if (responseT.statusCode == 200 || responseT.statusCode == 201) {
        var templateMeta = json.decode(responseT.body)["templateMeta"];

        log(responseT.body);

        //Getting data to toggle Download Now Button
        // enableQR = templateMeta['enableQR'] == 1 ? true: false;

        var responseData = templateMeta["data"];
        var responseTheme = json.decode(responseData);

        try {
          bool isKiosk = templateMeta["application"] == "kiosk" ? true : false;
          // emit(state.copyWith(isKiosk: isKiosk));
          if (!isKiosk) {
            throw Exception("not kiosk");
          }
          print('this is the data');

          bool hasRSS = false;
          List<dynamic> genericItems =
              responseTheme["page2"]["genericFunctions"];
          genericItems.asMap().forEach((key, value) {
            if (value["function_name"] == "RSS Feed") {
              hasRSS = true;
            }
          });
          DebugLogger.error("RSS hai ki nahi ::: $hasRSS");

          // DebugLogger.info("RSS FEED DATA ::: ${responseTheme["page2"]["genericFunctions"]}");
          // DebugLogger.info("RSS FEED DATA ::: ${responseTheme["page2"]["genericFunctions"].runtimeType}");
          // // String feedUrl =  responseTheme["page4"]["template"]["GSI"]["GSI 1"]["elements"][0]["info"]["feedurl"];
          DebugLogger.info("this is that data ${templateMeta["rssinfo"]}");

          if (hasRSS && templateMeta["rssinfo"] != null) {
            var data = jsonDecode(templateMeta["rssinfo"]);
            String rssContent;
            String title = "Explore Related Articles";
            print("ISEXTERNALURL ::: ${data["isExternalUrl"]}");
            if (!data["isExternalUrl"]) {
              int rssId = data["id"];
              rssContent = await getRssData(rssId);
              title = await fetchRssFeedTitle(rssContent);
            } else {
              var response = await http.get(Uri.parse(data["url"]));
              print("RSS RESPONSE");
              rssContent = response.body;
            }

            Map<String, dynamic> feedsDataMap = await fetchRssFeed(
                jsonDecode(rssContent), data["isExternalUrl"]);
            List<RssFeedItem> feeds = feedsDataMap["rssFeedItems"];

            print("FEEDS :: ${feeds}");
            emit(state.copyWith(
                feeds: feeds, showFeeds: feeds.length < 4 ? feeds.length : 3));
          } else {
            emit(state.copyWith(feeds: []));
          }
        } catch (err) {
          print("error in feeds ::: ${err}");
          emit(state.copyWith(feeds: []));
        }

        enableQR = responseTheme['page2']['enableQR'] == 1
            ? true
            : (templateMeta['enableQR'] == 1 ? true : false);
        DebugLogger.info("Response theme:: $responseTheme['page2']");
        Map<String, dynamic> moduleList =
            responseTheme["page4"]["template"]["LI"];

        print("page4 data11");
        DebugLogger.info(moduleList);

        for (var element in moduleList.entries) {
          // print("Irerable::: ${element}");
          var key = element.key;
          var name = key.split(" ");
          // print(name);
          List<dynamic> res = element.value["elements"];

          if (res.isNotEmpty && res[0]["function_type"] == "3rdParty") {
            try {
              fileIds.add(res[0]["fileId"]);
              MainModuleItem mainModuleItem = MainModuleItem(
                  id: res[0]["id"],
                  title: res[0]["function_name"],
                  image: res[0]["fileId"],
                  url: "",
                  imageUrl: "",
                  type: res[0]["function_type"],
                  color: ColorData.parseColor(
                      responseTheme["page3"]["colorScheme"]["colors"][0]),
                  position: int.parse(name[1]),
                  textColor: ColorData.parseColor(
                      responseTheme["page3"]["colorScheme"]["colors"][1]),
                  androidId: res[0]["android_id"],
                  iosId: res[0]["ios_id"],
                  windowsId: res[0]["windows_id"],
                  isSensitive: false,
                  showQR: false);
              print(
                element.value["elements"][0]["function_type"],
              );

              print("ColorData");
              // DebugLogger.debug(json.decode(responseT.body)["page3"]["colorScheme"]["colors"][0]);
              print(mainModuleItem.toJson());
              mainModuleItems.add(mainModuleItem);
            } catch (err) {
              print("ERRRRRRRRROOOOOOOOORRRRRRR");
              DebugLogger.error(err);
            }
          }
        }
      }

      if (mainModuleResponse.statusCode == 200) {
        print("WEBLINKS");
        DebugLogger.debug(json.decode(mainModuleResponse.body)['webLink']);
        List<dynamic> webLinks =
            json.decode(mainModuleResponse.body)['webLink'];
        List<dynamic> pdfLinks =
            json.decode(mainModuleResponse.body)['pdfLink'];
        List<dynamic> videoLinks =
            json.decode(mainModuleResponse.body)['videoLink'];
        List<dynamic> modules =
            json.decode(mainModuleResponse.body)['dashboardPage'];

        mainModuleItems.addAll(webLinks.map((weblink) {
          fileIds.add(weblink["image"]);
          // DebugLogger.info(weblink);
          return MainModuleItem.fromJson(weblink, "weblink");
        }).toList());

        mainModuleItems.addAll(pdfLinks.map((pdfLink) {
          fileIds.add(pdfLink["image"]);
          return MainModuleItem.fromJson(pdfLink, "pdf");
        }).toList());

        mainModuleItems.addAll(videoLinks.map((videoLink) {
          fileIds.add(videoLink["image"]);
          return MainModuleItem.fromJson(videoLink, "video");
        }).toList());

        mainModuleItems.addAll(modules.map((module) {
          fileIds.add(module["image"]);
          return MainModuleItem.fromJson(module, "module");
        }).toList());

        var data = json.decode((await getImageUrls(fileIds)).body);
        mainModuleItems.asMap().forEach((key, value) {
          value.imageUrl = data["data"][key]["image"];
        });

        List<MainModuleItem> updatedMainModuleItems =
            List.generate(12, (index) {
          var existingItem = mainModuleItems.firstWhere(
            (item) => item.position - 1 == index,
            orElse: () => MainModuleItem(
                id: index,
                title: "empty-we-made-it",
                image: '',
                url: '',
                imageUrl: '',
                type: '',
                color: Colors.red,
                position: index,
                textColor: Colors.red,
                androidId: "",
                iosId: "",
                documentId: "",
                windowsId: "",
                isSensitive: false,
                showQR: false),
          );

          return existingItem;
        });

        updatedMainModuleItems.sort((a, b) => a.position.compareTo(b.position));

        // print('%%%%%%%%%%%');
        // for (int i = 0; i < 12; i++) {
        //   print(updatedMainModuleItems[i].toJson());
        // }
        // print("hey state change");

        if (event.hasUpdate) {
          print("heyy successs");
          emit(state.copyWith(
              status: Status.success, mainModuleItems: updatedMainModuleItems));
        } else {
          emit(state.copyWith(
              status: Status.completed,
              mainModuleItems: updatedMainModuleItems));
        }
      }
    }
  }

  Future<String> getRssData(int id) async {
    print('rss data new');
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

        print('rss data new ${response.body}');

        return jsonDecode(response.body)['info']["rss_content"];
      }
    } catch (err) {
      DebugLogger.error(err);
    }
    return "";
  }

  Future<FutureOr<void>> _onFetchSubModuleDetailsEvent(
      FetchSubModuleDetailsEvent event,
      Emitter<KioskDashboardState> emit) async {
    emit(state.copyWith(subModuleItems: [], status: Status.loading));
    String? accessToken = await _authRepository.generateAccessToken();
    String clientId = _me.customAttribute2.userId;
    String companyId = _me.customAttribute2.companyId;

    if (await isConnectedToInternet() && accessToken != null) {
      String baseURL =
          '${ApiConfig.baseUrl}/integrations/generic-modules/submodulelist/${event.id}';

      var headers = {
        "x-api-key": ApiKey.webManagementConsoleApi,
        "Authorization": accessToken,
        "x-client-id": clientId,
        "x-company-id": companyId,
      };

      var response = await http.get(Uri.parse(baseURL), headers: headers);

      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);

        List<SubModuleItem> subModuleItems = await Future.wait(
          jsonList.map((json) async {
            DebugLogger.info("Json1122 ::: $json");

            // print(canLaunch);
            if (json['allow3rdParty'] == 1 && Platform.isWindows) {
              var thirdParty = json['thirdPartyValue'] != null
                  ? jsonDecode(json['thirdPartyValue'])
                  : null;
              var canLaunch = thirdParty != null
                  ? thirdParty["windows_id"] != null &&
                          thirdParty["windows_id"] != ""
                      ? await canLaunchUrlString(thirdParty["windows_id"])
                      : false
                  : false;
              // print(" IF :: ${json["id"]}");
              var imgUrl = await getImageUrl(thirdParty["fileId"]);
              return canLaunch
                  ? SubModuleItem.SubModulefromJson(json, Colors.white, imgUrl)
                  : SubModuleItem.SubModulefromJson(json, Colors.grey, imgUrl);
            } else if (json['url'] == '') {
              print("ELSE IF :: ${json["id"]}");
              var thirdParty = json['thirdPartyValue'] != null
                  ? jsonDecode(json['thirdPartyValue'])
                  : null;
              var imgUrl = json['allow3rdParty'] == 0
                  ? await getImageUrl(json["image"])
                  : thirdParty != null
                      ? await getImageUrl(thirdParty["fileId"])
                      : "";
              add(FetchSubModuleLinksEvent(id: json['id']));
              return SubModuleItem.SubModulefromJson(
                  json, Colors.white, imgUrl);
            } else {
              print("ELSE :: ${json["id"]}");
              var imgUrl = await getImageUrl(json["image"]);
              return SubModuleItem.SubModulefromJson(
                  json, Colors.white, imgUrl);
            }
          }),
        );

        // var res =  jsonList.map((json) async{
        //   if(json['url'] == ''){
        //     add(FetchSubModuleLinksEvent(id: json['id']));
        //     return SubModuleItem.fromJson(json, Colors.white);
        //   }
        //   else if(json['allow3rdParty'] == 1 && Platform.isWindows && !(await canLaunchUrlString(json['windowsId']))){
        //
        //     return SubModuleItem.fromJson(json,Colors.grey);
        //   }
        //   else {
        //     return SubModuleItem.fromJson(json,Colors.white);
        //   }
        //
        // }).cast<SubModuleItem>().toList();

        // List<SubModuleItem> subModules =
        //     SubModuleItem.fromJsonList(jsonDecode(response.body));

        // Color buttonColor;
        // for (var item in subModules) {
        //   if (item.url == '') {
        //     add(FetchSubModuleLinksEvent(id: item.id));
        //   }
        //   // else if(item.allow3rdParty == 1 && Platform.isWindows && await canLaunchUrlString(item.windowsId)){
        //   //
        //   // }
        // }

        emit(state.copyWith(
            subModuleItems: subModuleItems, status: Status.completed));
      }
    }
  }

  Future<FutureOr<void>> _onFetchMainModuleInfoEvent(
      FetchMainModuleInfoEvent event, Emitter<KioskDashboardState> emit) async {
    String? accessToken = await _authRepository.generateAccessToken();
    String clientId = _me.customAttribute2.userId;
    String companyId = _me.customAttribute2.companyId;

    if (await isConnectedToInternet() && accessToken != null) {
      String baseURL =
          '${ApiConfig.baseUrl}/integrations/generic-modules/module/1';

      var headers = {
        "x-api-key": ApiKey.webManagementConsoleApi,
        "Authorization": accessToken,
        "x-client-id": clientId,
        "x-company-id": companyId,
      };

      var response = await http.get(Uri.parse(baseURL), headers: headers);

      print(response.body);

      if (response.statusCode == 200) {
        MainModuleInfo mainModuleInfo =
            MainModuleInfo.fromJson(jsonDecode(response.body));

        emit(state.copyWith(mainModuleInfo: mainModuleInfo));
      }
    }
  }

  Future<FutureOr<void>> _onFetchSubModuleInfoEvent(
      FetchSubModuleInfoEvent event, Emitter<KioskDashboardState> emit) async {
    String? accessToken = await _authRepository.generateAccessToken();
    String clientId = _me.customAttribute2.userId;
    String companyId = _me.customAttribute2.companyId;

    if (await isConnectedToInternet() && accessToken != null) {
      String baseURL =
          '${ApiConfig.baseUrl}/integrations/generic-modules/submodule/1';

      var headers = {
        "x-api-key": ApiKey.webManagementConsoleApi,
        "Authorization": accessToken,
        "x-client-id": clientId,
        "x-company-id": companyId,
      };

      var response = await http.get(Uri.parse(baseURL), headers: headers);

      print(response);

      if (response.statusCode == 200) {
        SubModuleInfo subModuleInfo =
            SubModuleInfo.fromJson(jsonDecode(response.body));

        emit(state.copyWith(subModuleInfo: subModuleInfo));
      }
    }
  }

  Future<FutureOr<void>> _onFetchSubModuleLinksEvent(
      FetchSubModuleLinksEvent event, Emitter<KioskDashboardState> emit) async {
    String? accessToken = await _authRepository.generateAccessToken();
    String clientId = _me.customAttribute2.userId;
    String companyId = _me.customAttribute2.companyId;

    if (await isConnectedToInternet() && accessToken != null) {
      String baseURL =
          '${ApiConfig.baseUrl}/integrations/generic-modules/submodulelinkslist/${event.id}';

      var headers = {
        "x-api-key": ApiKey.webManagementConsoleApi,
        "Authorization": accessToken,
        "x-client-id": clientId,
        "x-company-id": companyId,
      };

      var response = await http.get(Uri.parse(baseURL), headers: headers);

      if (response.statusCode == 200) {
        List<SubModuleLink> list =
            SubModuleLink.fromJsonList(jsonDecode(response.body));

        Map<int, List<SubModuleLink>> old = state.subModuleLinks;
        old[event.id] = list;

        emit(state.copyWith(subModuleLinks: old));
      }
      print(state.subModuleLinks);
    }
  }

  Future<FutureOr<void>> _onFetchSubModuleLinksInfoEvent(
      FetchSubModuleLinksInfoEvent event,
      Emitter<KioskDashboardState> emit) async {
    String? accessToken = await _authRepository.generateAccessToken();
    String clientId = _me.customAttribute2.userId;
    String companyId = _me.customAttribute2.companyId;

    if (await isConnectedToInternet() && accessToken != null) {
      String baseURL =
          '${ApiConfig.baseUrl}/integrations/generic-modules/submodulelinks/:id';

      var headers = {
        "x-api-key": ApiKey.webManagementConsoleApi,
        "Authorization": accessToken,
        "x-client-id": clientId,
        "x-company-id": companyId,
      };

      var response = await http.get(Uri.parse(baseURL), headers: headers);
    }
  }

  Future<bool> isConnectedToInternet() async {
    return await ConnectivityWrapper.instance.isConnected;
  }

  FutureOr<void> _onResetDashboardMainModuleState(
      ResetDashboardMainModuleState event, Emitter<KioskDashboardState> emit) {
    emit(state.copyWith(
      mainModuleItems: [],
    ));
  }

  Future<Response> getImageUrls(List<String> fileId) async {
    final prefs = await SharedPreferences.getInstance();
    String companyId = prefs.getString('companyId') ?? "";
    String clientId = prefs.getString('clientId') ?? "";
    String? accessToken = await _authRepository.generateAccessToken();
    var headers;
    if (accessToken != null) {
      headers = {
        "x-api-key": ApiKey.webManagementConsoleApi,
        "Authorization": accessToken,
        "x-client-id": clientId,
        "x-company-id": companyId,
        "Content-Type": "application/json"
      };
    } else {
      headers = {};
    }
    print("Inside getImageURls ${fileId}");
    // print("this is 3rdparty data file id " + fileId);
    var imageBody = json.encode({"fileIds": fileId});
    if (accessToken != null) {
      try {
        var responseImages = await http.post(
            Uri.parse(
                '${ApiConfig.baseUrl}/integrations/dashboard-builder/get-urls'),
            body: imageBody,
            headers: headers);

        var reponseImageData = json.decode(responseImages.body);
        // print("Image Data df ::: ${reponseImageData}");
        if (responseImages.statusCode == 200 ||
            responseImages.statusCode == 201) {
          // print("this is 3rdparty data one " +
          //     reponseImageData["data"][0]["image"]);
          return responseImages;
        } else {
          print("this is 3rdparty data no data  two ");
          return Response("", 200);
        }
      } catch (e) {
        print("this is 3rdparty data no data error " + e.toString());
        DebugLogger.error(e);
        return Response("", 400);
      }
    }

    return Response("", 400);
  }

  Future<String> getImageUrl(String fileId) async {
    final prefs = await SharedPreferences.getInstance();
    String companyId = prefs.getString('companyId') ?? "";
    String clientId = prefs.getString('clientId') ?? "";
    String? accessToken = await _authRepository.generateAccessToken();
    var headers;
    if (accessToken != null) {
      headers = {
        "x-api-key": ApiKey.webManagementConsoleApi,
        "Authorization": accessToken,
        "x-client-id": clientId,
        "x-company-id": companyId,
        "Content-Type": "application/json"
      };
    } else {
      headers = {};
    }
    // print("this is 3rdparty data file id " + fileId);
    var imageBody = json.encode({
      "fileIds": [fileId]
    });
    if (accessToken != null) {
      try {
        var responseImages = await http.post(
            Uri.parse(
                '${ApiConfig.baseUrl}/integrations/dashboard-builder/get-urls'),
            body: imageBody,
            headers: headers);

        var reponseImageData = json.decode(responseImages.body);
        // print("Image Data df ::: ${reponseImageData}");
        if (responseImages.statusCode == 200 ||
            responseImages.statusCode == 201) {
          // print("this is 3rdparty data one " +
          //     reponseImageData["data"][0]["image"]);
          return reponseImageData["data"][0]["image"];
        } else {
          print("this is 3rdparty data no data  two ");
          return "";
        }
      } catch (e) {
        print("this is 3rdparty data no data error " + e.toString());
        DebugLogger.error(e);
        return "";
      }
    }

    return '';
  }

  void _loadMoreRSSFeeds(LoadMoreRSSFeeds event, emit) {
    int totalFeeds = state.showFeeds + event.addFeeds;
    emit(state.copyWith(
        showFeeds:
            state.feeds.length < totalFeeds ? state.feeds.length : totalFeeds));
  }

  void _resetRSSFeedsCount(ResetRSSFeedsCount event, emit) {
    emit(state.copyWith(
        showFeeds: state.feeds.length < 4 ? state.feeds.length : 3));
  }
}
