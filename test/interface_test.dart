import 'package:flutter_test/flutter_test.dart';
import 'package:momentum/momentum.dart';
import 'package:quantz/src/core/index.dart';
import 'package:quantz/src/services/interface/api.interface.dart';
import 'package:quantz/src/services/interface/google-api.interface.dart';
import 'package:quantz/src/services/interface/mal.interface.dart';

void main() {
  test('services interface should be abstracted properly', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final tester = MomentumTester(
      Momentum(
        controllers: [],
        services: services(),
      ),
    );

    await tester.init();

    final apiService = tester.service<ApiInterface>(runtimeType: false);
    print(['API_SERVICE', apiService.hashCode]);
    expect(apiService, isInstanceOf<ApiInterface>());

    final googleApiService = tester.service<GoogleApiInterface>(runtimeType: false);
    print(['GOOGLE_API_SERVICE', googleApiService.hashCode]);
    expect(googleApiService, isInstanceOf<GoogleApiInterface>());

    final malService = tester.service<MalInterface>(runtimeType: false);
    print(['MAL_SERVICE', malService.hashCode]);
    expect(malService, isInstanceOf<MalInterface>());
  });
}
