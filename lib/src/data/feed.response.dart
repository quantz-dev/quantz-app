import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../misc/feed-icons.dart';

class QuantzFeed {
  QuantzFeed({
    this.page = 0,
    this.count = 0,
    this.items = const [],
  });

  final int page;
  final int count;
  final List<QuantzFeedItem> items;

  QuantzFeed copyWith({
    int? page,
    int? count,
    List<QuantzFeedItem>? items,
  }) =>
      QuantzFeed(
        page: page ?? this.page,
        count: count ?? this.count,
        items: items ?? this.items,
      );

  factory QuantzFeed.fromRawJson(String str) => QuantzFeed.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory QuantzFeed.fromJson(Map<String, dynamic> json) => QuantzFeed(
        page: json["page"] == null ? 0 : json["page"],
        count: json["count"] == null ? 0 : json["count"],
        items: json["feed"] == null ? [] : List<QuantzFeedItem>.from(json["feed"].map((x) => QuantzFeedItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "count": count,
        "feed": items.map((x) => x.toJson()).toList(),
      };
}

class QuantzFeedItem extends Equatable {
  QuantzFeedItem({
    this.title = '',
    this.permalink = '',
    this.utcTimestampSeconds = 0,
    this.provider = '',
    this.sourceDomain = '',
  });

  final String title;
  final String permalink;
  final int utcTimestampSeconds;
  final String provider;
  final String sourceDomain;

  /// For UI to indicate when did the news got detected by Quantz.
  String get ago => timeago.format(DateTime.fromMillisecondsSinceEpoch(utcTimestampSeconds * 1000));
  String get sourceImage => feedIconsMap[provider] ?? '';
  int get tooltipDuration => title.length * 70; // 100ms per character

  QuantzFeedItem copyWith({
    String? title,
    String? permalink,
    int? utcTimestampSeconds,
    String? provider,
    String? sourceDomain,
  }) =>
      QuantzFeedItem(
        title: title ?? this.title,
        permalink: permalink ?? this.permalink,
        utcTimestampSeconds: utcTimestampSeconds ?? this.utcTimestampSeconds,
        provider: provider ?? this.provider,
        sourceDomain: sourceDomain ?? this.sourceDomain,
      );

  factory QuantzFeedItem.fromRawJson(String str) => QuantzFeedItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory QuantzFeedItem.fromJson(Map<String, dynamic> json) => QuantzFeedItem(
        title: json["title"] == null ? '' : json["title"],
        permalink: json["permalink"] == null ? '' : json["permalink"],
        utcTimestampSeconds: json["utcTimestampSeconds"] == null ? 0 : json["utcTimestampSeconds"],
        provider: json["provider"] == null ? '' : json["provider"],
        sourceDomain: json["sourceDomain"] == null ? '' : json["sourceDomain"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "permalink": permalink,
        "utcTimestampSeconds": utcTimestampSeconds,
        "provider": provider,
        "sourceDomain": sourceDomain,
      };

  List<Object?> get props => [
        title,
        permalink,
        utcTimestampSeconds,
        provider,
        sourceDomain,
      ];
}
