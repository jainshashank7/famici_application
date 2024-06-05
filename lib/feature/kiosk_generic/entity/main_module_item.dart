import 'dart:ui';

import 'package:debug_logger/debug_logger.dart';

import '../../../core/blocs/theme_builder_bloc/theme_builder_bloc.dart';
import '../../../utils/config/color_pallet.dart';

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

  MainModuleItem(
      {required this.id,
      required this.title,
      required this.image,
      required this.url,
      required this.imageUrl,
      required this.type,
      required this.color,
      required this.position,
      required this.textColor});

  factory MainModuleItem.fromJson(Map<String, dynamic> json, String type) {
    return MainModuleItem(
        id: json['id'],
        title: json['title'],
        image: json['image'],
        url: json['url'],
        imageUrl: json['imageUrl'],
        type: type,
        position: int.parse(json['position']),
        color:
            json['color'] == null || json['color'] == "" || json['color'] == " "
                ? ColorPallet.kPrimary
                : ColorData.parseColor(json['color']),
        textColor: json['textColor'] == null ||
                json['textColor'] == "" ||
                json['textColor'] == " "
            ? ColorPallet.kSecondary
            : ColorData.parseColor(json['textColor']));
  }

  static List<MainModuleItem> fromJsonList(
      List<dynamic> jsonList, String type) {
    return jsonList.map((json) => MainModuleItem.fromJson(json, type)).toList();
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
      'textColor': textColor
    };
  }
}
