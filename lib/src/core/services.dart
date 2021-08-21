import 'package:momentum/momentum.dart';

import '../services/index.dart';
import '../services/mocks/api.mock-service.dart';
import '../services/mocks/google-api.mock-service.dart';
import '../services/mocks/mal.mock-service.dart';

var fcmService = FcmService();

List<MomentumService> services() {
  return [
    fcmService,
    // ApiService(),
    // GoogleApiService(),
    // MalService(),
    ApiMockService(),
    GoogleApiMockService(),
    MalMockService(),
  ];
}
