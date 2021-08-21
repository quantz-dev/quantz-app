import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:momentum/momentum.dart';

import '../../data/firebase.topics.dart';

abstract class GoogleApiInterface extends MomentumService {
  Future<bool> isSignedIn();

  Future<FirebaseSubscription> getFirebaseSubscription();

  Future<String> signInWithGoogle();

  Future<void> signOut();

  Future<String> refreshToken();

  /* IN-APP PURCHASE INTERFACE */
  PurchaseDetails? get pendingPurchase;

  Future<void> restorePurchases({String? applicationUserName});

  Future<UpdatedPurchaseStatus> processPurchaseUpdated(PurchaseDetails purchaseDetails);

  Future<bool> isPurchaseValid(PurchaseDetails purchaseDetails);

  Future<void> getSupporterSubscription();

  Future<bool> checkStore();
  /* IN-APP PURCHASE INTERFACE */
}

enum UpdatedPurchaseStatus {
  none,
  purchaseIsPending,
  subscriptionValid,
  subscriptionInvalid,
  purchaseDetailsError,
  completingPurchaseError,
}
