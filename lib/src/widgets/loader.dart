import 'package:flutter/material.dart';

import 'index.dart';

class Loader extends StatelessWidget {
  const Loader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quantz',
      theme: ThemeData.dark().copyWith(
        primaryColor: primary,
        accentColor: primary,
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
