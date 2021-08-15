import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:momentum/momentum.dart';

import '../../data/index.dart';
import '../../misc/index.dart';
import '../../services/index.dart';
import '../../widgets/index.dart';
import '../animelist/index.dart';
import '../import/index.dart';
import '../news/index.dart';
import '../supporter-subscription/index.dart';
import 'index.dart';

class CloudBackupController extends MomentumController<CloudBackupModel> {
  @override
  CloudBackupModel init() {
    return CloudBackupModel(
      this,
      token: '',
      profile: JwtTokenProfile(),
      latestBackupInfo: CloudBackup(),
      loading: false,
    );
  }

  ApiService get api => service<ApiService>();

  Future<void> bootstrapAsync() async {
    if (model.token.isNotEmpty) {
      model.update(loading: true);
      await refreshToken(); // tries to refresh token in the backround.
      final latestBackupInfo = await api.fetchBackup(token: model.token, includeData: false);
      model.update(latestBackupInfo: latestBackupInfo, loading: false);
      controller<SupporterSubscriptionController>().getSupporterSubscription();
    }
  }

  Future<void> signInWithGoogle() async {
    model.update(loading: true);
    final signedIn = await GoogleSignIn().isSignedIn();
    if (signedIn) {
      sendEvent(CloudbackupEvents.alreadySignedIn);
      return;
    }
    final token = await api.signInWithGoogle();
    if (token.isNotEmpty) {
      await authWithGoogle(token);
    }
    model.update(loading: false);
  }

  Future<void> authWithGoogle(String token) async {
    if (token.isEmpty) return;
    model.update(loading: true);
    final latestBackupInfo = await api.fetchBackup(token: token, includeData: false);
    model.update(token: token, latestBackupInfo: latestBackupInfo);
    convertTokenToProfile();
    model.update(loading: false);
  }

  void convertTokenToProfile() {
    try {
      if (model.token.isNotEmpty) {
        final profile = JwtTokenProfile.fromJson(JwtDecoder.decode(model.token));
        model.update(profile: profile);
      } else {
        model.update(profile: JwtTokenProfile());
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String> refreshToken() async {
    model.update(loading: true);
    final signedIn = await GoogleSignIn().isSignedIn();
    if (signedIn) {
      final newToken = await api.refreshToken();
      model.update(token: newToken);
      convertTokenToProfile();
      model.update(loading: false);
      return newToken;
    }
    model.update(loading: false);
    return '';
  }

  Future<void> startNewBackup() async {
    if (model.signedIn) {
      final importState = controller<ImportController>().model.toJson();
      final animeListState = controller<AnimelistController>().model.toBackup();
      final newsState = controller<NewsController>().model.toJson();

      final data = BackupData(
        importState: importState,
        animeListState: animeListState,
        newsState: newsState,
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

        /* Parsing */
        final json = jsonDecode(backupData.data);
        final importState = jsonEncode(json[IMPORT_STATE_KEY]);
        final animeListState = jsonEncode(json[ANIMELIST_STATE_KEY]);
        final newsState = jsonEncode(json[NEWS_STATE_KEY]);
        /* Parsing */

        /* Restoration */
        controller<ImportController>().restoreFromBackup(importState);
        await controller<NewsController>().restoreFromBackup(newsState);
        await controller<AnimelistController>().restoreFromBackup(animeListState);
        model.update(lastRestore: DateTime.now());
        /* Restoration */
      } catch (e) {
        showToast(e.toString(), error: true);
      }
    } else {
      showToast('Please sign in with google first', error: true);
    }
  }

  Future<void> signout() async {
    model.update(loading: true);
    await GoogleSignIn().signOut();
    model.update(token: '');
    model.modifyLastRestore(lastRestore: null);
    convertTokenToProfile();
    model.update(loading: false);
  }
}
