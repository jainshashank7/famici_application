import 'package:debug_logger/debug_logger.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'package:html/parser.dart' as html;

import 'feed.dart';

Future<List<RssFeedItem>> fetchRssFeed(String url) async {
  final response = await http.get(Uri.parse(url));
  final rssFeedItems = <RssFeedItem>[];

  if (response.statusCode == 200) {
    final feedXml = xml.XmlDocument.parse(response.body);
    final items = feedXml.findAllElements('item');

    for (final item in items) {
      final title = item.findElements('title').first.text;
      final description = item.findElements('description').first.text;
      final link = item.findElements('link').first.text;

      final descriptionHtml = html.parse(description);
      final imgElement = descriptionHtml.querySelector('image');
      String imageUrl =
          imgElement != null ? imgElement.attributes['src'] ?? '' : '';

      if (imageUrl == "") {
        try {
          final imageElement = item.findElements('image').first;
          imageUrl = imageElement.text;
        } catch (err) {
          DebugLogger.error(err);
        }
      }

      final rssItem = RssFeedItem(
        title: title,
        description: description,
        imageUrl: imageUrl,
        link: link,
      );
      rssFeedItems.add(rssItem);
    }
  } else {
    print('Failed to fetch RSS feed. Status code: ${response.statusCode}');
  }

  for (var i in rssFeedItems) {
    print(i.toJson());
  }

  return rssFeedItems;
}
