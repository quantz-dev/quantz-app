import 'dart:convert';

class JikanUserAnimeList {
  JikanUserAnimeList({
    this.requestHash = '',
    this.requestCached = false,
    this.requestCacheExpiry = -1,
    required this.anime,
  });

  final String requestHash;
  final bool requestCached;
  final int requestCacheExpiry;
  final List<JikanAnime> anime;

  JikanUserAnimeList copyWith({
    String? requestHash,
    bool? requestCached,
    int? requestCacheExpiry,
    List<JikanAnime>? anime,
  }) =>
      JikanUserAnimeList(
        requestHash: requestHash ?? this.requestHash,
        requestCached: requestCached ?? this.requestCached,
        requestCacheExpiry: requestCacheExpiry ?? this.requestCacheExpiry,
        anime: anime ?? this.anime,
      );

  factory JikanUserAnimeList.fromRawJson(String str) => JikanUserAnimeList.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory JikanUserAnimeList.fromJson(Map<String, dynamic> json) => JikanUserAnimeList(
        requestHash: json["request_hash"] == null ? '' : json["request_hash"],
        requestCached: json["request_cached"] == null ? false : json["request_cached"],
        requestCacheExpiry: json["request_cache_expiry"] == null ? -1 : json["request_cache_expiry"],
        anime: json["anime"] == null ? [] : List<JikanAnime>.from(json["anime"].map((x) => JikanAnime.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "request_hash": requestHash,
        "request_cached": requestCached,
        "request_cache_expiry": requestCacheExpiry,
        "anime": List<dynamic>.from(anime.map((x) => x.toJson())),
      };
}

class JikanAnime {
  JikanAnime({
    this.malId = -1,
    this.title,
    this.videoUrl = '',
    this.url = '',
    this.imageUrl = '',
    this.type = '',
    this.watchingStatus = -1,
    this.score = 0,
    this.watchedEpisodes = 0,
    this.totalEpisodes = 0,
    this.airingStatus = 0,
    this.seasonName = '',
    this.seasonYear = 0,
    this.hasEpisodeVideo = false,
    this.hasPromoVideo = false,
    this.hasVideo = false,
    this.isRewatching = false,
    this.tags = '',
    this.rating = '',
    this.startDate,
    this.endDate,
    this.watchStartDate,
    this.watchEndDate,
    this.days = 0.0,
    this.storage = '',
    this.priority = '',
    this.addedToList = true,
    this.studios = const [],
    this.licensors = const [],
  });

  final int malId;
  final dynamic title;
  final String videoUrl;
  final String url;
  final String imageUrl;
  final String type;
  final int watchingStatus;
  final int score;
  final int watchedEpisodes;
  final int totalEpisodes;
  final int airingStatus;
  final String seasonName;
  final int seasonYear;
  final bool hasEpisodeVideo;
  final bool hasPromoVideo;
  final bool hasVideo;
  final bool isRewatching;
  final String tags;
  final String rating;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? watchStartDate;
  final DateTime? watchEndDate;
  final double days;
  final String storage;
  final String priority;
  final bool addedToList;
  final List<dynamic> studios;
  final List<dynamic> licensors;

  JikanAnime copyWith({
    int? malId,
    String? title,
    String? videoUrl,
    String? url,
    String? imageUrl,
    String? type,
    int? watchingStatus,
    int? score,
    int? watchedEpisodes,
    int? totalEpisodes,
    int? airingStatus,
    String? seasonName,
    int? seasonYear,
    bool? hasEpisodeVideo,
    bool? hasPromoVideo,
    bool? hasVideo,
    bool? isRewatching,
    String? tags,
    String? rating,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? watchStartDate,
    DateTime? watchEndDate,
    double? days,
    String? storage,
    String? priority,
    bool? addedToList,
    List<dynamic>? studios,
    List<dynamic>? licensors,
  }) =>
      JikanAnime(
        malId: malId ?? this.malId,
        title: title ?? this.title,
        videoUrl: videoUrl ?? this.videoUrl,
        url: url ?? this.url,
        imageUrl: imageUrl ?? this.imageUrl,
        type: type ?? this.type,
        watchingStatus: watchingStatus ?? this.watchingStatus,
        score: score ?? this.score,
        watchedEpisodes: watchedEpisodes ?? this.watchedEpisodes,
        totalEpisodes: totalEpisodes ?? this.totalEpisodes,
        airingStatus: airingStatus ?? this.airingStatus,
        seasonName: seasonName ?? this.seasonName,
        seasonYear: seasonYear ?? this.seasonYear,
        hasEpisodeVideo: hasEpisodeVideo ?? this.hasEpisodeVideo,
        hasPromoVideo: hasPromoVideo ?? this.hasPromoVideo,
        hasVideo: hasVideo ?? this.hasVideo,
        isRewatching: isRewatching ?? this.isRewatching,
        tags: tags ?? this.tags,
        rating: rating ?? this.rating,
        startDate: startDate ?? this.startDate,
        endDate: endDate ?? this.endDate,
        watchStartDate: watchStartDate ?? this.watchStartDate,
        watchEndDate: watchEndDate ?? this.watchEndDate,
        days: days ?? this.days,
        storage: storage ?? this.storage,
        priority: priority ?? this.priority,
        addedToList: addedToList ?? this.addedToList,
        studios: studios ?? this.studios,
        licensors: licensors ?? this.licensors,
      );

  factory JikanAnime.fromRawJson(String str) => JikanAnime.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory JikanAnime.fromJson(Map<String, dynamic> json) {
    try {
      return JikanAnime(
        malId: json["mal_id"] == null ? null : json["mal_id"],
        title: json["title"],
        videoUrl: json["video_url"] == null ? '' : json["video_url"],
        url: json["url"] == null ? '' : json["url"],
        imageUrl: json["image_url"] == null ? '' : json["image_url"],
        type: json["type"] == null ? '' : json["type"],
        watchingStatus: json["watching_status"] == null ? -1 : json["watching_status"],
        score: json["score"] == null ? 0 : json["score"],
        watchedEpisodes: json["watched_episodes"] == null ? 0 : json["watched_episodes"],
        totalEpisodes: json["total_episodes"] == null ? 0 : json["total_episodes"],
        airingStatus: json["airing_status"] == null ? 0 : json["airing_status"],
        seasonName: json["season_name"] == null ? '' : json["season_name"],
        seasonYear: json["season_year"] == null ? 0 : json["season_year"],
        hasEpisodeVideo: json["has_episode_video"] == null ? false : json["has_episode_video"],
        hasPromoVideo: json["has_promo_video"] == null ? false : json["has_promo_video"],
        hasVideo: json["has_video"] == null ? false : json["has_video"],
        isRewatching: json["is_rewatching"] == null ? false : json["is_rewatching"],
        tags: json["tags"] == null ? '' : json["tags"],
        rating: json["rating"] == null ? '' : json["rating"],
        startDate: json["start_date"] == null ? null : DateTime.parse(json["start_date"]),
        endDate: json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
        watchStartDate: json["watch_start_date"] == null ? null : DateTime.parse(json["watch_start_date"]),
        watchEndDate: json["watch_end_date"] == null ? null : DateTime.parse(json["watch_end_date"]),
        days: json["days"] == null ? 0.0 : json["days"].toDouble(),
        storage: json["storage"] == null ? '' : json["storage"],
        priority: json["priority"] == null ? '' : json["priority"],
        addedToList: json["added_to_list"] == null ? true : json["added_to_list"],
        studios: json["studios"] == null ? [] : List<dynamic>.from(json["studios"].map((x) => x)),
        licensors: json["licensors"] == null ? [] : List<dynamic>.from(json["licensors"].map((x) => x)),
      );
    } catch (e) {
      return JikanAnime();
    }
  }

  Map<String, dynamic> toJson() {
    try {
      return {
        "mal_id": malId,
        "title": title,
        "video_url": videoUrl,
        "url": url,
        "image_url": imageUrl,
        "type": type,
        "watching_status": watchingStatus,
        "score": score,
        "watched_episodes": watchedEpisodes,
        "total_episodes": totalEpisodes,
        "airing_status": airingStatus,
        "season_name": seasonName,
        "season_year": seasonYear,
        "has_episode_video": hasEpisodeVideo,
        "has_promo_video": hasPromoVideo,
        "has_video": hasVideo,
        "is_rewatching": isRewatching,
        "tags": tags,
        "rating": rating,
        "start_date": startDate == null ? null : startDate?.toIso8601String(),
        "end_date": endDate == null ? null : endDate?.toIso8601String(),
        "watch_start_date": watchStartDate == null ? null : watchStartDate?.toIso8601String(),
        "watch_end_date": watchEndDate == null ? null : watchEndDate?.toIso8601String(),
        "days": days,
        "storage": storage,
        "priority": priority,
        "added_to_list": addedToList,
        "studios": List<dynamic>.from(studios.map((x) => x)),
        "licensors": List<dynamic>.from(licensors.map((x) => x)),
      };
    } catch (e) {
      return {};
    }
  }
}
