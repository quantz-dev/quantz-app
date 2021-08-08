import 'dart:convert';

import 'package:momentum/momentum.dart';

import '../../data/index.dart';
import '../../services/index.dart';
import '../animelist/index.dart';
import 'index.dart';

class ImportController extends MomentumController<ImportModel> {
  @override
  ImportModel init() {
    return ImportModel(
      this,
      loading: false,
      malList: [],
      toFollow: [],
      toUnfollow: [],
      malUsername: '',
      syncSub: true,
      syncDub: false,
      statProgress: 0,
      statToImport: 0,
    );
  }

  Future<void> loadMalList(String username) async {
    if (username.isEmpty) {
      return;
    }
    model.update(malList: []);

    await _fetchUserAnimeList(username, 'airing', 'watching', 1);
    await _fetchUserAnimeList(username, 'airing', 'plantowatch', 1);
    await _fetchUserAnimeList(username, 'not_yet_aired', 'plantowatch', 1);

    _setupSync();
  }

  Future<void> _fetchUserAnimeList(
    String username,
    String airingStatus,
    String type,
    int page,
  ) async {
    print([username, airingStatus, type, page]);
    model.update(loading: true);
    var api = service<ApiService>();
    var malList = List<int>.from(model.malList);
    var response = await api.getUserAnimeList(
      username: username,
      type: type,
      airingStatus: airingStatus,
      page: page,
    );
    if (response.anime.isNotEmpty) {
      var items = response.anime;
      malList.addAll(items.map((e) => e.malId));
      model.update(malList: malList.toSet().toList());
      await _fetchUserAnimeList(username, airingStatus, type, page + 1);
    }
  }

  void _setupSync() async {
    var malIDs = model.malList;
    var animeListModel = controller<AnimelistController>().model;
    var sourceList = animeListModel.list;
    var subscriptions = animeListModel.subscriptions;

    var toFollow = <AnimeEntry>[];
    var toUnfollow = <AnimeEntry>[];

    for (var i = 0; i < sourceList.length; i++) {
      var item = sourceList[i];
      var subcribed = subscriptions[item.slug] ?? false;

      var syncSub = item.type == 'sub' && model.syncSub;
      var syncDub = item.type == 'dub' && model.syncDub;
      final match = (int id) => id == item.malId;

      if (syncSub || syncDub) {
        var _toFollow = malIDs.any(match) && !subcribed;
        if (_toFollow) {
          toFollow.add(item);
        }

        var _toUnfollow = !malIDs.any(match) && subcribed;
        if (_toUnfollow) {
          toUnfollow.add(item);
        }
      }
    }

    model.update(toFollow: toFollow, toUnfollow: toUnfollow);
    await _followFromMalList();
  }

  Future<void> _followFromMalList() async {
    var animeListCtrl = controller<AnimelistController>();

    if (model.toFollow.isNotEmpty) {
      model.update(statToImport: model.toFollow.length, statProgress: 0);
      for (var i = 0; i < model.toFollow.length; i++) {
        await animeListCtrl.toggleTopic(model.toFollow[i], status: true, inform: false);
        model.update(statProgress: i + 1);
      }
    }

    if (model.toUnfollow.isNotEmpty) {
      model.update(statToImport: model.toUnfollow.length, statProgress: 0);
      for (var i = 0; i < model.toUnfollow.length; i++) {
        await animeListCtrl.toggleTopic(model.toUnfollow[i], status: false, inform: false);
        model.update(statProgress: i + 1);
      }
    }

    model.update(
      loading: false,
      toFollow: [],
      toUnfollow: [],
      statProgress: 0,
      statToImport: 0,
    );

    sendEvent(ImportEvents.done);
    animeListCtrl.flagEntries();
    animeListCtrl.arrangeList();
    animeListCtrl.separateList();
  }

  void restoreFromBackup(String source) {
    var json = jsonDecode(source);
    var backup = model.fromJson(json);
    if (backup != null) {
      model.update(malUsername: backup.malUsername);
    }
  }
}
