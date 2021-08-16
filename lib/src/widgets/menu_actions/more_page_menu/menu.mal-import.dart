import 'package:flutter/material.dart';
import 'package:momentum/momentum.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../components/import/index.dart';
import '../../index.dart';
import '../../listing/index.dart';
import '../../syncing/import.mal.dart';

class MenuMalImport extends StatelessWidget {
  const MenuMalImport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MomentumBuilder(
      controllers: [ImportController],
      builder: (context, snapshot) {
        var import = snapshot<ImportModel>();

        if (import.loading) {
          return MenuListItem(
            icon: Icons.sync,
            titleWidget: LinearProgressIndicator(),
            subtitle: 'MyAnimeList Import',
          );
        }

        return MenuListItem(
          title: 'MyAnimeList Import',
          subtitle: import.malUsername.isEmpty ? 'Login required.' : 'You\'re logged in.',
          icon: Icons.sync,
          trail: Text(
            import.malUsername.isEmpty ? 'Import Now' : import.malUsername,
            style: TextStyle(
              color: primary,
            ),
          ),
          onTap: () async {
            try {
              final url = await import.controller.getLoginUrl();
              if (url.isEmpty) {
                final started = await showImportMAL(context);
                if (started) {
                  await Future.delayed(Duration(seconds: 1));
                  await showMalImportProgress(context);
                }
                return;
              }
              launch(url);
            } catch (e) {
              print(e);
            }
          },
        );
      },
    );
  }
}
