import 'package:flutter/material.dart';
import 'package:momentum/momentum.dart';

import '../../../components/import/index.dart';
import '../../index.dart';
import '../../listing/index.dart';
import '../../syncing/index.dart';

class MenuMalImport extends StatelessWidget {
  const MenuMalImport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MomentumBuilder(
      controllers: [ImportController],
      builder: (context, snapshot) {
        var import = snapshot<ImportModel>();

        return MenuListItem(
          title: 'MyAnimeList Import',
          subtitle: 'Your list must be public.',
          icon: Icons.sync,
          trail: Text(
            import.malUsername.isEmpty ? 'Import Now' : import.malUsername,
            style: TextStyle(
              color: primary,
            ),
          ),
          onTap: () async {
            final started = await showImportMAL(context);
            if (started) {
              await Future.delayed(Duration(seconds: 1));
              await showMalImportProgress(context);
            }
          },
        );
      },
    );
  }
}
