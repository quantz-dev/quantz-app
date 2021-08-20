import 'package:momentum/momentum.dart';

import '../services/google-api.service.dart';
import '../services/index.dart';
import '../services/mal.service.dart';

var fcmService = FcmService();

List<MomentumService> services() {
  return [
    fcmService,
    ApiService(),
    GoogleApiService(),
    MalService(),
  ];
}
