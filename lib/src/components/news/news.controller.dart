import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:momentum/momentum.dart';

import '../../misc/index.dart';
import 'index.dart';

class NewsController extends MomentumController<NewsModel> {
  @override
  NewsModel init() {
    return NewsModel(
      this,
      initialized: false,
      loading: false,
      newsSubscriptionList: newsSourceList,
    );
  }

  String get persistenceKey => NEWS_STATE_KEY;

  FirebaseMessaging? _messaging;
  FirebaseMessaging get messaging => _messaging!;

  @override
  void onReady() async {
    _messaging = FirebaseMessaging.instance;
    if (!model.initialized) {
      model.update(loading: true);
      await toggleNews(model.newsSubscriptionList[0], true);
      model.update(loading: false, initialized: true);
    }
    syncNewsSources();
  }

  void syncNewsSources() {
    var list = List<NewsSource>.from(model.newsSubscriptionList);
    for (var i = 0; i < newsSourceList.length; i++) {
      var exist = list.any((x) => x.name == newsSourceList[i].name);
      if (!exist) {
        list.insert(i, newsSourceList[i]);
      } else {
        var current = list.firstWhere((x) => x.name == newsSourceList[i].name);
        list.replaceRange(i, i + 1, [newsSourceList[i].copyWith(following: current.following)]);
      }
    }
    model.update(newsSubscriptionList: list);
  }

  Future<void> toggleNews(NewsSource source, bool state) async {
    model.update(loading: true);
    try {
      var list = List<NewsSource>.from(model.newsSubscriptionList);
      var updated = source.copyWith(following: state);
      var index = list.indexWhere((x) => x.firebaseTopic == source.firebaseTopic);
      if (state) {
        await messaging.subscribeToTopic(source.firebaseTopic);
      } else {
        await messaging.unsubscribeFromTopic(source.firebaseTopic);
      }
      list.removeAt(index);
      list.insert(index, updated);
      model.update(newsSubscriptionList: list);
    } catch (e) {
      print(e);
    }
    model.update(loading: false);
  }

  Future<void> restoreFromBackup(String source) async {
    var json = jsonDecode(source);
    var backup = model.fromJson(json);
    final news = backup?.newsSubscriptionList ?? [];
    for (var item in news) {
      await toggleNews(item, item.following);
    }
  }
}
