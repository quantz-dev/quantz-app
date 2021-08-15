import 'dart:convert';

import 'feed.interface.dart';

class RAnimeFeedItem extends FeedItem {
  RAnimeFeedItem({
    this.title = '',
    this.rlink = '',
    this.createdUtc = 0,
  });

  final String title;
  final String rlink;
  final int createdUtc;

  String get permalink => 'https://www.reddit.com$rlink';
  int get utcTimestampSeconds => createdUtc;
  String get sourceImage => 'assets/sources-icons/reddit.png';

  RAnimeFeedItem copyWith({
    String? title,
    String? permalink,
    int? createdUtc,
  }) =>
      RAnimeFeedItem(
        title: title ?? this.title,
        rlink: permalink ?? this.rlink,
        createdUtc: createdUtc ?? this.createdUtc,
      );

  factory RAnimeFeedItem.fromRawJson(String str) => RAnimeFeedItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RAnimeFeedItem.fromJson(Map<String, dynamic> json) => RAnimeFeedItem(
        title: json["title"] ?? '',
        rlink: json["permalink"] ?? '',
        createdUtc: json["created_utc"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "permalink": rlink,
        "created_utc": createdUtc,
      };
}
