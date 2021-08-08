import 'package:firebase_messaging/firebase_messaging.dart';

import '../core/index.dart';
import 'index.dart';

void listenToFCM() {
  FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);
  FirebaseMessaging.onMessage.listen(_onMessage);
}

/// When the app is in the background
/// *(not visible on screen but not terminated either)*
void _onMessageOpenedApp(RemoteMessage event) {
  try {
    fcmService.setMessage(event);
  } catch (e, trace) {
    fcmService.clear();
    print(e.toString());
    print(trace.toString());
  }
}

/// When the app is in the foreground *(visible on screen).*
void _onMessage(RemoteMessage event) {
  try {
    fcmService.setMessage(event);
    // When the app is in the foreground, FCM will never show a notification.
    // The package called `flutter_local_notification` is needed for this.
    showLocalNotification(event);
  } catch (e, trace) {
    fcmService.clear();
    print(e.toString());
    print(trace.toString());
  }
}
