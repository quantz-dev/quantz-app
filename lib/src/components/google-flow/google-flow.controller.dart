import 'package:google_sign_in/google_sign_in.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:momentum/momentum.dart';
import 'package:quantz/src/services/api.service.dart';

import '../../data/index.dart';
import '../admob/index.dart';
import '../cloud-backup/index.dart';
import '../supporter-subscription/index.dart';
import 'index.dart';

/// The features:
/// - Google ads (admob)
/// - Cloud backup
/// - In-app-purchase
///
/// depend on **google signin**.
///
/// The purpose of this controller is to simplify their flow, improve code structure and state management.
class GoogleFlowController extends MomentumController<GoogleFlowModel> {
  @override
  GoogleFlowModel init() {
    return GoogleFlowModel(
      this,
      token: '',
      profile: JwtTokenProfile(),
    );
  }

  ApiService get api => service<ApiService>();

  CloudBackupController get cloudBackupController => controller<CloudBackupController>();
  SupporterSubscriptionController get supporterController => controller<SupporterSubscriptionController>();
  AdmobController get admobController => controller<AdmobController>();

  Future<void> bootstrapAsync() async {
    if (model.token.isNotEmpty) {
      await refreshToken(); // tries to refresh token in the backround.
    }
    await cloudBackupController.initialize();
    await supporterController.initialize();
  }

  /// Only call this when in-app-purchase has finish checking purchase status for supporter subscription.
  Future<void> initializeAdmob() async {
    await admobController.initialize();
  }

  Future<void> getSupporterSubscription() async {
    if (!model.signedIn) {
      await signInWithGoogle();
    }
    if (model.signedIn) {
      await supporterController.getSupporterSubscription();
    }
  }

  Future<void> showCloudBackup() async {
    final showed = await cloudBackupController.triggerCloudBackupPrompt();
    if (!showed) {
      await signInWithGoogle();
    }
  }

  Future<void> signInWithGoogle() async {
    supporterController.model.update(loading: true);
    cloudBackupController.model.update(loading: true);
    final token = await api.signInWithGoogle();
    if (token.isNotEmpty) {
      await authWithGoogle(token);
    }
    supporterController.model.update(loading: false);
    cloudBackupController.model.update(loading: false);
  }

  Future<void> authWithGoogle(String token) async {
    if (token.isEmpty) return;
    cloudBackupController.model.update(loading: true);
    final latestBackupInfo = await api.fetchBackup(token: token, includeData: false);
    model.update(token: token);
    cloudBackupController.model.update(latestBackupInfo: latestBackupInfo);
    convertTokenToProfile();
    cloudBackupController.model.update(loading: false);
  }

  Future<String> refreshToken() async {
    supporterController.model.update(loading: true);
    cloudBackupController.model.update(loading: true);
    final signedIn = await GoogleSignIn().isSignedIn();
    if (signedIn) {
      final newToken = await api.refreshToken();
      model.update(token: newToken);
      convertTokenToProfile();
      cloudBackupController.model.update(loading: false);
      return newToken;
    }
    supporterController.model.update(loading: false);
    cloudBackupController.model.update(loading: false);
    return '';
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

  Future<void> signout() async {
    cloudBackupController.model.update(loading: true);
    await GoogleSignIn().signOut();
    model.update(token: '');
    cloudBackupController.model.modifyLastRestore(lastRestore: null);
    convertTokenToProfile();
    cloudBackupController.model.update(loading: false);
  }
}
