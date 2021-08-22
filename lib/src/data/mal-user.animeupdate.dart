import 'dart:convert';

class MalUserAnimeUpdate {
  MalUserAnimeUpdate({
    this.status = '',
    this.score = 0,
    this.numEpisodesWatched = 0,
    this.isRewatching = false,
    this.updatedAt,
    this.startDate = '',
    this.finishDate = '',
    this.priority = 0,
    this.numTimesRewatched = 0,
    this.rewatchValue = 0,
    this.tags = const [],
    this.comments = '',
  });

  final String status;
  final int score;
  final int numEpisodesWatched;
  final bool isRewatching;
  final DateTime? updatedAt;
  final String startDate;
  final String finishDate;
  final int priority;
  final int numTimesRewatched;
  final int rewatchValue;
  final List<dynamic> tags;
  final String comments;

  MalUserAnimeUpdate copyWith({
    String? status,
    int? score,
    int? numEpisodesWatched,
    bool? isRewatching,
    DateTime? updatedAt,
    String? startDate,
    String? finishDate,
    int? priority,
    int? numTimesRewatched,
    int? rewatchValue,
    List<dynamic>? tags,
    String? comments,
  }) =>
      MalUserAnimeUpdate(
        status: status ?? this.status,
        score: score ?? this.score,
        numEpisodesWatched: numEpisodesWatched ?? this.numEpisodesWatched,
        isRewatching: isRewatching ?? this.isRewatching,
        updatedAt: updatedAt ?? this.updatedAt,
        startDate: startDate ?? this.startDate,
        finishDate: finishDate ?? this.finishDate,
        priority: priority ?? this.priority,
        numTimesRewatched: numTimesRewatched ?? this.numTimesRewatched,
        rewatchValue: rewatchValue ?? this.rewatchValue,
        tags: tags ?? this.tags,
        comments: comments ?? this.comments,
      );

  factory MalUserAnimeUpdate.fromRawJson(String str) => MalUserAnimeUpdate.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MalUserAnimeUpdate.fromJson(Map<String, dynamic> json) => MalUserAnimeUpdate(
        status: json["status"] == null ? '' : json["status"],
        score: json["score"] == null ? 0 : json["score"],
        numEpisodesWatched: json["num_episodes_watched"] == null ? 0 : json["num_episodes_watched"],
        isRewatching: json["is_rewatching"] == null ? false : json["is_rewatching"],
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        startDate: json["start_date"] == null ? '' : json["start_date"],
        finishDate: json["finish_date"] == null ? '' : json["finish_date"],
        priority: json["priority"] == null ? 0 : json["priority"],
        numTimesRewatched: json["num_times_rewatched"] == null ? 0 : json["num_times_rewatched"],
        rewatchValue: json["rewatch_value"] == null ? 0 : json["rewatch_value"],
        tags: json["tags"] == null ? [] : List<dynamic>.from(json["tags"].map((x) => x)),
        comments: json["comments"] == null ? '' : json["comments"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "score": score,
        "num_episodes_watched": numEpisodesWatched,
        "is_rewatching": isRewatching,
        "updated_at": updatedAt == null ? null : updatedAt?.toIso8601String(),
        "start_date": startDate,
        "finish_date": finishDate,
        "priority": priority,
        "num_times_rewatched": numTimesRewatched,
        "rewatch_value": rewatchValue,
        "tags": List<dynamic>.from(tags.map((x) => x)),
        "comments": comments,
      };
}
