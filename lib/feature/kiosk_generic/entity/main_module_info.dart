class MainModuleInfo {
  List<InfoItem> info;

  MainModuleInfo({
    required this.info,
  });

  factory MainModuleInfo.fromJson(Map<String, dynamic> json) {
    final List<dynamic> infoList = json['info'];
    final List<InfoItem> infoItems = infoList.map((itemJson) {
      return InfoItem.fromJson(itemJson);
    }).toList();

    return MainModuleInfo(info: infoItems);
  }
}

class InfoItem {
  int id;
  String title;
  String image;
  String url;
  String imageUrl;

  InfoItem({
    required this.id,
    required this.title,
    required this.image,
    required this.url,
    required this.imageUrl,
  });

  factory InfoItem.fromJson(Map<String, dynamic> json) {
    return InfoItem(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      url: json['url'],
      imageUrl: json['imageUrl'],
    );
  }
}
