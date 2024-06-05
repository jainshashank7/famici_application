import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:connectivity_checker/connectivity_checker.dart';
import 'package:debug_logger/debug_logger.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:famici/utils/barrel.dart';

import '../../../core/enitity/user.dart';
import '../../../feature/education/education_bloc/education_bloc.dart';
import "../../../feature/notification/entities/notification.dart" as notify;
import '../../../feature/notification/entities/notification_body.dart';
import '../../../feature/notification/helper/dashboard_builder_notification_helper.dart';
import '../../../repositories/auth_repository.dart';
import '../../../repositories/dashboardRepository.dart';
import '../../../utils/config/api_config.dart';

part 'theme_builder_event.dart';
part 'theme_builder_state.dart';

class ThemeBuilderBloc extends Bloc<ThemeBuilderEvent, ThemeBuilderState> {
  ThemeBuilderBloc({
    required User me,
    required EducationBloc educationBloc,
  })  : _me = me,
        _educationBloc = educationBloc,
        super(ThemeBuilderState.initial()) {
    on<FetchDetailsEvent>(_onFetchMemberProfileDetailsEvent);
    on<SetDetailsEvent>(_onSetDetailsEvent);
    on<SubscribeToDashboardChangeEvent>(_onSubscribeToDashboardChangeEvent);
  }

  final User _me;
  final EducationBloc _educationBloc;
  final AuthRepository _authRepository = AuthRepository();

  DashboardRepository dashboardRepository = DashboardRepository();
  StreamSubscription? _dashboardBuilderChangeNotify;
  DateTime? _dateTime;

  void _onSubscribeToDashboardChangeEvent(SubscribeToDashboardChangeEvent event,
      Emitter<ThemeBuilderState> emit) async {
    List<Future<void>> futures = [];

    try {
      _dashboardBuilderChangeNotify =
          FirebaseMessaging.onMessage.listen((event) {
        print("Notification Content ::: ${event.data}");
        if (event.data['type'] == NotificationType.dashboardBuilderUpdated) {
          notify.Notification notification =
              notify.Notification.fromRawJson(event.data['data']);
          if (notification.notificationId.isNotEmpty) {
            add(FetchDetailsEvent(
                hasUpdate: true, updationType: Status.success));
          }
        }
      });
    } catch (err) {
      print(err);
    }

    _dashboardBuilderChangeNotify = dashboardRepository
        .subscribeToDashboardChange(_me.id!)
        .listen((messageData) {
      if (messageData &&
          (_dateTime == null ||
              DateTime.now().isAfter(_dateTime!.add(Duration(seconds: 30))))) {
        _dateTime = DateTime.now();
        print("hey mickuc" + _dateTime.toString());
        print("data for notfication for change" + messageData.toString());
        DashboardBuilderNotificationHelper.notify(notify.Notification(
          type: "dashboard-build-updated",
          notificationId: DateTime.now().microsecondsSinceEpoch.toString(),
          familyId: "",
          contactId: '',
          title: "Dashboard Build Changed !",
          description: "",
          senderContactId: "",
          senderName: "",
          senderPicture: "",
          status: "Unseen",
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          body: NotificationBody(),
          groupKey: "",
        ));
        add(FetchDetailsEvent(hasUpdate: true, updationType: Status.success));
      } else {
        print("hey mickuc, Got the double msgs");
      }
    });
    _dashboardBuilderChangeNotify = dashboardRepository
        .subscribeToDashboardChange(_me.id!)
        .listen((messageData) {
      if (messageData &&
          (_dateTime == null ||
              DateTime.now().isAfter(_dateTime!.add(Duration(seconds: 30))))) {
        _dateTime = DateTime.now();
        print("hey mickuc" + _dateTime.toString());
        print("data for notfication for change" + messageData.toString());
        DashboardBuilderNotificationHelper.notify(notify.Notification(
          type: "dashboard-build-updated",
          notificationId: DateTime.now().microsecondsSinceEpoch.toString(),
          familyId: "",
          contactId: '',
          title: "Dashboard Build Changed !",
          description: "",
          senderContactId: "",
          senderName: "",
          senderPicture: "",
          status: "Unseen",
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          body: NotificationBody(),
          groupKey: "",
        ));
        add(FetchDetailsEvent(hasUpdate: true, updationType: Status.success));
      } else {
        print("hey mickuc, Got the double msgs");
      }
    });
    DebugLogger.info("Subscription for change called");

    // await Future.wait(futures);
  }

  FutureOr<void> _onFetchMemberProfileDetailsEvent(
      FetchDetailsEvent event, Emitter<ThemeBuilderState> emit) async {
    String? email = _me.email;
    String? accessToken = await _authRepository.generateAccessToken();
    String clientId = _me.customAttribute2.userId;
    String companyId = _me.customAttribute2.companyId;
    if (event.hasUpdate != true) {
      add(SubscribeToDashboardChangeEvent());
    }
    int templateT = 0;

    // print("%%%%%%%");
    // print(email);
    // print(accessToken);
    // print(clientId);
    // print(companyId);

    emit(state.copyWith(status: Status.initial));

    if (await _isConnectedToInternet() && accessToken != null) {
      var headers = {
        "x-api-key": ApiKey.webManagementConsoleApi,
        "Authorization": accessToken,
        "x-client-id": clientId,
        "x-company-id": companyId,
        "Content-Type": "application/json"
      };
      // print("this is api key" + ApiKey.webManagementConsoleApi);
      // print("this is auth key" + accessToken);
      // print("this is client id" + clientId);

      // try {
      var imageBody1 = json.encode({
        "ids": [clientId]
      });
      var clientResponse = await http.post(
          Uri.parse('${ApiConfig.baseUrl}/integrations/clients/clients-by-ids'),
          body: imageBody1,
          headers: headers);

      log("client resp :: ${clientResponse.body}");

      var dashboardUsed = json.decode(clientResponse.body)[0]["dashboard_used"];

      var responseT = await http.get(
          Uri.parse(
              '${ApiConfig.baseUrl}/integrations/dashboard-builder/template/$dashboardUsed'),
          headers: headers);

      _educationBloc
          .add(OnGetEducationData(dashboardId: dashboardUsed.toString()));
      log("Response :: ${responseT.body}");
      if (responseT.statusCode == 200 || responseT.statusCode == 201) {
        bool isMhh = json.decode(responseT.body)["templateMeta"]
                    ["application"] ==
                "mobex-health-hub"
            ? true
            : false;
        if (!isMhh) {
          throw Exception("not mhh");
        }

        var responseData = json.decode(responseT.body)["templateMeta"]["data"];
        var responseTheme = json.decode(responseData);
        var logoData = responseTheme["page3"]["logo"]["fileId"];
        var backgroundData = responseTheme["page3"]["background"]["file_id"];
        var imageBody = json.encode({
          "fileIds": [logoData, backgroundData]
        });
        try {
          var responseImages = await http.post(
              Uri.parse(
                  '${ApiConfig.baseUrl}/integrations/dashboard-builder/get-urls'),
              body: imageBody,
              headers: headers);
          print("hi sia this is " + responseImages.body);
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
          print("cgg " + responseImages.body.toString());
        } catch (e) {
          print(e);
          responseTheme["page3"]["logo"]["image"] = "";
          responseTheme["page3"]["background"]["image"] = "";
        }
        ;
        ThemeBuilderState current = ThemeBuilderState.fromJson(
            (responseTheme), templateT, state.templateId, state.status);

        String img = await getImageUrl(current.themeData.background);

        current.themeData.background = img;

        log("rsp for bg :: $responseTheme");

        print(current.dashboardBuilder.gsi);
        print(current.dashboardBuilder.li.items);
        print("sksfdjlj ");
        current.dashboardBuilder.gsi.items.forEach((key, value) {
          print(value);
        });

        try {
          int tempId = int.parse(
              json.decode(responseT.body)["templateMeta"]["template"]);

          templateT = tempId;
          emit(state.copyWith(templateId: tempId, status: Status.completed));
        } catch (err) {
          emit(state.copyWith(templateId: 1, status: Status.completed));
          DebugLogger.error(err);
        }

        print("this is temp id" + state.templateId.toString());

        print('hi chicku this is ' + current.toString());
        // final DatabaseHelperForUsers db = DatabaseHelperForUsers();
        ColorPallet.setKSecondary = current.themeData.colors.secondary;
        ColorPallet.setKPrimary = current.themeData.colors.primary;
        ColorPallet.setKTertiary = current.themeData.colors.tertiary;
        ColorPallet.setKSecondaryText = current.themeData.colors.secondaryText;
        ColorPallet.setKPrimaryText = current.themeData.colors.primaryText;
        ColorPallet.setKTertiaryText = current.themeData.colors.tertiaryText;
//           List<DashboardItem?> dashboardList =
//               current.dashboardBuilder.gsi.items.values.toList();
// // Use Future.wait to fetch images concurrently
//           List images =
//               await Future.wait(dashboardList.map((DashboardItem? value) async {
//             if (value != null && value.fileId != null) {
//               print("this is new and old value +" +
//                   value.id +
//                   " for " +
//                   value.image.toString());
//               return await getImageUrl(value.fileId!);
//             }
//             return null;
//           }));

//           // Update images in the DashboardItems
//           for (int i = 0; i < dashboardList.length; i++) {
//             DashboardItem? value = dashboardList[i];
//             if (value != null) {
//               value.image = images[i];
//               print("this is new and changed value +" +
//                   value.id +
//                   " for " +
//                   value.image.toString());
//             }
//           }

        emit(state.copyWith(
            functionList: current.themeData,
            coreApps: current.dashboardBuilder));
      } else {}
      // } catch (e) {
      //   print('dashboard error rrrrr' + e.toString());
      //   ThemeBuilderState current = ThemeBuilderState.initial();
      //   ColorPallet.setKSecondary = current.themeData.colors.secondary;
      //   ColorPallet.setKPrimary = current.themeData.colors.primary;
      //   ColorPallet.setKTertiary = current.themeData.colors.tertiary;
      //   ColorPallet.setKSecondaryText = current.themeData.colors.secondaryText;
      //   ColorPallet.setKPrimaryText = current.themeData.colors.primaryText;
      //   ColorPallet.setKTertiaryText = current.themeData.colors.tertiaryText;
      //   emit(state.copyWith(
      //       functionList: current.themeData,
      //       coreApps: current.dashboardBuilder));
      // }

      // var response = {
      //   "id": 1,
      //   "themeData": {
      //     "colors": {
      //       "primary": "#007EC1",
      //       "secondary": "#BFC587",
      //       "tertiary": "#4CBC9A"
      //     },
      //     "background":
      //         "https://images.unsplash.com/photo-1509114397022-ed747cca3f65?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1935&q=80",
      //     // "background":
      //     //     "https://plus.unsplash.com/premium_photo-1666900440561-94dcb6865554?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=327&q=80",
      //     "logo":
      //         "https://images.unsplash.com/photo-1516876437184-593fda40c7ce?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTh8fGxvZ298ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=500&q=60"
      //   },
      //   "dashboardBuilder": {
      //     "LI": {
      //       "LI 3": {
      //         "id": "1",
      //         "name": "Appts",
      //         "height": 120,
      //         "width": 220,
      //         "class": "list-item removed",
      //         "image": "/img/appts.644b7b75.png"
      //       },
      //       "LI 4": {
      //         "id": "2",
      //         "name": "Care Team",
      //         "height": 470,
      //         "width": 375,
      //         "class": "list-item removed",
      //         "image": "/img/care-team.411859a5.png"
      //       },
      //       "LI 5": {
      //         "id": "8",
      //         "name": "Vitals",
      //         "height": 140,
      //         "width": 240,
      //         "class": "list-item removed",
      //         "image": "/img/vital.8d4f2589.png"
      //       },
      //       "LI 6": {
      //         "id": "8",
      //         "name": "Medicine",
      //         "height": 140,
      //         "width": 240,
      //         "class": "list-item removed",
      //         "image": "/img/vital.8d4f2589.png"
      //       },
      //     },
      //     "GSI": {
      //       "GSI 1": {
      //         "id": "3",
      //         "name": "Let Connect",
      //         "androidId": "a",
      //         "iosId": "b",
      //         "type": "core",
      //         "image": "/img/content-education.dcef363c.png"
      //       },
      //       "GSI 2": {
      //         "id": "5",
      //         "name": "Web Links",
      //         "androidId": "a",
      //         "iosId": "b",
      //         "type": "core",
      //         "image": "/img/let-connect.fedd225b.png"
      //       },
      //       "GSI 3": {
      //         "id": "7",
      //         "name": "Content Education",
      //         "androidId": "a",
      //         "iosId": "b",
      //         "type": "core",
      //         "image": "/img/photos.5fcf05e6.png"
      //       },
      //       "GSI 4": {
      //         "id": "4",
      //         "name": "Entertainment",
      //         "androidId": "a",
      //         "iosId": "b",
      //         "type": "core",
      //         "image": "/img/entertainment.e23cae10.png"
      //       },
      //       "GSI 5": {
      //         "id": "4",
      //         "name": "Photos",
      //         "androidId": "a",
      //         "iosId": "b",
      //         "type": "core",
      //         "image": "/img/entertainment.e23cae10.png"
      //       },
      //     }
      //   }
      // };

      // var response2 = '''{
      //   "logo": {
      //     "fileId": "files/26180.png",
      //     "image":
      //         "https://images.unsplash.com/photo-1516876437184-593fda40c7ce?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTh8fGxvZ298ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=500&q=60"
      //   },
      //   "background": {
      //     "image":
      //         "https://images.unsplash.com/photo-1509114397022-ed747cca3f65?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1935&q=80",
      //     "file_id": "files/26141.png",
      //   },
      // }''';
      // var res = json.decode(response);
      // var res2 = json.decode(response2);
      // res["page3"]["logo"]["image"] = res2["logo"]["image"];
      // res["page3"]["background"]["image"] = res2["background"]["image"];
      // print('hi chicku this is mm' + res.toString());
    } else {
      ThemeBuilderState current = ThemeBuilderState.initial();
      ColorPallet.setKSecondary = current.themeData.colors.secondary;
      ColorPallet.setKPrimary = current.themeData.colors.primary;
      ColorPallet.setKTertiary = current.themeData.colors.tertiary;
      ColorPallet.setKSecondaryText = current.themeData.colors.secondaryText;
      ColorPallet.setKPrimaryText = current.themeData.colors.primaryText;
      ColorPallet.setKTertiaryText = current.themeData.colors.tertiaryText;
      emit(state.copyWith(
          functionList: current.themeData, coreApps: current.dashboardBuilder));
    }

    emit(state.copyWith(status: Status.completed));
  }

  Future<String> getImageUrl(String fileId) async {
    String clientId = _me.customAttribute2.userId;
    String companyId = _me.customAttribute2.companyId;
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
    print("this is 3rdparty data " + fileId);
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
        if (responseImages.statusCode == 200 ||
            responseImages.statusCode == 201) {
          print("this is 3rdparty data one " +
              reponseImageData["data"][0]["image"]);
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
      ;
    }

    return '';
  }

  Future<bool> _isConnectedToInternet() async {
    return await ConnectivityWrapper.instance.isConnected;
  }

  FutureOr<void> _onSetDetailsEvent(
      SetDetailsEvent event, Emitter<ThemeBuilderState> emit) {
    emit(state.copyWith(status: Status.initial, templateId: 0));
  }
}
