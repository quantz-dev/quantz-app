import 'package:flutter_fgbg/flutter_fgbg.dart';

import '../core/index.dart';

/// This is for when the app switches between foreground and background states.
void listenToAppLifecycle() {
  FGBGEvents.stream.listen((event) {
    switch (event) {
      case FGBGType.foreground:
        // This case is for when:
        // - The app is in the background.
        // - Receives a notification.
        // - User clicks the notification (the app goes to foreground as a result).
        notificationController.model.update(loading: false);
        // - The app will then try to open the url that came with the notification.
        notificationController.openNotification();
        break;
      default:
        break;
    }
  });
}
