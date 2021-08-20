import 'package:momentum/momentum.dart';

import '../../data/firebase.topics.dart';

abstract class GoogleApiInterface extends MomentumService {
  Future<FirebaseSubscription> getFirebaseSubscription();

  Future<String> signInWithGoogle();

  Future<String> refreshToken();
}
