import 'package:momentum/momentum.dart';

import '../services/concretes/api.service.dart';
import '../services/concretes/google-api.service.dart';
import '../services/concretes/mal.service.dart';
import '../services/index.dart';

var fcmService = FcmService();

List<MomentumService> services() {
  return [
    fcmService,
    ApiService(),
    GoogleApiService(),
    MalService(),
  ];
}
