// import 'package:flutter/foundation.dart';
// import 'package:in_app_purchase_android/in_app_purchase_android.dart';

import '../notification/index.dart';
import 'index.dart';
import 'version.dart';

Future<void> initializer() async {
  initFirebaseNotification();

  await Future.wait([
    initSharedPreferences(),
    initLocalNotification(),
    checkAppVersion(),
  ]);

  // if (defaultTargetPlatform == TargetPlatform.android) {
  //   InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
  // }

  listenToAppLifecycle();
  listenToFCM();
}
