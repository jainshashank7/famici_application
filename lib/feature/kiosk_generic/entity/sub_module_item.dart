import 'dart:convert';

class SubModuleItem {
  int id;
  String title;
  String image;
  String url;
  String description;
  String imageUrl;
  String iosId;
  String androidId;
  bool allow3rdParty;
  bool isSensitive;

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
      this.isSensitive = false});

  factory SubModuleItem.fromJson(Map<String, dynamic> json) {
    // json['allow3rdParty'] = false;
    // if (json['id'] == 75) {
    //   json['thirdPartyValue'] = {
    //     "active": 1,
    //     "android_id": "us.zoom.videomeetings",
    //     "deleted": 0,
    //     "file_id": "",
    //     "function_name": "",
    //     "function_type": "",
    //     "height": "",
    //     "width": "",
    //     "image": "",
    //     "ios_id": "",
    //     "id": "56"
    //   };
    //   json['allow3rdParty'] = true;
    // }

    print("hiii json " + json.toString());
    var thirdParty = json['thirdPartyValue'] != null
        ? jsonDecode(json['thirdPartyValue'])
        : null;
    print("hiii json part 2 " + thirdParty.toString());
    return SubModuleItem(
      id: json['id'],
      title: json['title'],
      image: json['allow3rdParty'] == 1
          ? thirdParty['fileId'] ?? " "
          : json['image'],
      url: json['url'],
      description: json['description'],
      imageUrl:
          json['allow3rdParty'] == 1 ? thirdParty['image'] : json['imageUrl'],
      allow3rdParty: json['allow3rdParty'] == 1 ? true : false,
      androidId: json['allow3rdParty'] == 1
          ? thirdParty != null
              ? thirdParty['android_id']
              : ""
          : "",
      iosId: json['allow3rdParty'] == 1
          ? thirdParty != null
              ? thirdParty['ios_id']
              : ""
          : "",
      isSensitive: (json['isSensitive'].runtimeType == int) ? ((json['isSensitive'] == 1) ? true: false) : (json['isSensitive'] ? true: false),
    );
  }

  static List<SubModuleItem> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => SubModuleItem.fromJson(json)).toList();
  }
}
