part of 'theme_builder_bloc.dart';

class ThemeBuilderState extends Equatable {
  const ThemeBuilderState({
    required this.themeData,
    required this.dashboardBuilder,
    required this.templateId,
    required this.hasCareAssistant,
    required this.status,
  });

  final ThemeData themeData;
  final ApiData dashboardBuilder;
  final int templateId;
  final Status status;
  final bool hasCareAssistant;

  // final int memberProfileId;
  // final String profileName;
  // final String ageGroup;
  // final bool active;
  @override
  String toString() {
    return 'ThemeBuilderState( themeData: $themeData, dashboardBuilder: $dashboardBuilder)';
  }

  factory ThemeBuilderState.initial() {
    return ThemeBuilderState(
        // memberProfileId: 0,
        // profileName: '',
        // ageGroup: '',
        // active: false,
        status: Status.initial,
        templateId: 0,
        dashboardBuilder: ApiData(
          li: DashboardSectionData(
            items: {
              "LI 3": DashboardItem(
                  id: "1",
                  name: "Scheduling",
                  height: 120,
                  width: 220,
                  type: "core",
                  fileId: ''),
              "LI 4": DashboardItem(
                  id: "1",
                  name: "Care Team",
                  height: 120,
                  width: 220,
                  type: "core",
                  fileId: ''),
              "LI 5": DashboardItem(
                  id: "1",
                  name: "Vitals",
                  height: 120,
                  width: 220,
                  type: "core",
                  fileId: ''),
              "LI 6": DashboardItem(
                  id: "1",
                  name: "Medication",
                  height: 120,
                  width: 220,
                  type: "core",
                  fileId: '')
            },
          ),
          gsi: DashboardSectionData(
            items: {
              "GSI 1": DashboardItem(
                  id: "1",
                  name: "Content & Education",
                  height: 120,
                  width: 220,
                  type: "core",
                  fileId: ''),
              "GSI 2": DashboardItem(
                  id: "1",
                  name: "Let's Connect",
                  height: 120,
                  width: 220,
                  type: "core",
                  fileId: ''),
              "GSI 3": DashboardItem(
                  id: "1",
                  name: "Photos",
                  height: 120,
                  width: 220,
                  type: "core",
                  fileId: ''),
              "GSI 4": DashboardItem(
                  id: "1",
                  name: "Entertainment",
                  height: 120,
                  width: 220,
                  type: "core",
                  fileId: ''),
              "GSI 6": DashboardItem(
                  id: "1",
                  name: "Web Links",
                  height: 120,
                  width: 220,
                  type: "core",
                  fileId: ''),
            },
          ),
        ),
        themeData: ThemeData(
            colors: ColorData(
                primary: Color(0xFF595BC4),
                primaryText: Colors.white,
                secondary: Color(0xFFAC2734),
                secondaryText: Colors.white,
                tertiary: Color(0xFF4CBC9A),
                tertiaryText: Colors.white),
            background: '',
            logo: ''),
        hasCareAssistant: false);
  }

  factory ThemeBuilderState.fromJson(
      Map<String, dynamic> json, int templateT, int templateId, Status status) {
    return ThemeBuilderState(
      status: status,
      templateId: templateId,
      hasCareAssistant: false,
      themeData: ThemeData.fromJson(json['page3']),
      dashboardBuilder: ApiData.fromJson(json['page4'], templateT),
    );
  }

  ThemeBuilderState copyWith({
    ThemeData? functionList,
    ApiData? coreApps,
    int? templateId,
    bool? hasCareAssistant,
    Status? status,
  }) {
    return ThemeBuilderState(
        // memberProfileId: memberProfileId ?? this.memberProfileId,
        // profileName: profileName ?? this.profileName,
        // ageGroup: ageGroup ?? this.ageGroup,
        // active: active ?? this.active,
        status: status ?? this.status,
        hasCareAssistant: hasCareAssistant ?? this.hasCareAssistant,
        templateId: templateId ?? this.templateId,
        themeData: functionList ?? this.themeData,
        dashboardBuilder: coreApps ?? this.dashboardBuilder);
  }

  @override
  List<Object?> get props => [
        hasCareAssistant,
        templateId,
        themeData,
        dashboardBuilder,
        status,
      ];
}

class ApiResponse {
  final ThemeData themeData;
  final ApiData dashboardBuilder;

  ApiResponse({
    required this.themeData,
    required this.dashboardBuilder,
  });

  String toString() {
    return 'ApiResponse(themeData: $themeData, dashboardBuilder: $dashboardBuilder)';
  }

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      themeData: ThemeData.fromJson(json['themeData']),
      dashboardBuilder: ApiData.fromJson(json['dashboardBuilder'], 1),
    );
  }
}

class ThemeData {
  final ColorData colors;
  late String background;
  final String logo;

  ThemeData({
    required this.colors,
    required this.background,
    required this.logo,
  });

  @override
  String toString() {
    return 'ThemeData(colors: $colors, background: $background, logo: $logo)';
  }

  factory ThemeData.fromJson(Map<String, dynamic> json) {
    return ThemeData(
      colors: ColorData.fromJson(json['colorScheme']),
      background: json['background']['file_id'],
      logo: json['logo']['image'],
    );
  }
}

class ColorData {
  final Color primary;
  final Color secondary;
  final Color tertiary;
  final Color primaryText;
  final Color secondaryText;
  final Color tertiaryText;

  ColorData(
      {required this.primary,
      required this.secondary,
      required this.tertiary,
      required this.primaryText,
      required this.secondaryText,
      required this.tertiaryText});

  factory ColorData.fromJson(Map<String, dynamic> json) {
    DebugLogger.debug("JOsn For Colors: $json");
    return ColorData(
      primary: parseColor(json['colors'][0][0]),
      primaryText: parseColor(json['colors'][0][1]),
      secondary: parseColor(json['colors'][1][0]),
      secondaryText: parseColor(json['colors'][1][1]),
      tertiary: parseColor(json['colors'][2][0]),
      tertiaryText: parseColor(json['colors'][2][1]),
    );
  }

  //#000
  //#0432234
  static Color parseColor(String hexColor) {
    if (hexColor.length == 4) {
      var m =
          Color(int.parse(hexColor.substring(1, 4), radix: 16) + 0xFF000000);
      return m;
    } else {
      // [#2271B1, #EBEFF4, #EBEFF4]
      var m =
          Color(int.parse(hexColor.substring(1, 7), radix: 16) + 0xFF000000);
      return m;
    }
  }

  @override
  String toString() {
    return 'ColorData(primary: $primary, secondary: $secondary, tertiary: $tertiary, primaryText: $primaryText, secondaryText: $secondaryText, tertiaryText: $tertiaryText)';
  }
}

class ApiData {
  final DashboardSectionData li;
  final DashboardSectionData gsi;

  ApiData({required this.li, required this.gsi});

  String toString() {
    return 'ApiData(li: $li, gsi: $gsi)';
  }

  factory ApiData.fromJson(Map<String, dynamic> json, int templateT) {
    final dashboardBuilderJson = json as Map<String, dynamic>? ?? {};
    print("hey this is GSI $json");
    return ApiData(
      li: DashboardSectionData.fromJson(
          dashboardBuilderJson['templateData']['LI'] as Map<String, dynamic>? ??
              {},
          {},
          false,
          templateT),
      gsi: DashboardSectionData.fromJson(
          dashboardBuilderJson['template']['GSI'] as Map<String, dynamic>? ??
              {},
          dashboardBuilderJson['templateData']['GSI']
                  as Map<String, dynamic>? ??
              {},
          true,
          templateT),
    );
  }
}

class DashboardSectionData {
  final Map<String, DashboardItem?> items;

  DashboardSectionData({required this.items});

  @override
  String toString() {
    return 'DashboardSectionData(items: $items)';
  }

  factory DashboardSectionData.fromJson(Map<String, dynamic> json,
      Map<String, dynamic> tempJson, bool isGSI, int templateT) {
    log("hi this is josn gsi jsonnnn " + json.toString());
    if (isGSI) {
      final Map<String, dynamic>? sectionJson = json;
      // if (true) {
      final Map<String, DashboardItem?> items = sectionJson?.map((key, value) {
            log("Json Key value pair::: ${json["sensitiveScreenTimeout"]}");
            log("Value[elements]::: gsi  ${value['elements']}");
            log("hi this is josn gsi jsonnnn gsi$value");
            if (!(value['elements'] as List<dynamic>).isEmpty) {
              DebugLogger.debug(
                  "Value[elements]::: gsi1111  ${value['title']} ${value['elements'][0]['sensitiveScreenTimeout']} ${value['elements'][0]['sensitiveAlertTimeout']}");
              value['elements'][0]['title'] = value['title'] ?? "";
              value['elements'][0]['link'] = value['url'] ?? "";
              value['elements'][0]['color'] = value['color'] ?? "";
              value['elements'][0]['textColor'] = value['textColor'] ?? "";
              value['elements'][0]['isSensitive'] = value['isSensitive'] ?? "";

              //To be addressed it's a by issue from the backend value['elements'][0]['sensitiveScreenTimeout'] should be value['sensitiveScreenTimeout']
              value['elements'][0]['sensitiveScreenTimeout'] =
                  value['elements'][0]['sensitiveScreenTimeout'] ?? 30;
              value['elements'][0]['sensitiveAlertTimeout'] =
                  value['elements'][0]['sensitiveAlertTimeout'] ?? 15;

              value['elements'][0]['document_id'] =
                  tempJson[value['name']]['document_id'].toString() ?? "";

              // print("error " +
              //     " value['elements'][0]['title'] = value['title'];");
              value = value['elements'][0];
              // print("error " + "value = value['elements'][0];");
            } else {
              value = null;
            }

            // print("hi this is josn gsi jsonnnn m" + value.toString());
            if ((value) != null) {
              final DashboardItem dashboardItem =
                  DashboardItem.fromJson(value as Map<String, dynamic>, isGSI);
              // print("hi this is josn gsi jsonnnn t sfdsd" + dashboardItem.name);
              return MapEntry(key, dashboardItem);
            } else {
              return MapEntry(key, null);
            }
          }) ??
          {};

      return DashboardSectionData(items: items);
      // }
      // else if (templateT == 2) {
      //   final Map<String, DashboardItem?> items = sectionJson
      //           ?.map((key, value) {
      //         log("hi this is josn gsi jsonnnn j" + value.toString());
      //         if (!(value['elements'] as List<dynamic>).isEmpty) {
      //           // print("checking the title mhh2 "+ value['elements'][0]['function_name'] + value['elements'].toString());
      //           value['elements'][0]['title'] =
      //               value['elements'][0]['function_name'] ?? "";
      //           value['elements'][0]['link'] = value['url'] ?? "";
      //           value['elements'][0]['color'] = value['color'] ?? "";
      //           value['elements'][0]['textColor'] = value['textColor'] ?? "";
      //           // value['elements'][0]['function_type'] = "generic";
      //
      //           print("error " +
      //               " value['elements'][0]['title'] = value['title'];");
      //           value = value['elements'][0];
      //           print("error " + "value = value['elements'][0];");
      //         } else {
      //           value = null;
      //         }
      //
      //         print("hi this is josn gsi jsonnnn m" + value.toString());
      //         if ((value) != null) {
      //           final DashboardItem dashboardItem = DashboardItem.fromJson(
      //               value as Map<String, dynamic>, isGSI);
      //           print(
      //               "hi this is josn gsi jsonnnn t sfdsd" + dashboardItem.name);
      //           return MapEntry(key, dashboardItem);
      //         } else {
      //           return MapEntry(key, null);
      //         }
      //       }) ??
      //       {};
      //
      //   // print("sdfkjslf sldkjf lskjf ljkf ");
      //   // items.forEach((key, value) {
      //   //   print(value?.name);
      //   // });
      //
      //   return DashboardSectionData(items: items);
      // }
      return DashboardSectionData(items: {});
    } else {
      final Map<String, dynamic>? sectionJson = json;
      log("JSON DATATATA :::: ${json.toString()}");
      final Map<String, DashboardItem?> items = sectionJson?.map((key, value) {
            print("key value");
            print(key);
            print(value);
            log("liitem $key $value");
            if (value != null) {
              final DashboardItem dashboardItem =
                  DashboardItem.fromJson(value as Map<String, dynamic>, isGSI);
              return MapEntry(key, dashboardItem);
            } else {
              return MapEntry(key, null);
            }
          }) ??
          {};
      return DashboardSectionData(items: items);
    }
  }
}

class DashboardItem {
  final String id;
  final String name;
  final double height;
  final double width;
  final String? androidId;
  final String? iosId;
  final String? type;
  final String? link;
  final bool isSensitive;
  final int? sensitiveScreenTimeOut;
  final int? sensitiveAlertTimeOut;
  final String? documentId;
  String? phoneNumber;
  String? dtmsEnabled;
  String? dtmsSettings;
  final bool isAudioEnabled;

  String? image;
  final String? fileId;
  Color? color;
  Color? textColor;

  DashboardItem(
      {required this.id,
      required this.name,
      required this.height,
      required this.width,
      required this.fileId,
      this.link,
      this.androidId,
      this.iosId,
      this.type,
      this.image,
      this.color,
      this.textColor,
      this.documentId,
      this.isSensitive = false,
      this.isAudioEnabled = true,
      this.sensitiveScreenTimeOut,
      this.sensitiveAlertTimeOut,
      this.phoneNumber,
      this.dtmsEnabled,
      this.dtmsSettings});

  factory DashboardItem.fromJson(Map<String, dynamic> json, bool isGSI) {
    // print("$isGSI  hi this is json mhh 2 $json");
    int? id;
    try {
      if (json['function_type'] == "generic") {
        log("this is json ${json}");
      }

      if (json['function_name'] == "Dashboard") {
        id = json['dashboard_id'];

        // print("this is sthe image  ${json['image']}");

        return DashboardItem(
            id: id.toString() ?? "",
            name: "Dashboard",
            height: 0,
            width: 0,
            fileId: json['image_id'],
            link: json['title']);
      }
    } catch (err) {
      print(err);
    }
    bool isSens = false;
    if (json['function_type'] == 'generic') {
      if (json['isSensitive'] == null) {
        isSens = false;
      } else if (json['isSensitive'].runtimeType == int) {
        if (json['isSensitive'] == 1) {
          isSens = true;
        }
      } else if (json['isSensitive'].runtimeType == bool) {
        isSens = json['isSensitive'];
      }
    }

    log("DASHBORAD ITEM ::::: ${json}");
    print(
        "reason for ${json['isSensitive'].runtimeType} ${json['isSensitive']}");
    // if(json['function_name'] == "Call Button") {
    //   log("DASHBORAD ITEM dtms::::: ${json['enabledtms']}");
    // }
    return DashboardItem(
      id: json['id'].toString() ?? '',
      name: json['function_type'] == "generic"
          ? json['title'] as String? ?? ""
          : json['function_name'] as String? ?? "",
      height: 0,
      width: 0,
      androidId: json['android_id'] as String?,
      link: json['link'] ?? json['url'] ?? "",
      iosId: json['ios_id'] as String?,
      type: json['function_type'] == "generic"
          ? json['function_name'] == "Video Link"
              ? "video"
              : json['function_name'] == "Dashboard Page"
                  ? "module"
                  : json['function_name'] == "PDF Link"
                      ? "pdf"
                      : json['function_name'] == "Web Link"
                          ? "link"
                          : json['function_name'] == "Mood Tracker"
                              ? "Mood Tracker"
                              : json['function_name'] == "Education"
                                  ? "Education"
                                  : json['function_type'] as String?
          : json['function_type'] as String?,
      documentId: json['document_id'].toString() ?? "",
      image: json['image'] as String? ?? '',
      color: json['function_type'] == "generic"
          ? json['color'] != "" && json['color'] != null
              ? ColorData.parseColor(json['color'])
              : null
          : null,
      textColor: json['function_type'] == "generic"
          ? json['textColor'] != "" && json['textColor'] != null
              ? ColorData.parseColor(json['textColor'])
              : null
          : null,
      fileId: json['function_type'] == "generic"
          ? json['image_id'] as String? ?? ''
          : json['fileId'] as String? ?? '',
      isSensitive: isSens,
      sensitiveScreenTimeOut: (json['function_type'] == 'generic')
          ? json['sensitiveScreenTimeout']
          : null,
      sensitiveAlertTimeOut: (json['function_type'] == 'generic')
          ? json['sensitiveAlertTimeout']
          : null,
      phoneNumber:
          json['function_name'] == "Call Button" ? json['phoneNumber'] : "",
      dtmsEnabled: json['function_name'] == "Call Button"
          ? json['enabledtms'] == 1
              ? "true"
              : "false"
          : "false",
      dtmsSettings: json['function_name'] == "Call Button"
          ? json['dtmsSettings'] ?? ""
          : "",
      isAudioEnabled: json['isAudioEnabled'] == null
          ? false
          : (json['isAudioEnabled'].runtimeType == int &&
                  json['isAudioEnabled'] == 1)
              ? true
              : json['isAudioEnabled'].runtimeType == bool
                  ? json['isAudioEnabled']
                  : false,
    );
  }

  @override
  String toString() {
    return 'DashboardItem{id: $id, name: $name, height: $height, width: $width, androidId: $androidId, iosId: $iosId, type: $type, isSensitive: $isSensitive, sensitiveScreenTimeOut: $sensitiveScreenTimeOut, sensitiveAlertTimeOut: $sensitiveAlertTimeOut, documentId: $documentId, phoneNumber: $phoneNumber, dtmsEnabled: $dtmsEnabled, dtmsSettings: $dtmsSettings, image: $image, fileId: $fileId, color: $color, textColor: $textColor ,link: $link,}';
  }
}
