import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

import '../notification/index.dart';
import 'index.dart';

Future<void> initializer() async {
  await initSharedPreferences();
  await initFirebaseNotification();
  await initLocalNotification();

  final status = await MobileAds.instance.initialize();
  print(status.adapterStatuses);

  if (defaultTargetPlatform == TargetPlatform.android) {
    InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
  }

  listenToAppLifecycle();
  listenToFCM();
}
