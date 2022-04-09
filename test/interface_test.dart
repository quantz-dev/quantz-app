import 'package:flutter/material.dart';
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

  testWidgets('(widget tree) services interface should be abstracted properly', (tester) async {
    final widget = Momentum(
      child: MaterialApp(home: Scaffold(
        body: Builder(
          builder: (context) {
            Momentum.service<ApiInterface>(context, runtimeType: false);
            Momentum.service<GoogleApiInterface>(context, runtimeType: false);
            Momentum.service<MalInterface>(context, runtimeType: false);
            // throws an error if interface implementations aren't found.
            return Text('WIDGET_BUILT'); // if not, the abstraction worked.
          },
        ),
      )),
      controllers: [],
      services: services(),
    );

    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    expect(find.text('WIDGET_BUILT'), findsOneWidget);
  });

  testWidgets('(widget tree) services interface should throw an error for non-existent interface', (tester) async {
    final widget = Momentum(
      child: MaterialApp(home: Scaffold(
        body: Builder(
          builder: (context) {
            // this should throw an error
            Momentum.service<DummyInterface>(context, runtimeType: false);
            return Text('WIDGET_BUILT');
          },
        ),
      )),
      controllers: [],
      services: services(),
    );

    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    expect(tester.takeException(), isInstanceOf<Exception>());
  });
}

abstract class DummyInterface extends MomentumService {}
