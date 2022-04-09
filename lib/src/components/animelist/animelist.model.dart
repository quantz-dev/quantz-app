import 'dart:convert';

import 'package:momentum/momentum.dart';

import '../../data/index.dart';
import 'index.dart';

class AnimelistModel extends MomentumModel<AnimelistController> {
  AnimelistModel(
    AnimelistController controller, {
    required this.list,
    required this.following,
    required this.subList,
    required this.dubList,
    // required this.loadingList,
    required this.refreshingList,
    required this.loadingUserAnimeDetails,
    required this.subscriptions,
    required this.searchMode,
    required this.searchResults,
    required this.searchQuery,
  }) : super(controller);

  final List<AnimeEntry> list;
  final List<AnimeEntry> following;
  final List<AnimeEntry> subList;
  final List<AnimeEntry> dubList;
  // final bool loadingList;
  final bool refreshingList;
  final bool loadingUserAnimeDetails;

  final Map<String, bool> subscriptions;

  final bool searchMode;
  final List<AnimeEntry> searchResults;
  final String searchQuery;

  @override
  void update({
    List<AnimeEntry>? list,
    List<AnimeEntry>? following,
    List<AnimeEntry>? subList,
    List<AnimeEntry>? dubList,
    // bool? loadingList,
    bool? refreshingList,
    bool? loadingUserAnimeDetails,
    Map<String, bool>? subscriptions,
    bool? searchMode,
    List<AnimeEntry>? searchResults,
    String? searchQuery,
  }) {
    AnimelistModel(
      controller,
      list: list ?? this.list,
      following: following ?? this.following,
      subList: subList ?? this.subList,
      dubList: dubList ?? this.dubList,
      // loadingList: loadingList ?? this.loadingList,
      refreshingList: refreshingList ?? this.refreshingList,
      loadingUserAnimeDetails:
          loadingUserAnimeDetails ?? this.loadingUserAnimeDetails,
      subscriptions: subscriptions ?? this.subscriptions,
      searchMode: searchMode ?? this.searchMode,
      searchResults: searchResults ?? this.searchResults,
      searchQuery: searchQuery ?? this.searchQuery,
    ).updateMomentum();
  }

  Map<String, dynamic> toBackup() => {'subscriptions': subscriptions};

  AnimelistModel getRestoreData(String source) => _fromMap(json.decode(source));

  AnimelistModel _fromMap(Map<String, dynamic> map) {
    return AnimelistModel(
      controller,
      list: [],
      following: [],
      subList: [],
      dubList: [],
      // loadingList: false,
      refreshingList: false,
      loadingUserAnimeDetails: false,
      subscriptions: Map<String, bool>.from(map['subscriptions']),
      searchMode: false,
      searchResults: [],
      searchQuery: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "list": list.map((e) => e.toJson()).toList(),
      "following": following.map((e) => e.toJson()).toList(),
      "subList": subList.map((e) => e.toJson()).toList(),
      "dubList": dubList.map((e) => e.toJson()).toList(),
      "loadingList": false,
      "refreshingList": false,
      "loadingUserAnimeDetails": false,
      "subscriptions": subscriptions,
      "searchMode": false,
      "searchResults": [],
      "searchQuery": '',
    };
  }

  AnimelistModel? fromJson(Map<String, dynamic>? map) {
    if (map == null) return null;
    return AnimelistModel(
      controller,
      list: (map['list'] as List).map((e) => AnimeEntry.fromJson(e)).toList(),
      following: (map['following'] as List).map((e) => AnimeEntry.fromJson(e)).toList(),
      subList: (map['subList'] as List).map((e) => AnimeEntry.fromJson(e)).toList(),
      dubList: (map['dubList'] as List).map((e) => AnimeEntry.fromJson(e)).toList(),
      // loadingList: false,
      refreshingList: false,
      loadingUserAnimeDetails: false,
      subscriptions: Map<String, bool>.from(map['subscriptions']),
      searchMode: false,
      searchResults: [],
      searchQuery: '',
    );
  }
}
