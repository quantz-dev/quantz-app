import 'dart:convert';

import 'package:momentum/momentum.dart';
import '../../services/interface/google-api.interface.dart';
import '../../services/interface/api.interface.dart';

import '../../data/index.dart';
import '../../misc/index.dart';
import '../../widgets/index.dart';
import '../animelist/index.dart';
import '../import/index.dart';
import '../sources/index.dart';
import 'index.dart';

class CloudBackupController extends MomentumController<CloudBackupModel> {
  @override
  CloudBackupModel init() {
    return CloudBackupModel(
      this,
      latestBackupInfo: CloudBackup(),
      loading: false,
    );
  }

  ApiInterface get api => service<ApiInterface>(runtimeType: false);
  GoogleApiInterface get google => service<GoogleApiInterface>(runtimeType: false);

  Future<void> initialize() async {
    if (model.signedIn) {
      model.update(loading: true);
      final latestBackupInfo = await api.fetchBackup(token: model.token, includeData: false);
      model.update(latestBackupInfo: latestBackupInfo, loading: false);
    }
  }

  Future<bool> triggerCloudBackupPrompt() async {
    model.update(loading: true);
    final signedIn = await google.isSignedIn();
    if (signedIn) {
      sendEvent(CloudbackupEvents.alreadySignedIn);
    }
    model.update(loading: false);
    return signedIn;
  }

  Future<void> startNewBackup() async {
    if (model.signedIn) {
      final importState = controller<ImportController>().model.toJson();
      final animeListState = controller<AnimelistController>().model.toBackup();
      final sourcesState = controller<SourcesController>().model.toJson();

      final data = BackupData(
        importState: importState,
        animeListState: animeListState,
        sourcesState: sourcesState,
      ).toRawJson();

      final result = await api.newBackup(token: model.token, data: data);
      model.update(latestBackupInfo: result);
    } else {
      showToast('Please sign in with google first', error: true);
    }
  }

  Future<void> restoreFromLatest() async {
    if (model.signedIn) {
      try {
        final backupData = await api.fetchBackup(token: model.token);

        if (backupData.data.isNotEmpty) {
          /* Parsing */
          final json = jsonDecode(backupData.data);
          final importState = jsonEncode(json[IMPORT_STATE_KEY]);
          final animeListState = jsonEncode(json[ANIMELIST_STATE_KEY]);
          final sourcesState = jsonEncode(json[SOURCES_STATE_KEY]);
          /* Parsing */

          /* Restoration */
          controller<ImportController>().restoreFromBackup(importState);
          await controller<SourcesController>().restoreFromBackup(sourcesState);
          await controller<AnimelistController>().restoreFromBackup(animeListState);
          model.update(lastRestore: DateTime.now());
          /* Restoration */
        }
      } catch (e) {
        showToast(e.toString(), error: true);
      }
    } else {
      showToast('Please sign in with google first', error: true);
    }
  }
}
