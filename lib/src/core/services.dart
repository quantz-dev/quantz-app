import 'package:momentum/momentum.dart';

import '../services/index.dart';

var fcmService = FcmService();

List<MomentumService> services() {
  return [
    fcmService,
    ApiService(),
    GoogleApiService(),
    MalService(),
    // ApiMockService(),
    // GoogleApiMockService(),
    // MalMockService(),
  ];
}
