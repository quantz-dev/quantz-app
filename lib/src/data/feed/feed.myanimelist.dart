import 'dart:convert';

import 'feed.interface.dart';

class MyAnimeListFeedItem extends FeedItem{
  MyAnimeListFeedItem({
    this.malId = 0,
    this.title = '',
    this.createdAt,
    this.updatedAt,
  });

  final int malId;
  final String title;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  String get permalink => 'https://myanimelist.net/news/$malId';
  int get utcTimestampSeconds => (updatedAt?.toUtc().millisecondsSinceEpoch ?? 0) ~/ 1000;
  String get sourceImage => 'assets/news-icons/mal.png';

  MyAnimeListFeedItem copyWith({
    int? malId,
    String? title,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      MyAnimeListFeedItem(
        malId: malId ?? this.malId,
        title: title ?? this.title,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory MyAnimeListFeedItem.fromRawJson(String str) => MyAnimeListFeedItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MyAnimeListFeedItem.fromJson(Map<String, dynamic> json) => MyAnimeListFeedItem(
        malId: json["mal_id"] ?? 0,
        title: json["title"] ?? '',
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "mal_id": malId,
        "title": title,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
