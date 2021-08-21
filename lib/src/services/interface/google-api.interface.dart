import 'package:momentum/momentum.dart';

import '../../data/firebase.topics.dart';

abstract class GoogleApiInterface extends MomentumService {
  Future<bool> isSignedIn();

  Future<FirebaseSubscription> getFirebaseSubscription();

  Future<String> signInWithGoogle();

  Future<void> signOut();

  Future<String> refreshToken();
}
