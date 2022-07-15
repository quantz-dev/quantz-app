import 'dart:async';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../core/api_key.dart';
import '../../core/config.dart';
import '../../core/in-app-purchase.dart';
import '../../data/firebase.topics.dart';
import '../../notification/index.dart';
import '../../widgets/toast.dart';
import '../interface/google-api.interface.dart';

class GoogleApiService extends GoogleApiInterface {
  final _dio = Dio();

  String get authToken => _authToken;
  String _authToken = '';

  GoogleApiService() {
    _dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      options.headers['api-key'] = api_key;
      return handler.next(options); //continue
    }, onResponse: (response, handler) {
      return handler.next(response); // continue
    }, onError: (DioError e, handler) {
      return handler.next(e); //continue
    }));
  }

  void setAuthToken(String token) {
    _authToken = token;
  }

  Future<bool> isSignedIn() async {
    return GoogleSignIn().isSignedIn();
  }

  Future<FirebaseSubscription> getFirebaseSubscription() async {
    await waitForFirebaseInit();
    var token = await FirebaseMessaging.instance.getToken();
    final path = '$api/topics/$token';
    try {
      var response = await _dio.post(path);
      final result = FirebaseSubscription.fromJson(response.data);
      print(['getFirebaseSubscription()', '${result.topics.keys.length} topics']);
      return result;
    } catch (e) {
      print(['getFirebaseSubscription() ERROR', path]);
      return FirebaseSubscription();
    }
  }

  Future<String> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        _authToken = googleAuth.idToken ?? '';
        return _authToken;
      }
      return '';
    } catch (e) {
      print(e);
      showToast('$e', error: true);
      return '';
    }
  }

  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    return;
  }

  Future<String> refreshToken() async {
    try {
      final signedIn = await isSignedIn();
      if (signedIn) {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signInSilently();
        if (googleUser != null) {
          final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
          _authToken = googleAuth.idToken ?? '';
          return _authToken;
        }
      }
      return '';
    } catch (e) {
      print(e);
      showToast('$e', error: true);
      return '';
    }
  }

  /* IN-APP PURCHASE INTERFACE */

  PurchaseDetails? get pendingPurchase => _pendingPurchase;
  PurchaseDetails? _pendingPurchase;

  Future<void> restorePurchases({String? applicationUserName}) async {
    await InAppPurchase.instance.restorePurchases(applicationUserName: applicationUserName);
    return;
  }

  Future<UpdatedPurchaseStatus> processPurchaseUpdated(PurchaseDetails purchaseDetails) async {
    var resultStatus = UpdatedPurchaseStatus.none;
    var valid = false;
    _pendingPurchase = purchaseDetails;
    final isPurchased = purchaseDetails.status == PurchaseStatus.purchased;
    final isRestored = purchaseDetails.status == PurchaseStatus.restored;
    if (purchaseDetails.status == PurchaseStatus.pending) {
      resultStatus = UpdatedPurchaseStatus.purchaseIsPending;
    } else {
      if (purchaseDetails.status == PurchaseStatus.error) {
        final err = purchaseDetails.error;
        print(['IAP ERROR', err?.source, err?.code, err?.message]);
        resultStatus = UpdatedPurchaseStatus.purchaseDetailsError;
      } else if (isPurchased || isRestored) {
        valid = await isPurchaseValid(purchaseDetails);
        if (valid) {
          _pendingPurchase = null;
          resultStatus = UpdatedPurchaseStatus.subscriptionValid;
        } else {
          resultStatus = UpdatedPurchaseStatus.subscriptionInvalid;
        }
      }
      if (purchaseDetails.pendingCompletePurchase) {
        try {
          await InAppPurchase.instance.completePurchase(purchaseDetails);
        } catch (e, trace) {
          resultStatus = UpdatedPurchaseStatus.completingPurchaseError;
          print(['IAP.completePurchase ERROR', e, trace]);
        }
      }
    }
    return resultStatus;
  }

  Future<bool> isPurchaseValid(PurchaseDetails purchaseDetails) async {
    /* Google account is required for purchase verification */
    if (authToken.isEmpty) return false;

    /* Verification logic. */
    final v = purchaseDetails.verificationData;
    final valid = await verifySupporterPurchase(
      authToken: authToken,
      purchaseToken: v.serverVerificationData,
      source: v.source,
    );
    return valid;
    /* Verification logic. */
  }

  Future<bool> checkStore() async {
    final bool available = await InAppPurchase.instance.isAvailable();
    return available;
  }

  Future<void> getSupporterSubscription() async {
    const _kIds = <String>{SUPPORTER_PRODUCT_ID};
    final ProductDetailsResponse response = await InAppPurchase.instance.queryProductDetails(_kIds);
    if (response.notFoundIDs.isNotEmpty) {
      showToast('Unable to fetch details from store.');
    } else {
      final products = response.productDetails;
      if (products.isNotEmpty) {
        for (var product in products) {
          if (product.id == SUPPORTER_PRODUCT_ID) {
            final purchaseParam = PurchaseParam(productDetails: product);
            final success = await InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
            if (!success) {
              showToast('Something went wrong with the purchase.', error: true);
            }
          }
        }
      }
    }
  }

  Future<bool> verifySupporterPurchase({required String authToken, required String purchaseToken, required String source}) async {
    const path = '$api/supporter/verify';
    try {
      final param = <String, dynamic>{
        'auth_token': authToken,
        'purchase_token': purchaseToken,
        'source': source,
      };
      var response = await _dio.post(path, data: param);
      return response.data['valid'];
    } catch (e) {
      print(['ERROR', path]);
      return false;
    }
  }
  /* IN-APP PURCHASE INTERFACE */
}
