import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:momentum/momentum.dart';

import '../../misc/index.dart';
import 'index.dart';

class SourcesController extends MomentumController<SourcesModel> {
  @override
  SourcesModel init() {
    return SourcesModel(
      this,
      initialized: false,
      loading: false,
      sourcesSubscriptionList: sourcesList,
    );
  }

  String get persistenceKey => SOURCES_STATE_KEY;

  FirebaseMessaging? _messaging;
  FirebaseMessaging get messaging => _messaging!;

  @override
  void onReady() async {
    _messaging = FirebaseMessaging.instance;
    if (!model.initialized) {
      model.update(loading: true);
      await toggleNews(model.sourcesSubscriptionList[0], true);
      model.update(loading: false, initialized: true);
    }
    syncNewsSources();
  }

  void syncNewsSources() {
    var list = List<NewsSource>.from(model.sourcesSubscriptionList);
    for (var i = 0; i < sourcesList.length; i++) {
      var exist = list.any((x) => x.name == sourcesList[i].name);
      if (!exist) {
        list.insert(i, sourcesList[i]);
      } else {
        var current = list.firstWhere((x) => x.name == sourcesList[i].name);
        list.replaceRange(i, i + 1, [sourcesList[i].copyWith(following: current.following)]);
      }
    }
    model.update(sourcesSubscriptionList: list);
  }

  Future<void> toggleNews(NewsSource source, bool state) async {
    model.update(loading: true);
    try {
      var list = List<NewsSource>.from(model.sourcesSubscriptionList);
      var updated = source.copyWith(following: state);
      var index = list.indexWhere((x) => x.firebaseTopic == source.firebaseTopic);
      if (state) {
        await messaging.subscribeToTopic(source.firebaseTopic);
      } else {
        await messaging.unsubscribeFromTopic(source.firebaseTopic);
      }
      list.removeAt(index);
      list.insert(index, updated);
      model.update(sourcesSubscriptionList: list);
    } catch (e) {
      print(e);
    }
    model.update(loading: false);
  }

  Future<void> restoreFromBackup(String source) async {
    var json = jsonDecode(source);
    var backup = model.fromJson(json);
    final sources = backup?.sourcesSubscriptionList ?? [];
    for (var item in sources) {
      await toggleNews(item, item.following);
    }
  }
}
