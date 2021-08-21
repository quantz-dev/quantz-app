import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:momentum/momentum.dart';
import '../../services/interface/google-api.interface.dart';

import '../../data/index.dart';
import '../../services/interface/api.interface.dart';
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

  ApiInterface get api => service<ApiInterface>(runtimeType: false);
  GoogleApiInterface get google => service<GoogleApiInterface>(runtimeType: false);

  CloudBackupController get cloudBackupController => controller<CloudBackupController>();
  SupporterSubscriptionController get supporterController => controller<SupporterSubscriptionController>();
  AdmobController get admobController => controller<AdmobController>();

  Future<void> bootstrapAsync() async {
    if (model.token.isNotEmpty) {
      google.setAuthToken(model.token);
      await refreshToken(); // tries to refresh token in the backround.
    }
    await cloudBackupController.initialize();
    await supporterController.initialize();

    initializeAdmob();
  }

  /// Only call this when in-app-purchase has finish checking purchase status for supporter subscription.
  Future<void> initializeAdmob() async {
    await admobController.initialize();
  }

  void toggleLoading(bool isLoading) {
    supporterController.model.update(loading: isLoading);
    cloudBackupController.model.update(loading: isLoading);
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
    toggleLoading(true);
    final token = await google.signInWithGoogle();
    if (token.isNotEmpty) {
      await authWithGoogle(token);
    }
    toggleLoading(false);
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

  Future<void> refreshToken() async {
    toggleLoading(true);
    final newToken = await google.refreshToken();
    model.update(token: newToken);
    convertTokenToProfile();
    cloudBackupController.model.update(loading: false);
    supporterController.model.update(loading: false);
    toggleLoading(false);
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
    toggleLoading(true);
    await google.signOut();
    model.update(token: '');
    cloudBackupController.model.modifyLastRestore(lastRestore: null);
    convertTokenToProfile();
    toggleLoading(false);
  }
}
