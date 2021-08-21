import 'package:in_app_purchase/in_app_purchase.dart';

import '../../core/in-app-purchase.dart';
import '../../data/firebase.topics.dart';
import '../interface/google-api.interface.dart';

class GoogleApiMockService extends GoogleApiInterface {
  bool _isSignedIn = false;

  Future<bool> isSignedIn() async {
    await Future.delayed(Duration(seconds: 1));
    return _isSignedIn;
  }

  @override
  Future<FirebaseSubscription> getFirebaseSubscription() async {
    return FirebaseSubscription();
  }

  @override
  Future<String> signInWithGoogle() async {
    await Future.delayed(Duration(seconds: 2));
    _isSignedIn = true;
    return dummyToken;
  }

  Future<void> signOut() async {
    await Future.delayed(Duration(seconds: 1));
    _isSignedIn = false;
    return;
  }

  @override
  Future<String> refreshToken() async {
    if (_isSignedIn) {
      await Future.delayed(Duration(seconds: 2));
      return dummyToken;
    } else {
      return '';
    }
  }

  /* IN-APP PURCHASE INTERFACE */

  @override
  PurchaseDetails? get pendingPurchase => _pendingPurchase;
  PurchaseDetails? _pendingPurchase;

  @override
  Future<bool> checkStore() async {
    await Future.delayed(Duration(seconds: 1));
    return true;
  }

  @override
  Future<void> getSupporterSubscription() async {
    await Future.delayed(Duration(seconds: 2));
    _pendingPurchase = PurchaseDetails(
      productID: SUPPORTER_PRODUCT_ID,
      verificationData: PurchaseVerificationData(
        localVerificationData: 'localVerificationData',
        serverVerificationData: 'serverVerificationData',
        source: 'google_play',
      ),
      transactionDate: DateTime.now().toString(),
      status: PurchaseStatus.purchased,
    );
  }

  @override
  Future<bool> isPurchaseValid(PurchaseDetails purchaseDetails) async {
    await Future.delayed(Duration(seconds: 1));
    _pendingPurchase = null;
    return true;
  }

  @override
  Future<UpdatedPurchaseStatus> processPurchaseUpdated(PurchaseDetails purchaseDetails) async {
    await Future.delayed(Duration(seconds: 2));
    return UpdatedPurchaseStatus.subscriptionValid;
  }

  @override
  Future<void> restorePurchases({String? applicationUserName}) async {}

  /* IN-APP PURCHASE INTERFACE */
}

/// this is an actual token I generated using a dummy google account. Please don't abuse.
const dummyToken =
    'eyJhbGciOiJSUzI1NiIsImtpZCI6IjZlZjRiZDkwODU5MWY2OTdhOGE5Yjg5M2IwM2U2YTc3ZWIwNGU1MWYiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiI5NzIzMTQ0MDk4MTUtMHVsOGFwamIxZmdrMGtmcGJ2Y3YxdTV1cGJ0YXNydDEuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiI5NzIzMTQ0MDk4MTUtdHRkNXNuMm9pc2xmNmFvbmd1cHZja2ZmY3NvZXA3a3QuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMDczNzc5MTY0ODI1NDk4MjczNTkiLCJlbWFpbCI6ImR1bW15ZGV2cXVhbnR6QGdtYWlsLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJuYW1lIjoiRHVtbXkgRGV2IiwicGljdHVyZSI6Imh0dHBzOi8vbGgzLmdvb2dsZXVzZXJjb250ZW50LmNvbS9hL0FBVFhBSnl6TEEzZ0hmeDNROHozbzRfYmhveWE5eGxscUFJMU5mcmhpY0djPXM5Ni1jIiwiZ2l2ZW5fbmFtZSI6IkR1bW15IiwiZmFtaWx5X25hbWUiOiJEZXYiLCJsb2NhbGUiOiJlbi1HQiIsImlhdCI6MTYyOTU0MDY4MywiZXhwIjoxNjI5NTQ0MjgzfQ.C5rUPr1QIVCgzo0-Vabeh0nkgtfPhulsmehxIYEXDXIBzrPLGExUmUP390x_OatVtHe5cH07jab465m3qvND3BFPQ2VBITzForM8E0oF033SE3A4RuqsoOB9J_D60H6T-BPvQKQZD1erkFTBu8YsD6zVKnBYNUXTI3u83ueZ6e354kiargFtGAIdt195d5ryHjfcaJ2C-aPUwZAlKktEfbWxEtEDs4YTMMjBt7rkYtCEM9VdFul36ojbqIucygTlwH8-VoFGfwy8L_9kzqE_VAPOzVCZSuJ9pzX3lgxs74htu6Vo3ACmyytXFKTeqqplR5R5DCtSQExWLBm4pKeIGQ';
