import 'package:momentum/momentum.dart';
import '../services/mal.service.dart';

import '../services/index.dart';

var fcmService = FcmService();

List<MomentumService> services() {
  return [
    fcmService,
    ApiService(),
    MalService(),
  ];
}
