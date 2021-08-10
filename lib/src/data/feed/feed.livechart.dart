import 'dart:convert';

import 'feed.interface.dart';

class LivechartFeedItem extends FeedItem {
  LivechartFeedItem({
    this.title = '',
    this.permalink = '',
    this.createdAt,
    this.updatedAt,
  });

  final String title;
  final String permalink;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  int get utcTimestampSeconds => (updatedAt?.toUtc().millisecondsSinceEpoch ?? 0) ~/ 1000;
  String get sourceImage => 'assets/news-icons/livechart.png';

  LivechartFeedItem copyWith({
    String? title,
    String? permalink,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      LivechartFeedItem(
        title: title ?? this.title,
        permalink: permalink ?? this.permalink,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory LivechartFeedItem.fromRawJson(String str) => LivechartFeedItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LivechartFeedItem.fromJson(Map<String, dynamic> json) => LivechartFeedItem(
        title: json["title"] ?? '',
        permalink: json["permalink"] ?? '',
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "permalink": permalink,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
