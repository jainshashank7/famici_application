import 'dart:convert';
import 'dart:developer';

import 'package:debug_logger/debug_logger.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart' as xml;

import '../../../../../repositories/auth_repository.dart';
import '../../../../../utils/config/api_config.dart';
import '../../../../../utils/config/api_key.dart';
import 'feed.dart';

AuthRepository _authRepository = AuthRepository();

Future<Map<String, dynamic>> fetchRssFeed(
    Map<String, dynamic> rssInfo, bool isExternalFeed) async {
  final rssFeedItems = <RssFeedItem>[];
  int totalUnReadFeeds = 0;

  // if (response.statusCode == 200) {
  final feedItems = rssInfo['feeditems'];
  final feedXml = xml.XmlDocument.parse(rssInfo['rss_content']);
  final items = feedXml.findAllElements('item');
  List<String> fileIds = [];
  int i = 0;
  for (final item in items) {
    final id = feedItems[i]['id'] ?? -1;
    final title = item.findElements('title').first.text ?? "";
    final description = item.findElements('description').first.text ?? "";
    final link = item.findElements('link').first.text ?? "";
    final image = isExternalFeed ? "" : item.findElements('image').first.text;
    final pubDate =
    isExternalFeed ? "" : item.findElements('pubDate').first.text;
    final fileId = isExternalFeed ? "" : item.findElements('fileId').first.text;
    final seenStatus = feedItems[i]['seen_status'];
    final publicationDate = feedItems[i]['publicationDate'];

    assert(id != -1);

    final rssItem = RssFeedItem(
        id: id,
        title: title,
        description: description,
        imageUrl: image,
        link: link,
        pubDate: pubDate,
        fileId: fileId,
        seenStatus: (seenStatus.runtimeType == int) ? (seenStatus == 1 ? true : false): seenStatus == "1" ? true: false,
        publicationDate: publicationDate.toString());

    if (!rssItem.seenStatus) totalUnReadFeeds++;

    // DebugLogger.info("Show the rss feed Item: ${rssItem.toString()}");

    if (!isExternalFeed && fileId != "") fileIds.add(fileId);
    rssFeedItems.add(rssItem);

    i++;
  }
  if (fileIds.isNotEmpty) {
    var imagesRes = await getImageUrls(fileIds);
    if (imagesRes.statusCode == 200) {
      var data = jsonDecode(imagesRes.body);
      List<dynamic> dataList = data['data'];

      rssFeedItems.asMap().forEach((key, value) {
        for (var item in dataList) {
          if(value.fileId == "") break;
          if (item['fileId'] == value.fileId) {
            value.imageUrl = item['image'];
            break;
          }
        }
      });
    } else {
      DebugLogger.error(
          'Failed to fetch RSS feed. Status code: ${imagesRes.statusCode}');
    }
  }
  // } else {
  //   print('Failed to fetch RSS feed. Status code: ${response.statusCode}');
  // }

  // for (var i in rssFeedItems) {
  //   print(i.toJson());
  // }
  // rssFeedItems.sort((a,b) => int.parse(b.pubDateTime).compareTo(int.parse(a.pubDateTime)));

  return {"totalUnReadFeeds": totalUnReadFeeds, "rssFeedItems": rssFeedItems};
}

Future<Response> getImageUrls(List<String> fileId) async {
  final prefs = await SharedPreferences.getInstance();
  String companyId = prefs.getString('companyId') ?? "";
  String clientId = prefs.getString('clientId') ?? "";
  String? accessToken = await _authRepository.generateAccessToken();
  print("clientID :::: ${clientId}");
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
  print("Inside getImageURls ${fileId}");
  // print("this is 3rdparty data file id " + fileId);
  var imageBody = json.encode({"fileIds": fileId});
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
        return responseImages;
      } else {
        // print("this is 3rdparty data no data  two ");
        return Response("", responseImages.statusCode);
      }
    } catch (e) {
      // print("this is 3rdparty data no data error " + e.toString());
      DebugLogger.error(e);
      return Response("", 400);
    }
  }

  return Response("", 400);
}

Future<String> fetchRssFeedTitle(String url) async {
  final feedXml = xml.XmlDocument.parse(url);
  final title = feedXml.findAllElements('title').first.text;
  return title;
}
