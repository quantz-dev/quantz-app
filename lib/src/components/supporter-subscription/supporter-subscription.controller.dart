import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:momentum/momentum.dart';
import 'package:quantz/src/components/cloud-backup/index.dart';

import '../../core/in-app-purchase.dart';
import '../../services/index.dart';
import '../../widgets/index.dart';
import '../admob/index.dart';
import 'index.dart';

SupporterSubscriptionController supporterCtrl(BuildContext context) => Momentum.controller<SupporterSubscriptionController>(context);

class SupporterSubscriptionController extends MomentumController<SupporterSubscriptionModel> {
  @override
  SupporterSubscriptionModel init() {
    return SupporterSubscriptionModel(
      this,
      loading: false,
      purchaseIsPending: false,
      purchaseError: '',
      subscriptionActive: false,
      storeIsAvailable: false,
    );
  }

  // ignore: cancel_subscriptions
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  PurchaseDetails? _pendingPurchase;

  ApiService get api => service<ApiService>();

  CloudBackupController get cloudController => controller<CloudBackupController>();

  void bootstrap() async {
    await checkStore();

    if (!model.storeIsAvailable) return;

    final purchaseUpdated = InAppPurchase.instance.purchaseStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      for (var details in purchaseDetailsList) {
        if (details.productID == SUPPORTER_PRODUCT_ID) _checkPurchaseUpdated(details);
      }
    }, onDone: () {
      _subscription!.cancel();
    }, onError: (error, trace) {
      print([error, trace]);
    });

    await InAppPurchase.instance.restorePurchases();
  }

  void _checkPurchaseUpdated(PurchaseDetails purchaseDetails) async {
    final isPurchased = purchaseDetails.status == PurchaseStatus.purchased;
    final isRestored = purchaseDetails.status == PurchaseStatus.restored;
    if (purchaseDetails.status == PurchaseStatus.pending) {
      model.update(purchaseIsPending: true);
    } else {
      if (purchaseDetails.status == PurchaseStatus.error) {
        final err = purchaseDetails.error;
        print(['IAP ERROR', err?.source, err?.code, err?.message]);
        model.update(purchaseError: err?.message ?? '', purchaseIsPending: false);
      } else if (isPurchased || isRestored) {
        bool valid = await _isPurchaseValid(purchaseDetails);
        if (valid) {
          model.update(subscriptionActive: valid);
          initializedAds();
        } else {
          if (cloudController.model.loading) {
            // google signin is loading. don't show any error.
          } else {
            showToast('Unable to validated your purchase.', error: !valid);
          }
        }
      }
      if (purchaseDetails.pendingCompletePurchase) {
        try {
          await InAppPurchase.instance.completePurchase(purchaseDetails);
          model.update(purchaseIsPending: false);
        } catch (e, trace) {
          print(['IAP.completePurchase ERROR', e, trace]);
        }
      }
    }
  }

  Future<bool> _isPurchaseValid(PurchaseDetails purchaseDetails) async {
    /* Google account is required for purchase verification */
    String authToken = '';
    final auth = cloudController.model;
    if (auth.loading) {
      _pendingPurchase = purchaseDetails;
      return false;
    }
    if (!auth.signedIn) {
      authToken = await api.signInWithGoogle();
      cloudController.authWithGoogle(authToken);
    } else {
      authToken = cloudController.model.token;
    }
    /* Google account is required for purchase verification */

    /* Verification logic. */
    final v = purchaseDetails.verificationData;
    final valid = await api.verifySupporterPurchase(
      authToken: authToken,
      purchaseToken: v.serverVerificationData,
      source: v.source,
    );
    if (valid)
      _pendingPurchase = null;
    else
      _pendingPurchase = purchaseDetails;

    return valid;
    /* Verification logic. */
  }

  Future<void> checkStore() async {
    final bool available = await InAppPurchase.instance.isAvailable();
    model.update(storeIsAvailable: available);
  }

  Future<void> getSupporterSubscription() async {
    if (model.subscriptionActive) {
      showToast('You are already supporting the developer.');
      return;
    }
    if (_pendingPurchase != null) {
      final valid = await _isPurchaseValid(_pendingPurchase!);
      if (valid) {
        model.update(subscriptionActive: valid);
        initializedAds();
      }
      return;
    }
    model.update(loading: true);
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
    model.update(loading: false);
  }

  void initializedAds() {
    controller<AdmobController>().initialize();
  }
}
