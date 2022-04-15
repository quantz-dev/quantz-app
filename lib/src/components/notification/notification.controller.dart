import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:momentum/momentum.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../notification/index.dart';
import '../../services/index.dart';
import '../../widgets/index.dart';
import 'index.dart';

class NotificationController extends MomentumController<NotificationModel> {
  @override
  NotificationModel init() {
    return NotificationModel(
      this,
      loading: false,
      permalinks: [],
    );
  }

  FirebaseMessaging? _messaging;
  FirebaseMessaging get messaging => _messaging!;

  @override
  void onReady() async {
    await waitForFirebaseInit();
    _messaging = FirebaseMessaging.instance;
    var message = await _messaging!.getInitialMessage();
    if (message != null) {
      service<FcmService>().setMessage(message);
    }
    openNotification();
  }

  void markPermalinkAsVisited(String permalink) {
    var links = List<String>.from(model.permalinks);
    links.add(permalink); // mark the permalink as visited.
    links = links.toSet().toList();
    model.update(permalinks: links);
  }

  bool isVisited(String permalink) {
    return model.permalinks.any((x) => x == permalink);
  }

  /// Try to open permalink if there's a pending notification click result
  Future<void> openNotification() async {
    model.update(loading: true);
    try {
      var message = service<FcmService>().message;
      try {
        if (message != null) {
          try {
            var permalink = message.data['permalink'] as String;
            await _openPermalink(permalink);
          } catch (e) {
            showToast(e.toString(), error: true);
          }
        }
      } catch (e) {
        showToast(e.toString(), error: true);
      }
    } catch (e, trace) {
      print(trace);
      showToast(e.toString(), error: true);
    }
    model.update(loading: false);
  }

  Future<void> _openPermalink(String permalink) async {
    try {
      final visited = isVisited(permalink);
      if (visited) {
        service<FcmService>().clear();
        return;
      }
      await launch(permalink);
      markPermalinkAsVisited(permalink);
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    } catch (e) {
      showToast('Unable to open notification.', error: true);
    }
    service<FcmService>().clear();
  }
}
