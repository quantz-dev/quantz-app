import 'package:flutter/material.dart';
import 'package:momentum/momentum.dart';

import '../../../components/cloud-backup/index.dart';
import '../../../components/google-flow/google-flow.controller.dart';
import '../../../components/google-flow/google-flow.model.dart';
import '../../index.dart';
import '../../listing/index.dart';
import '../../syncing/index.dart';

class MenuBackupRestore extends StatefulWidget {
  const MenuBackupRestore({Key? key}) : super(key: key);

  @override
  _MenuBackupRestoreState createState() => _MenuBackupRestoreState();
}

class _MenuBackupRestoreState extends MomentumState<MenuBackupRestore> {
  GoogleFlowController? flowController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = Momentum.controller<CloudBackupController>(context);
    flowController = Momentum.controller<GoogleFlowController>(context);
    controller.listen<CloudbackupEvents>(
      state: this,
      invoke: (event) async {
        switch (event) {
          case CloudbackupEvents.alreadySignedIn:
            final result = await showBackupSettings(context);
            controller.model.update(loading: false);
            switch (result) {
              case CloudbackupEvents.startNewBackup:
                showLoading(context, controller.startNewBackup());
                break;
              case CloudbackupEvents.restoreFromLatest:
                showLoading(context, controller.restoreFromLatest());
                break;
              case CloudbackupEvents.logoutGoogle:
                showLoading(context, flowController!.signout());
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
      controllers: [
        CloudBackupController,
        GoogleFlowController,
      ],
      builder: (context, snapshot) {
        final cloud = snapshot<CloudBackupModel>();
        final googleFlow = snapshot<GoogleFlowModel>();

        if (cloud.loading) {
          return MenuListItem(
            icon: Icons.cloud,
            titleWidget: LinearProgressIndicator(),
            subtitle: 'Backup & Restore',
          );
        }

        return MenuListItem(
          title: 'Backup & Restore',
          subtitle: cloud.signedIn ? googleFlow.emailObscure : 'Google account required.',
          icon: Icons.cloud,
          trail: _LoginWidget(signedIn: cloud.signedIn),
          onTap: () {
            flowController?.showCloudBackup();
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
