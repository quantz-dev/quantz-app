import 'package:flutter/material.dart';

import 'index.dart';
import 'pages/core.dashboard.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quantz',
      theme: ThemeData.dark().copyWith(
        primaryColor: primary,
        accentColor: primary,
        backgroundColor: background,
        scaffoldBackgroundColor: background,
        dialogBackgroundColor: background,
      ),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: DashboardPage(),
    );
  }
}
