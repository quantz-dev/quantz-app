import 'package:momentum/momentum.dart';

import '../../data/index.dart';
import '../../data/mal-user.animelist.dart';
import '../../services/interface/mal.interface.dart';
import '../animelist/index.dart';
import 'index.dart';

class IntegrationController extends MomentumController<IntegrationModel> {
  @override
  IntegrationModel init() {
    return IntegrationModel(
      this,
      loading: false,
      malList: [],
      toFollow: [],
      toUnfollow: [],
      malUsername: '',
      syncSub: true,
      syncDub: false,
      malUserAnimeListCache: [],
      statProgress: 0,
      statToImport: 0,
    );
  }

  MalInterface? _mal;
  MalInterface get mal {
    if (_mal == null) {
      _mal = service<MalInterface>(runtimeType: false);
    }
    return _mal!;
  }

  void onReady() {
    mal.onLoggedIn((getToken) async {
      model.update(loading: true);
      await getToken();
      final profile = await mal.getUserProfile();
      model.update(loading: false, malUsername: profile.name);
    });
  }

  Future<String> getLoginUrl() async {
    model.update(loading: true);
    final result = await mal.getLoginUrl();
    if (result.isEmpty) {
      final profile = await mal.getUserProfile();
      model.update(malUsername: profile.name);
    }
    model.update(loading: false);
    return result;
  }

  Future<void> logout() async {
    await mal.logout();
    model.update(malUsername: '', malUserAnimeListCache: []);
    controller<AnimelistController>().softRefreshAnimeList();
  }

  Future<void> loadMalList() async {
    if (!mal.loggedIn) {
      return;
    }
    model.update(malList: []);
    await loadUserAnimeList();
    integrateUserAnimeList();
    _setupSync();
  }

  Future<void> loadUserAnimeList() async {
    await _fetchUserAnimeList('watching');
    await _fetchUserAnimeList('plan_to_watch');
    await _fetchUserAnimeList('on_hold');
  }

  void updateUserAnimeStatus(int malId, MalUserAnimeDetails details) {
    var malUserAnimeListCache = List<MalUserAnimeItem>.from(model.malUserAnimeListCache);
    final index = malUserAnimeListCache.indexWhere((x) => x.node.id == malId);
    if (index >= 0 && details.id > 0) {
      malUserAnimeListCache[index] = malUserAnimeListCache[index].copyWith(
        node: malUserAnimeListCache[index].node.copyWith(
              status: details.status,
              numEpisodes: details.numEpisodes,
            ),
        listStatus: details.myListStatus,
      );
    }
    model.update(malUserAnimeListCache: malUserAnimeListCache);
  }

  Future<void> _fetchUserAnimeList(String status, {String next = ''}) async {
    model.update(loading: true);
    var malList = List<int>.from(model.malList);
    var malUserAnimeListCache = List<MalUserAnimeItem>.from(model.malUserAnimeListCache);
    var offset = 0;
    if (next.isNotEmpty) {
      final uri = Uri.parse(next);
      final offsetParam = uri.queryParameters['offset'];
      if (offsetParam != null) {
        offset = int.parse(offsetParam);
      }
    }
    var response = await mal.getUserAnimeList(
      status: status,
      offset: offset,
    );
    if (response.data.isNotEmpty) {
      var items = response.data;
      malList.addAll(items.map((e) => e.node.id));
      malUserAnimeListCache.addAll(items);
      model.update(malList: malList.toSet().toList(), malUserAnimeListCache: malUserAnimeListCache.toSet().toList());
      final next = response.paging.next;
      if (next.isNotEmpty) {
        await _fetchUserAnimeList(status, next: response.paging.next);
      }
    }
  }

  void integrateUserAnimeList() {
    if (model.malUserAnimeListCache.isNotEmpty) {
      controller<AnimelistController>().softRefreshAnimeList();
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

    sendEvent(IntegrationEvents.done);
    animeListCtrl.flagEntries();
    animeListCtrl.arrangeList();
    animeListCtrl.separateList();
  }
}
