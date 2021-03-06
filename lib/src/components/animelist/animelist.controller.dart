import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:intl/intl.dart';
import 'package:momentum/momentum.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../data/index.dart';
import '../../data/mal-user.animelist.dart';
import '../../notification/index.dart';
import '../../services/interface/api.interface.dart';
import '../../services/interface/mal.interface.dart';
import '../../widgets/index.dart';
import '../filter/index.dart';
import '../integration/index.dart';
import '../topic/index.dart';
import 'index.dart';

class AnimelistController extends MomentumController<AnimelistModel> {
  @override
  AnimelistModel init() {
    return AnimelistModel(
      this,
      list: [],
      following: [],
      subList: [],
      dubList: [],
      // loadingList: false,
      refreshingList: false,
      loadingUserAnimeDetails: false,
      subscriptions: {},
      searchMode: false,
      searchResults: [],
      searchQuery: '',
    );
  }

  FirebaseMessaging? _messaging;
  FirebaseMessaging get messaging => _messaging!;

  TopicController get topicController => controller<TopicController>();
  MalInterface get mal => service<MalInterface>(runtimeType: false);

  @override
  void onReady() async {
    await waitForFirebaseInit();
    _messaging = FirebaseMessaging.instance;
  }

  bootstrap() async {
    loadList();
  }

  Future<void> loadList() async {
    model.update(refreshingList: true);
    await loadAnimeList();
    await loadSubscription();
    flagEntries();
    arrangeList();
    separateList();
    sendEvent(AnimelistEvent(model.following.length));
    model.update(refreshingList: false);
  }

  Future<void> refreshAnimeList() async {
    model.update(refreshingList: true);
    await loadAnimeList();
    await loadSubscription();
    model.update(refreshingList: false);
    flagEntries();
    arrangeList();
    separateList();
  }

  void softRefreshAnimeList() {
    flagEntries();
    arrangeList();
    separateList();
  }

  Future<void> getUserAnimeDetails(AnimeEntry anime) async {
    model.update(loadingUserAnimeDetails: true);
    if (anime.malId > 0) {
      final updated = await mal.getUserAnime(anime.malId);
      if (updated.id > 0) {
        controller<IntegrationController>().updateUserAnimeStatus(updated.id, updated);
        softRefreshAnimeList();
      }
    }
    model.update(loadingUserAnimeDetails: false);
  }

  AnimeEntry getAnimeItem(String slug) {
    try {
      return model.list.firstWhere((x) => x.slug == slug);
    } on Exception {
      return AnimeEntry();
    }
  }

  Future<MalUserAnimeListStatus?> updateUserAnimeDetails(AnimeEntry anime, int episodeWatched) async {
    model.update(loadingUserAnimeDetails: true);
    MalUserAnimeListStatus? status;
    final integrationController = controller<IntegrationController>();
    if (anime.malId > 0) {
      var numWatchedEpisodes = episodeWatched;
      String watchingStatus = 'watching';
      String? startDate;
      String? finishDate;

      if (numWatchedEpisodes <= 0) {
        watchingStatus = 'plan_to_watch';
        startDate = '';
        numWatchedEpisodes = 0;
      } else if (numWatchedEpisodes >= 1) {
        watchingStatus = 'watching';
        if (numWatchedEpisodes == 1) {
          startDate = DateFormat('y-MM-dd').format(DateTime.now());
        }
        final animeDetails = integrationController.model.malUserAnimeListCache.firstWhere(
          (x) => x.node.id == anime.malId,
          orElse: () => MalUserAnimeItem(),
        );
        if (animeDetails.node.id > 0) {
          final isLastEpisode = numWatchedEpisodes == animeDetails.node.numEpisodes;
          if (isLastEpisode) {
            finishDate = DateFormat('y-MM-dd').format(DateTime.now());
            if (animeDetails.node.status == 'finished_airing') {
              watchingStatus = 'completed';
            }
          }
        }
      }

      final updated = await mal.updateUserAnime(
        malId: anime.malId,
        numWatchedEpisodes: numWatchedEpisodes,
        status: watchingStatus,
        startDate: startDate,
        finishDate: finishDate,
      );
      if (updated.numEpisodesWatched == numWatchedEpisodes) {
        status = MalUserAnimeListStatus.fromUpdate(updated);
        final updatedDetails = await mal.getUserAnime(anime.malId);
        integrationController.updateUserAnimeStatus(anime.malId, updatedDetails);
        softRefreshAnimeList();
      }
    }
    model.update(loadingUserAnimeDetails: false);
    return status;
  }

  Future<void> loadAnimeList() async {
    var api = service<ApiInterface>(runtimeType: false);
    var result = await api.getAnimeList();
    if (result.entries.isNotEmpty) {
      model.update(list: result.entries);
    }
  }

  Future<void> loadSubscription() async {
    var firebaseTopicMap = (await topicController.loadSubscription()).topics;
    var subscriptions = Map<String, bool>.from(model.subscriptions);

    var firebaseTopics = firebaseTopicMap.keys.toList();
    for (var topic in firebaseTopics) {
      subscriptions[topic] = true;
    }

    model.update(subscriptions: subscriptions);
  }

  Future<void> restoreFromBackup(String data) async {
    final subscriptions = model.getRestoreData(data).subscriptions;
    var firebaseTopicMap = topicController.model.firebaseSubscription.topics;
    var firebaseTopics = firebaseTopicMap.keys.toList();
    var current = Map<String, bool>.from(model.subscriptions);
    await Future.forEach<String>(
      subscriptions.keys,
      (topic) async {
        try {
          final exists = firebaseTopics.any((x) => x == topic);
          final anime = model.list.firstWhere((x) => x.slug == topic, orElse: () => AnimeEntry());
          if (anime.slug.isNotEmpty) {
            if (!exists) {
              await toggleTopic(anime, status: true, inform: false);
            } else if (subscriptions[topic] != anime.following) {
              await toggleTopic(anime, status: (subscriptions[topic] ?? false), inform: false);
            }
          }
          current.putIfAbsent(topic, () => subscriptions[topic] ?? false);
        } catch (e) {
          print(e);
        }
      },
    );
    model.update(subscriptions: current);
    flagEntries();
    arrangeList();
    separateList();
  }

  Future<void> toggleTopic(
    AnimeEntry anime, {
    bool? status,
    bool inform = true,
    bool flagEntry = false,
  }) async {
    var original = Map<String, bool>.from(model.subscriptions);
    try {
      var topics = Map<String, bool>.from(model.subscriptions);
      var topic = anime.slug;
      toggleTopicLoading(topic);
      model.update();
      topics[topic] = status ?? !(topics[topic] ?? false);

      if (topics[topic]!) {
        await messaging.subscribeToTopic(topic);
        if (inform) showToast('Followed "${anime.displayTitle}"');
        print('Followed "$topic"');
      } else {
        await messaging.unsubscribeFromTopic(topic);
        if (inform) showToast('Unfollowed "${anime.displayTitle}"', error: true);
        print('Unfollowed "$topic"');
      }
      toggleTopicLoading(topic);
      model.update(subscriptions: topics);
      if (flagEntry) {
        flagEntries();
        arrangeList();
        separateList();
      }
    } catch (e, trace) {
      print([e, trace]);
      toggleTopicLoading(anime.slug);
      model.update(subscriptions: original);
    }
  }

  List<String> topicsLoading = [];

  void toggleTopicLoading(String topic) {
    if (isTopicLoading(topic)) {
      topicsLoading.remove(topic);
    } else {
      topicsLoading.add(topic);
    }
  }

  bool isTopicLoading(String topic) {
    return topicsLoading.any((element) => topic == element);
  }

  void syncFromMAL(AnimeEntry entry) async {}

  void search(String query) {
    final q = query.toLowerCase().trim();
    final searchResults = <AnimeEntry>[];
    for (var anime in model.list) {
      final def = anime.title.trim();
      final alt = anime.alternativeTitles.trim();
      final en = anime.malTitleEnglish.trim();
      final jp = anime.malTitleJapanese.trim();
      final t = '$def | $en | $jp | $alt'.toLowerCase();
      if (t.contains(q)) {
        searchResults.add(anime);
      }
    }
    model.update(searchResults: searchResults, searchQuery: query);
    separateList();
  }

  /// 1. This is for optimization purpose. The UI will no longer need to
  /// re-process the list when the user switch between tabs.
  /// 2. Only gets called when the user refresh the list (HTTP Request) or an
  ///  action like follow/unfollow.
  void separateList() {
    var following = _filterList('', true);
    var subList = _filterList('sub', false);
    var dubList = _filterList('dub', false);
    model.update(
      following: following,
      subList: subList,
      dubList: dubList,
    );
  }

  /// 1. Update each entry's `following` *(bool)* property so that it can be
  /// separated later in another method which will then be displayed
  /// properly in the UI.
  /// 2. Also update the fuzzy `episodeTime` string like *an hour ago*
  /// or *3 days ago*.
  /// 3. This is for optimization purpose. The UI will no longer need to
  /// re-process the list when the user switch between tabs.
  /// 4. Only gets called when the user refresh the list (HTTP Request) or an
  ///  action like follow/unfollow.
  void flagEntries() {
    final filter = controller<FilterController>().model;
    final import = controller<IntegrationController>().model;
    final malUserAnimeListCache = import.malUserAnimeListCache;
    final syncSub = import.syncSub;
    final syncDub = import.syncDub;
    var list = List<AnimeEntry>.from(model.list);
    for (var i = 0; i < list.length; i++) {
      final following = model.subscriptions[list[i].slug] ?? false;
      final malAnime = malUserAnimeListCache.firstWhere((x) => x.node.id == list[i].malId, orElse: () => MalUserAnimeItem());
      var showStatus = false;
      if (syncSub && list[i].type == 'sub') showStatus = true;
      if (syncDub && list[i].type == 'dub') showStatus = true;
      list[i] = list[i].copyWith(
        following: following,
        episodeTime: timeago.format(DateTime.fromMillisecondsSinceEpoch(list[i].latestEpisodeTimestamp)),
        displayTitle: getDisplayTitle(filter.displayTitle, list[i]),
        orderLabel: getOrderLabel(filter.orderBy, list[i]),
        malStatus: (malAnime.node.id > 0 && showStatus) ? malAnime.listStatus : MalUserAnimeListStatus(),
      );
    }
    model.update(list: list);
  }

  void arrangeList() {
    final compare = controller<FilterController>().compare;

    var list = List<AnimeEntry>.from(model.list);
    list.sort(compare);
    var searchResults = List<AnimeEntry>.from(model.searchResults);
    searchResults.sort(compare);

    model.update(list: list, searchResults: searchResults);
  }

  String getDisplayTitle(DisplayTitle type, AnimeEntry anime) {
    final def = anime.title;
    final en = anime.malTitleEnglish;
    final jp = anime.malTitleJapanese;
    switch (type) {
      case DisplayTitle.defaultTitle:
        return def;
      case DisplayTitle.english:
        return en.isEmpty ? def : en;
      case DisplayTitle.japanese:
        return jp.isEmpty ? def : jp;
    }
  }

  String getOrderLabel(OrderBy orderBy, AnimeEntry anime) {
    switch (orderBy) {
      case OrderBy.title:
        return '';
      case OrderBy.episodeCount:
        return '';
      case OrderBy.episodeRelease:
        return '';
      case OrderBy.popularity:
        return '${anime.malTotalUsers} users';
      case OrderBy.score:
        return '${anime.malScore}';
    }
  }

  List<AnimeEntry> _filterList(String type, [bool following = false]) {
    final source = model.searchQuery.isNotEmpty ? model.searchResults : model.list;
    var result = <AnimeEntry>[];
    for (var item in source) {
      if (item.type == type || following) {
        if (item.following == following) {
          result.add(item);
        }
      }
    }

    final filter = controller<FilterController>().model;

    final orderBy = filter.orderBy;
    if (orderBy == OrderBy.episodeRelease) {
      var withTimestamp = result.where((x) => x.hasEpisodeSchedule && x.isOngoing).toList();
      var withoutTimestamp = result.where((x) => !x.hasEpisodeSchedule && x.isOngoing).toList();
      var upcoming = result.where((x) => x.status == 'Upcoming').toList();
      result = withTimestamp
        ..addAll(withoutTimestamp)
        ..addAll(upcoming);
    }

    if (!filter.showOngoing) {
      result.removeWhere((x) => x.isOngoing);
    }
    if (!filter.showUpcoming) {
      result.removeWhere((x) => x.status == 'Upcoming');
    }

    return result;
  }
}
