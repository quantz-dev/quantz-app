import 'package:momentum/momentum.dart';

import '../components/admob/index.dart';
import '../components/animelist/index.dart';
import '../components/cloud-backup/index.dart';
import '../components/feed/index.dart';
import '../components/filter/index.dart';
import '../components/import/index.dart';
import '../components/news/index.dart';
import '../components/notification/index.dart';
import '../components/topic/index.dart';

final notificationController = NotificationController();

List<MomentumController> controllers() {
  return [
    AnimelistController(),
    notificationController,
    ImportController(),
    NewsController(),
    TopicController(),
    CloudBackupController()..config(lazy: true),
    FilterController()..config(maxTimeTravelSteps: 2),
    AdmobController(),
    FeedController()..config(lazy: true),
  ];
}
