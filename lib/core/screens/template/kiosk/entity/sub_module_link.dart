// import 'package:debug_logger/debug_logger.dart';
//
// class SubModuleLink {
//   int id;
//   String title;
//   String url;
//   bool isSensitive;
//   bool showQr;
//
//   SubModuleLink(
//       {required this.id,
//         required this.title,
//         required this.url,
//         required this.isSensitive,
//       required this.showQr});
//
//   factory SubModuleLink.fromJson(Map<String, dynamic> json) {
//     print("SUBMODULEKINKS");
//     DebugLogger.debug(json);
//     return SubModuleLink(
//       id: json['id'],
//       title: json['title'],
//       url: json['url'],
//       isSensitive: json["isSensitive"] != null
//           ? json["isSensitive"] == 0
//           ? false
//           : true
//           : false,
//       showQr: json["enableQR"] == 1 ?true : false,
//
//     );
//   }
//
//   static List<SubModuleLink> fromJsonList(List<dynamic> jsonList) {
//     return jsonList.map((json) => SubModuleLink.fromJson(json)).toList();
//   }
// }