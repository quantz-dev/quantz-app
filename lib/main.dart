import 'package:flutter/material.dart';
import 'package:momentum/momentum.dart';

import 'src/core/index.dart';
import 'src/widgets/index.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(momentum());
}

Momentum momentum() {
  return Momentum(
    child: MyApp(),
    key: UniqueKey(),
    appLoader: Loader(),
    controllers: controllers(),
    services: services(),
    initializer: initializer,
    persistSave: persistSave,
    persistGet: persistGet,
  );
}
