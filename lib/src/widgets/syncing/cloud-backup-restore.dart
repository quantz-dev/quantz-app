import 'package:flutter/material.dart';
import 'package:momentum/momentum.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../components/cloud-backup/index.dart';

Future<CloudbackupEvents> showBackupSettings(BuildContext context) async {
  final popped = await showDialog<CloudbackupEvents>(context: context, builder: (_) => _CloudBackupRestorePrompt());
  return popped ?? CloudbackupEvents.none;
}

class _CloudBackupRestorePrompt extends StatelessWidget {
  const _CloudBackupRestorePrompt({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: MomentumBuilder(
        controllers: [CloudBackupController],
        builder: (context, snapshot) {
          final cloud = snapshot<CloudBackupModel>();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _NewBackupMenu(cloud: cloud),
              _RestoreLatestWidget(cloud: cloud),
              _LogoutGoogleWidget(),
            ],
          );
        },
      ),
    );
  }
}

class _LogoutGoogleWidget extends StatelessWidget {
  const _LogoutGoogleWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        'Signout from Google',
        style: TextStyle(
          color: Colors.redAccent,
        ),
      ),
      onTap: () {
        Navigator.pop(context, CloudbackupEvents.logoutGoogle);
      },
    );
  }
}

class _RestoreLatestWidget extends StatelessWidget {
  const _RestoreLatestWidget({
    Key? key,
    required this.cloud,
  }) : super(key: key);

  final CloudBackupModel cloud;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Restore from Latest'),
      subtitle: cloud.hasLastRestored ? Text(timeago.format(cloud.lastRestore!)) : SizedBox(),
      onTap: () {
        Navigator.pop(context, CloudbackupEvents.restoreFromLatest);
      },
    );
  }
}

class _NewBackupMenu extends StatelessWidget {
  const _NewBackupMenu({
    Key? key,
    required this.cloud,
  }) : super(key: key);

  final CloudBackupModel cloud;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('New Backup'),
      subtitle: cloud.hasLatestBackup ? Text(timeago.format(cloud.latestBackupInfo.updatedAt!)) : SizedBox(),
      onTap: () {
        Navigator.pop(context, CloudbackupEvents.startNewBackup);
      },
    );
  }
}
