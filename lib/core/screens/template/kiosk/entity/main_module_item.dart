import 'dart:convert';
import 'dart:ui';

import 'package:debug_logger/debug_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../../../repositories/auth_repository.dart';
import '../../../../../utils/config/api_config.dart';
import '../../../../../utils/config/api_key.dart';
import '../../../../blocs/theme_builder_bloc/theme_builder_bloc.dart';
import 'kiosk_color_pallet.dart';

class MainModuleItem {
  int id;
  String title;
  String image;
  String url;
  String imageUrl;
  String type;
  Color color;
  int position;
  Color textColor;
  String androidId;
  String iosId;
  String windowsId;
  bool isSensitive;
  int? sensitiveScreenTimeOut;
  int? sensitiveAlertTimeOut;
  bool showQR;
  String? documentId;
  MainModuleItem({
    required this.id,
    required this.title,
    required this.image,
    required this.url,
    required this.imageUrl,
    required this.type,
    required this.color,
    required this.position,
    required this.textColor,
    required this.androidId,
    required this.iosId,
    required this.windowsId,
    required this.isSensitive,
    this.sensitiveScreenTimeOut,
    this.sensitiveAlertTimeOut,
    required this.showQR,
    this.documentId
  });

  factory MainModuleItem.fromJson(Map<String, dynamic> json, String type)  {
    MainModuleItem m;
    print("MainModule");
    print(json);
    return MainModuleItem(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      url: json['url'],
      imageUrl: "",
      type: type,
      position: int.parse(json['position']),
      color:
          json['color'] == null || json['color'] == "" || json['color'] == " "
              ? KioskColorPallet.kPrimary
              : ColorData.parseColor(json['color']),
      textColor: json['textColor'] == null ||
              json['textColor'] == "" ||
              json['textColor'] == " "
          ? KioskColorPallet.kSecondary
          : ColorData.parseColor(json['textColor']),
      androidId: type == '3rdParty' ? json['android_id'] : "",
      iosId: type == '3rdParty' ? json['ios_id'] : "",
      windowsId: type == '3rdParty' ? json['windows_id'] : "",
      isSensitive: json["isSensitive"] != null
          ? json["isSensitive"] == 0
              ? false
              : true
          : false,
      documentId: json['document_id'].toString(),
      sensitiveScreenTimeOut: json["sensitiveScreenTimeout"] ?? null,
      showQR: json["enableQR"] == 1 ? true : false,
    );
    // return m;
  }

  static Future<MainModuleItem> createFromJson(
      Map<String, dynamic> json, String type) async {
    MainModuleItem m;
    m = MainModuleItem(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      url: json['url'],
      imageUrl: json['imageUrl'],
      type: type,
      position: int.parse(json['position']),
      color:
          json['color'] == null || json['color'] == "" || json['color'] == " "
              ? KioskColorPallet.kPrimary
              : ColorData.parseColor(json['color']),
      textColor: json['textColor'] == null ||
              json['textColor'] == "" ||
              json['textColor'] == " "
          ? KioskColorPallet.kSecondary
          : ColorData.parseColor(json['textColor']),
      androidId: type == '3rdParty' ? json['android_id'] : "",
      documentId: json['document_id'].toString(),
      iosId: type == '3rdParty' ? json['ios_id'] : "",
      windowsId: type == '3rdParty' ? json['windows_id'] : "",
      isSensitive: json["isSensitive"] != null
          ? json["isSensitive"] == 0
              ? false
              : true
          : false,
      showQR: json["enableQR"] == 1 ? true : false,
    );
    m.imageUrl = await getImageUrl(m.image);
    return m;
  }

  static List<Future<MainModuleItem>> fromJsonList(
      List<dynamic> jsonList, String type) {
    return jsonList.map((json) => createFromJson(json, type)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'url': url,
      'imageUrl': imageUrl,
      'type': type,
      'color': color,
      'position': position,
      'textColor': textColor,
      'isSensitive': isSensitive,
      "documentId": documentId
    };
  }
}

Future<String> getImageUrl(String fileId) async {
  final AuthRepository _authRepository = AuthRepository();
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
