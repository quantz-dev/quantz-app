import 'package:flutter/material.dart';

import 'index.dart';
import 'pages/core.dashboard.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = ThemeData.dark();
    return MaterialApp(
      title: 'Quantz',
      theme: theme.copyWith(
        primaryColor: primary,
        colorScheme: theme.colorScheme.copyWith(
          secondary: primary,
        ),
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
