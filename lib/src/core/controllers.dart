import 'package:momentum/momentum.dart';

import '../components/admob/index.dart';
import '../components/animelist/index.dart';
import '../components/cloud-backup/index.dart';
import '../components/feed/index.dart';
import '../components/filter/index.dart';
import '../components/google-flow/index.dart';
import '../components/integration/index.dart';
import '../components/sources/index.dart';
import '../components/notification/index.dart';
import '../components/supporter-subscription/index.dart';
import '../components/topic/index.dart';

final notificationController = NotificationController();

List<MomentumController> controllers() {
  return [
    AnimelistController(),
    notificationController,
    IntegrationController(),
    SourcesController(),
    TopicController(),
    FilterController()..config(maxTimeTravelSteps: 2),
    FeedController(),
    CloudBackupController(),
    AdmobController(),
    SupporterSubscriptionController(),
    GoogleFlowController()..config(lazy: false),
  ];
}
