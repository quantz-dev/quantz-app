import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../notification/index.dart';
import 'index.dart';

Future<void> initializer() async {
  await initSharedPreferences();
  await initFirebaseNotification();
  await initLocalNotification();

  final status = await MobileAds.instance.initialize();
  print(status.adapterStatuses);

  listenToAppLifecycle();
  listenToFCM();
}
