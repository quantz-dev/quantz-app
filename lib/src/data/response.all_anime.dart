import 'dart:convert';

import 'mal-user.animelist.dart';

class AnimeListResponse {
  AnimeListResponse({
    this.count = 0,
    this.entries = const [],
  });

  final int count;
  final List<AnimeEntry> entries;

  AnimeListResponse copyWith({
    int? count,
    List<AnimeEntry>? list,
  }) =>
      AnimeListResponse(
        count: count ?? this.count,
        entries: list ?? this.entries,
      );

  factory AnimeListResponse.fromRawJson(String str) => AnimeListResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AnimeListResponse.fromJson(Map<String, dynamic> json) => AnimeListResponse(
        count: json["count"] == null ? 0 : json["count"],
        entries: json["list"] == null ? [] : List<AnimeEntry>.from(json["list"].map((x) => AnimeEntry.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "list": List<dynamic>.from(entries.map((x) => x.toJson())),
      };
}

class AnimeEntry {
  AnimeEntry({
    this.slug = '',
    this.title = '',
    this.thumbnailUrl = '',
    this.type = '',
    this.alternativeTitles = '',
    this.status = '',
    this.latestEpisode = 0,
    this.latestEpisodeTimestamp = 0,
    this.malId = -1,
    this.malTitleEnglish = '',
    this.malTitleJapanese = '',
    this.malScore = 0,
    this.malScoredByUsers = 0,
    this.malTotalUsers = 0,
    this.malFavorites = 0,
    this.season = '',
    this.livechartId = -1,
    this.markedForDeletion = false,
    this.displayTitle = '',
    this.orderLabel = '',
    this.following = false,
    this.episodeTime = '',
    this.malStatus,
  });

  final String slug;
  final String title;
  final String thumbnailUrl;
  final String type;
  final String alternativeTitles;
  final String status;
  final num latestEpisode;
  final int latestEpisodeTimestamp;
  final int malId;
  final String malTitleEnglish;
  final String malTitleJapanese;
  final double malScore;
  final int malScoredByUsers;
  final int malTotalUsers;
  final int malFavorites;
  final String season;
  final int livechartId;
  final bool markedForDeletion;

  /* These props here are not part of JSON response. They're for UI */
  final String displayTitle;
  final String orderLabel;
  final bool following;
  final String episodeTime; // Something like `an hour ago` or `3 days ago`.
  final MalUserAnimeListStatus? malStatus; // watching progress of the user (MAL Integration only)
  /* These props here are not part of JSON response. They're for UI */

  bool get hasMAL => malId > 0;
  bool get isSub => type == 'sub';
  bool get hasEpisode => latestEpisode > 0;
  bool get hasEpisodeSchedule => latestEpisodeTimestamp > 0;

  double get favePercent => (malFavorites / malTotalUsers) * 100;

  /// Use this for sorting only.
  int get episodeTimestamp => latestEpisodeTimestamp == 0 ? -1 : latestEpisodeTimestamp;

  bool get isOngoing => status == 'Ongoing' || markedForDeletion;

  AnimeEntry copyWith({
    String? slug,
    String? title,
    String? thumbnailUrl,
    String? type,
    String? alternativeTitles,
    String? status,
    int? latestEpisode,
    int? latestEpisodeTimestamp,
    int? malId,
    String? malTitleEnglish,
    String? malTitleJapanese,
    double? malScore,
    int? malScoredByUsers,
    int? malTotalUsers,
    int? malFavorites,
    String? season,
    int? livechartId,
    bool? markedForDeletion,
    String? displayTitle,
    String? orderLabel,
    bool? following,
    String? episodeTime,
    MalUserAnimeListStatus? malStatus,
  }) =>
      AnimeEntry(
        slug: slug ?? this.slug,
        title: title ?? this.title,
        thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
        type: type ?? this.type,
        alternativeTitles: alternativeTitles ?? this.alternativeTitles,
        status: status ?? this.status,
        latestEpisode: latestEpisode ?? this.latestEpisode,
        latestEpisodeTimestamp: latestEpisodeTimestamp ?? this.latestEpisodeTimestamp,
        malId: malId ?? this.malId,
        malTitleEnglish: malTitleEnglish ?? this.malTitleEnglish,
        malTitleJapanese: malTitleJapanese ?? this.malTitleJapanese,
        malScore: malScore ?? this.malScore,
        malScoredByUsers: malScoredByUsers ?? this.malScoredByUsers,
        malTotalUsers: malTotalUsers ?? this.malTotalUsers,
        malFavorites: malFavorites ?? this.malFavorites,
        season: season ?? this.season,
        livechartId: livechartId ?? this.livechartId,
        displayTitle: displayTitle ?? this.displayTitle,
        orderLabel: orderLabel ?? this.orderLabel,
        following: following ?? this.following,
        episodeTime: episodeTime ?? this.episodeTime,
        malStatus: malStatus ?? this.malStatus,
      );

  factory AnimeEntry.fromRawJson(String str) => AnimeEntry.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AnimeEntry.fromJson(Map<String, dynamic> json) => AnimeEntry(
        slug: json["slug"] == null ? '' : json["slug"],
        title: json["title"] == null ? '' : json["title"],
        thumbnailUrl: json["thumbnail_url"] == null ? '' : json["thumbnail_url"],
        type: json["type"] == null ? '' : json["type"],
        alternativeTitles: json["alternative_titles"] == null ? '' : json["alternative_titles"],
        status: json["status"] == null ? '' : json["status"],
        latestEpisode: json["latest_episode"] == null ? 0 : json["latest_episode"],
        latestEpisodeTimestamp: json["latest_episode_timestamp"] == null ? 0 : json["latest_episode_timestamp"],
        malId: json["mal_id"] == null ? -1 : json["mal_id"],
        malTitleEnglish: json["mal_title_english"] == null ? '' : json["mal_title_english"],
        malTitleJapanese: json["mal_title_japanese"] == null ? '' : json["mal_title_japanese"],
        malScore: json["mal_score"] == null ? 0 : json["mal_score"].toDouble(),
        malScoredByUsers: json["mal_scored_by_users"] == null ? 0 : json["mal_scored_by_users"],
        malTotalUsers: json["mal_total_users"] == null ? 0 : json["mal_total_users"],
        malFavorites: json["mal_favorites"] == null ? 0 : json["mal_favorites"],
        season: json["season"] == null ? '' : json["season"],
        livechartId: json["livechart_id"] == null ? -1 : json["livechart_id"],
        markedForDeletion: json["marked_for_deletion"] == null ? false : json["marked_for_deletion"],
      );

  Map<String, dynamic> toJson() => {
        "slug": slug,
        "title": title,
        "thumbnail_url": thumbnailUrl,
        "type": type,
        "alternative_titles": alternativeTitles,
        "status": status,
        "latest_episode": latestEpisode,
        "latest_episode_timestamp": latestEpisodeTimestamp,
        "mal_id": malId,
        "mal_title_english": malTitleEnglish,
        "mal_title_japanese": malTitleJapanese,
        "mal_score": malScore,
        "mal_scored_by_users": malScoredByUsers,
        "mal_total_users": malTotalUsers,
        "mal_favorites": malFavorites,
        "season": season,
        "livechart_id": livechartId,
        "marked_for_deletion": markedForDeletion,
      };
}
