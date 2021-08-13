import 'package:flutter/material.dart';
import 'package:momentum/momentum.dart';

import '../../../components/cloud-backup/index.dart';
import '../../index.dart';
import '../../listing/index.dart';
import '../../syncing/index.dart';

class MenuBackupRestore extends StatefulWidget {
  const MenuBackupRestore({Key? key}) : super(key: key);

  @override
  _MenuBackupRestoreState createState() => _MenuBackupRestoreState();
}

class _MenuBackupRestoreState extends MomentumState<MenuBackupRestore> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = Momentum.controller<CloudBackupController>(context);
    controller.listen<CloudbackupEvents>(
      state: this,
      invoke: (event) async {
        switch (event) {
          case CloudbackupEvents.alreadySignedIn:
            final result = await showBackupSettings(context);
            switch (result) {
              case CloudbackupEvents.startNewBackup:
                showLoading(context, controller.startNewBackup());
                break;
              case CloudbackupEvents.restoreFromLatest:
                showLoading(context, controller.restoreFromLatest());
                break;
              case CloudbackupEvents.logoutGoogle:
                showLoading(context, controller.signout());
                break;
              default:
                break;
            }
            break;
          default:
            break;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MomentumBuilder(
      controllers: [CloudBackupController],
      builder: (context, snapshot) {
        final cloud = snapshot<CloudBackupModel>();
        final profile = cloud.profile;

        return MenuListItem(
          title: 'Backup & Restore',
          subtitle: cloud.signedIn ? profile.email : 'Google account required.',
          icon: Icons.cloud,
          trail: _LoginWidget(signedIn: cloud.signedIn),
          onTap: () {
            cloud.controller.signInWithGoogle();
          },
        );
      },
    );
  }
}

class _LoginWidget extends StatelessWidget {
  const _LoginWidget({
    Key? key,
    required this.signedIn,
  }) : super(key: key);

  final bool signedIn;

  @override
  Widget build(BuildContext context) {
    return !signedIn
        ? Image.asset(
          'assets/google_sign_in.png',
          width: 128,
        )
        : Text(
            'Settings',
            style: TextStyle(
              color: primary,
            ),
          );
  }
}
