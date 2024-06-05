class SubModuleInfo {
  List<SubModule> info;

  SubModuleInfo({
    required this.info,
  });

  factory SubModuleInfo.fromJson(Map<String, dynamic> json) {
    final List<dynamic> infoList = json['info'];
    final List<SubModule> infoItems = infoList.map((itemJson) {
      return SubModule.fromJson(itemJson);
    }).toList();

    return SubModuleInfo(info: infoItems);
  }
}

class SubModule {
  int id;
  String title;
  String image;
  String url;
  String description;
  String imageUrl;

  SubModule({
    required this.id,
    required this.title,
    required this.image,
    required this.url,
    required this.description,
    required this.imageUrl,
  });

  factory SubModule.fromJson(Map<String, dynamic> json) {
    return SubModule(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      url: json['url'],
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }
}
