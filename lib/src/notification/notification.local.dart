import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../core/index.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
final MacOSInitializationSettings initializationSettingsMacOS = MacOSInitializationSettings();
final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid, macOS: initializationSettingsMacOS);

Future<void> initLocalNotification() async {
  await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);
}

Future<void> showLocalNotification(RemoteMessage? message) async {
  if (message != null) {
    final _random = new Random();
    int next(int min, int max) => min + _random.nextInt(max - min);

    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'high_importance_channel',
      'Quantz Notifications',
      channelDescription: 'Notifications for episode releases and news updates.',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      next(10000000, 99999999),
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
      payload: '{}',
    );
  }
}

Future onSelectNotification(String? event) async {
  try {
    print('Local notification clicked, opening permalink...');
    notificationController.openNotification();
  } catch (e, trace) {
    print(e);
    print(trace);
  }
}
