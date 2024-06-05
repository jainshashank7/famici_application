import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:famici/core/screens/template/kiosk/entity/kiosk_color_pallet.dart';

import '../../../../blocs/theme_builder_bloc/theme_builder_bloc.dart';
import 'main_module_item.dart';

class SubModuleItem {
  int id;
  String title;
  String image;
  String url;
  String description;
  String imageUrl;
  String iosId;
  String? moduleType;
  String androidId;
  String windowsId;
  bool allow3rdParty;
  Color buttonColor;
  bool isSensitive;
  int? sensitiveScreenTimeOut;
  int? sensitiveAlertTimeOut;
  bool showQR;
  Color textColor;
  String? documentId;

  SubModuleItem(
      {required this.id,
      required this.title,
      required this.image,
      required this.url,
      required this.description,
      required this.imageUrl,
      required this.allow3rdParty,
      required this.androidId,
      required this.iosId,
      required this.windowsId,
      required this.buttonColor,
      required this.isSensitive,
      this.sensitiveScreenTimeOut,
      this.sensitiveAlertTimeOut,
      required this.showQR,
      required this.textColor,
      this.documentId,
      this.moduleType,
      });


  static Future<SubModuleItem> SubModulefromJson(
      Map<String, dynamic> json, Color color, String imageUrl) async {

    var thirdParty = json['thirdPartyValue'] != null
        ? jsonDecode(json['thirdPartyValue'])
        : null;
    log("hiii json part 2 $json");

    final subModule = SubModuleItem(
      id: json['id'],
      title: json['title'],
      image: json['allow3rdParty'] == 1
          ? thirdParty['fileId'] ?? " "
          : json['image'],
      url: json['url'],
      description: json['description'],
      imageUrl: imageUrl,
// json['allow3rdParty'] == 1 ? thirdParty['image'] : json['imageUrl'],
      allow3rdParty: json['allow3rdParty'] == 1 ? true : false,
      androidId: json['allow3rdParty'] == 1
          ? thirdParty != null
              ? thirdParty['android_id']
              : ""
          : "",
      documentId: json['document_id'].toString(),

      moduleType: json["document_type"] != null || json["document_type"] != ""
          ? json["document_type"] == "pdf"
              ? "pdf"
              : json["document_type"] == "video"
                  ? "video"
                  : json["document_type"] == "weblink" &&
                          json["url"] != null &&
                          json["url"] != ""
                      ? "weblink"
                      : "module"
          : "",
      iosId: json['allow3rdParty'] == 1
          ? thirdParty != null
              ? thirdParty['ios_id']
              : ""
          : "",
      windowsId: json['allow3rdParty'] == 1
          ? thirdParty != null
              ? thirdParty['windows_id']
              : ""
          : "",
      // buttonColor: json['color'] ?? KioskColorPallet.kBackground,
      isSensitive: json["isSensitive"] != null
          ? json["isSensitive"] == 0
              ? false
              : true
          : false,
      sensitiveScreenTimeOut: json["sensitiveScreenTimeout"] != null
          ? json["sensitiveScreenTimeout"] : null,
      sensitiveAlertTimeOut: json["sensitiveAlertTimeout"] != null
          ? json["sensitiveAlertTimeout"] : null,
      showQR: json["enableQR"] == 1 ? true : false,
      buttonColor:
      json['color'] == null || json['color'] == "" || json['color'] == " "
          ? Colors.white
          : ColorData.parseColor(json['color']),
      textColor: json['textColor'] == null ||
          json['textColor'] == "" ||
          json['textColor'] == " "
          ? Colors.black
          : ColorData.parseColor(json['textColor']),
    );

    subModule.imageUrl = await getImageUrl(subModule.image);
    return subModule;
  }

  @override
  String toString() {
    return 'SubModuleItem{id: $id, title: $title, image: $image, url: $url, description: $description, imageUrl: $imageUrl, iosId: $iosId, moduleType: $moduleType, androidId: $androidId, windowsId: $windowsId, allow3rdParty: $allow3rdParty, buttonColor: $buttonColor, isSensitive: $isSensitive, sensitiveScreenTimeOut: $sensitiveScreenTimeOut, showQR: $showQR, textColor: $textColor, documentId: $documentId}';
  }

// static List<SubModuleItem> fromJsonList(List<dynamic> jsonList) {
//   return jsonList.map((json) => SubModuleItem.fromJson(json)).toList();
// }
}
