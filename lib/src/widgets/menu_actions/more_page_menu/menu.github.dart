import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../listing/index.dart';

class MenuGithubLink extends StatelessWidget {
  const MenuGithubLink({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MenuListItem(
      title: 'GitHub Repo',
      icon: Icons.link,
      onTap: () async {
        try {
          launch('https://github.com/xamantra/quantz-app');
        } catch (e) {
          print(e);
        }
      },
    );
  }
}
