import 'package:flutter/material.dart';

import '../index.dart';
import '../menu_actions/more_page_menu/index.dart';
import '../menu_actions/more_page_menu/menu.github.dart';
import '../menu_actions/more_page_menu/menu.licenses.dart';
import '../menu_actions/more_page_menu/menu.support-dev.dart';

class MorePage extends StatelessWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('More'),
        backgroundColor: secondaryBackground,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 16,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: secondaryBackground,
                boxShadow: [getShadow(-0.5)],
              ),
              child: Center(
                child: Image.asset(
                  'assets/q.png',
                  width: 64,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 80,
            child: Container(
              width: double.infinity,
              child: Column(
                children: [
                  MenuMalImport(),
                  Divider(height: 1),
                  MenuBackupRestore(),
                  Divider(height: 1),
                  SupportTheDeveloper(),
                  Divider(height: 1),
                  MenuAppLicenses(),
                  Divider(height: 1),
                  MenuGithubLink(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
