import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'mal-user.animeupdate.dart';

class MalUserAnimeListResponse {
  MalUserAnimeListResponse({
    this.data = const [],
    this.paging = const Paging(),
  });

  final List<MalUserAnimeItem> data;
  final Paging paging;

  MalUserAnimeListResponse copyWith({
    List<MalUserAnimeItem>? data,
    Paging? paging,
  }) =>
      MalUserAnimeListResponse(
        data: data ?? this.data,
        paging: paging ?? this.paging,
      );

  factory MalUserAnimeListResponse.fromRawJson(String str) => MalUserAnimeListResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MalUserAnimeListResponse.fromJson(Map<String, dynamic> json) => MalUserAnimeListResponse(
        data: List<MalUserAnimeItem>.from(json["data"]?.map((x) => MalUserAnimeItem.fromJson(x)) ?? []),
        paging: json["paging"] == null ? Paging() : Paging.fromJson(json["paging"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "paging": paging.toJson(),
      };
}

class MalUserAnimeItem extends Equatable {
  MalUserAnimeItem({
    this.node = const MalUserAnimeNode(),
    this.listStatus = const MalUserAnimeListStatus(),
  });

  final MalUserAnimeNode node;
  final MalUserAnimeListStatus listStatus;

  MalUserAnimeItem copyWith({
    MalUserAnimeNode? node,
    MalUserAnimeListStatus? listStatus,
  }) =>
      MalUserAnimeItem(
        node: node ?? this.node,
        listStatus: listStatus ?? this.listStatus,
      );

  factory MalUserAnimeItem.fromRawJson(String str) => MalUserAnimeItem.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MalUserAnimeItem.fromJson(Map<String, dynamic> json) => MalUserAnimeItem(
        node: json["node"] == null ? MalUserAnimeNode() : MalUserAnimeNode.fromJson(json["node"]),
        listStatus: json["list_status"] == null ? MalUserAnimeListStatus() : MalUserAnimeListStatus.fromJson(json["list_status"]),
      );

  Map<String, dynamic> toJson() => {
        "node": node.toJson(),
        "list_status": listStatus.toJson(),
      };

  @override
  List<Object> get props => [node.id];
}

class MalUserAnimeListStatus {
  const MalUserAnimeListStatus({
    this.status = '',
    this.score = 0,
    this.numEpisodesWatched = 0,
    this.isRewatching = false,
    this.updatedAt,
    this.startDate = '',
    this.finishDate = '',
  });

  factory MalUserAnimeListStatus.fromUpdate(MalUserAnimeUpdate updated) {
    return MalUserAnimeListStatus(
      status: updated.status,
      score: updated.score,
      numEpisodesWatched: updated.numEpisodesWatched,
      isRewatching: updated.isRewatching,
      updatedAt: updated.updatedAt,
      startDate: updated.startDate,
      finishDate: updated.finishDate,
    );
  }

  final String status;
  final int score;
  final int numEpisodesWatched;
  final bool isRewatching;
  final DateTime? updatedAt;
  final String startDate;
  final String finishDate;

  MalUserAnimeListStatus copyWith({
    String? status,
    int? score,
    int? numEpisodesWatched,
    bool? isRewatching,
    DateTime? updatedAt,
    String? startDate,
    String? finishDate,
  }) =>
      MalUserAnimeListStatus(
        status: status ?? this.status,
        score: score ?? this.score,
        numEpisodesWatched: numEpisodesWatched ?? this.numEpisodesWatched,
        isRewatching: isRewatching ?? this.isRewatching,
        updatedAt: updatedAt ?? this.updatedAt,
        startDate: startDate ?? this.startDate,
        finishDate: finishDate ?? this.finishDate,
      );

  factory MalUserAnimeListStatus.fromRawJson(String str) => MalUserAnimeListStatus.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MalUserAnimeListStatus.fromJson(Map<String, dynamic> json) => MalUserAnimeListStatus(
        status: json["status"] ?? '',
        score: json["score"] ?? 0,
        numEpisodesWatched: json["num_episodes_watched"] ?? 0,
        isRewatching: json["is_rewatching"] ?? false,
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        startDate: json["start_date"] == null ? '' : json["start_date"],
        finishDate: json["finish_date"] == null ? '' : json["finish_date"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "score": score,
        "num_episodes_watched": numEpisodesWatched,
        "is_rewatching": isRewatching,
        "updated_at": updatedAt?.toIso8601String(),
        "start_date": startDate,
        "finish_date": finishDate,
      };
}

class MalUserAnimeNode {
  const MalUserAnimeNode({
    this.id = 0,
    this.title = '',
    this.mainPicture = const MainPicture(),
    this.numEpisodes = 0,
    this.status = '',
  });

  final int id;
  final String title;
  final MainPicture mainPicture;
  final int numEpisodes;
  final String status;

  MalUserAnimeNode copyWith({
    int? id,
    String? title,
    MainPicture? mainPicture,
    int? numEpisodes,
    String? status,
  }) =>
      MalUserAnimeNode(
        id: id ?? this.id,
        title: title ?? this.title,
        mainPicture: mainPicture ?? this.mainPicture,
        numEpisodes: numEpisodes ?? this.numEpisodes,
        status: status ?? this.status,
      );

  factory MalUserAnimeNode.fromRawJson(String str) => MalUserAnimeNode.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MalUserAnimeNode.fromJson(Map<String, dynamic> json) => MalUserAnimeNode(
        id: json["id"] ?? 0,
        title: json["title"] ?? '',
        mainPicture: json["main_picture"] == null ? MainPicture() : MainPicture.fromJson(json["main_picture"]),
        numEpisodes: json["num_episodes"] ?? 0,
        status: json["status"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "main_picture": mainPicture.toJson(),
        "num_episodes": numEpisodes,
        "status": status,
      };
}

class MainPicture {
  const MainPicture({
    this.medium = '',
    this.large = '',
  });

  final String medium;
  final String large;

  MainPicture copyWith({
    String? medium,
    String? large,
  }) =>
      MainPicture(
        medium: medium ?? this.medium,
        large: large ?? this.large,
      );

  factory MainPicture.fromRawJson(String str) => MainPicture.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MainPicture.fromJson(Map<String, dynamic> json) => MainPicture(
        medium: json["medium"] ?? '',
        large: json["large"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "medium": medium,
        "large": large,
      };
}

class Paging {
  const Paging({
    this.next = '',
  });

  final String next;

  Paging copyWith({
    String? next,
  }) =>
      Paging(
        next: next ?? this.next,
      );

  factory Paging.fromRawJson(String str) => Paging.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Paging.fromJson(Map<String, dynamic> json) => Paging(
        next: json["next"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "next": next,
      };
}

class MalUserAnimeDetails {
  MalUserAnimeDetails({
    this.id = 0,
    this.title = '',
    this.mainPicture = const MainPicture(),
    this.myListStatus = const MalUserAnimeListStatus(),
    this.numEpisodes = 0,
    this.status = '',
  });

  final int id;
  final String title;
  final MainPicture mainPicture;
  final MalUserAnimeListStatus myListStatus;
  final int numEpisodes;
  final String status;

  MalUserAnimeDetails copyWith({
    int? id,
    String? title,
    MainPicture? mainPicture,
    int? numEpisodes,
    String? status,
    MalUserAnimeListStatus? myListStatus,
  }) =>
      MalUserAnimeDetails(
        id: id ?? this.id,
        title: title ?? this.title,
        mainPicture: mainPicture ?? this.mainPicture,
        numEpisodes: numEpisodes ?? this.numEpisodes,
        status: status ?? this.status,
        myListStatus: myListStatus ?? this.myListStatus,
      );

  factory MalUserAnimeDetails.fromRawJson(String str) => MalUserAnimeDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MalUserAnimeDetails.fromJson(Map<String, dynamic> json) => MalUserAnimeDetails(
        id: json["id"] == null ? 0 : json["id"],
        title: json["title"] == null ? '' : json["title"],
        mainPicture: json["main_picture"] == null ? MainPicture() : MainPicture.fromJson(json["main_picture"]),
        numEpisodes: json["num_episodes"] ?? 0,
        status: json["status"] ?? '',
        myListStatus: json["my_list_status"] == null ? MalUserAnimeListStatus() : MalUserAnimeListStatus.fromJson(json["my_list_status"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "main_picture": mainPicture.toJson(),
        "num_episodes": numEpisodes,
        "status": status,
        "my_list_status": myListStatus.toJson(),
      };
}
