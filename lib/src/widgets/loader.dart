import 'package:flutter/material.dart';

import 'index.dart';

class Loader extends StatelessWidget {
  const Loader({Key? key}) : super(key: key);

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
      ),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: SizedBox(
            height: 36,
            width: 36,
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
