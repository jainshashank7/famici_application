// ignore_for_file: public_member_api_docs, sort_constructors_first

class SubModuleLink {
  int id;
  String title;
  String url;
  String? documentId;
  String? moduleType;
  bool isSensitive;
  int? sensitiveScreenTimeOut;
  int? sensitiveAlertTimeOut;

  SubModuleLink(
      {required this.id,
      required this.title,
      required this.url,
      this.documentId,
      this.moduleType,
      this.isSensitive = false,
       this.sensitiveScreenTimeOut,
       this.sensitiveAlertTimeOut,
      });

  factory SubModuleLink.fromJson(Map<String, dynamic> json) {
    print("SubModuleLink :: $json");
    return SubModuleLink(
        id: json['id'],
        title: json['title'],
        url: json['url'],
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
        isSensitive: (json['isSensitive'].runtimeType == int)
            ? ((json['isSensitive'] == 1) ? true : false)
            : (json['isSensitive'] ? true : false),
        sensitiveScreenTimeOut: json['sensitiveScreenTimeout'] != null ? json['sensitiveScreenTimeout'] : null,
        sensitiveAlertTimeOut: json['sensitiveAlertTimeout'] != null ? json['sensitiveAlertTimeout'] : null,
    );
  }

  static List<SubModuleLink> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => SubModuleLink.fromJson(json)).toList();
  }

  @override
  String toString() => 'SubModuleLink(id: $id, title: $title, url: $url)';
}
