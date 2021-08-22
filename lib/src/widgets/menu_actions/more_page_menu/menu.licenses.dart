import 'package:flutter/material.dart';

import '../../../core/version.dart';
import '../../listing/index.dart';

class MenuAppLicenses extends StatelessWidget {
  const MenuAppLicenses({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MenuListItem(
      title: 'License',
      icon: Icons.snippet_folder,
      onTap: () async {
        showLicensePage(
          context: context,
          applicationName: 'Quantz',
          applicationLegalese: 'dev.xamantra.quantz',
          applicationVersion: appVersion,
          applicationIcon: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/q.png',
                height: 48,
              ),
            ),
          ),
        );
      },
    );
  }
}
