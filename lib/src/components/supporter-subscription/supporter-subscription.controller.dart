import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:momentum/momentum.dart';

import '../../core/in-app-purchase.dart';
import '../../services/interface/api.interface.dart';
import '../../services/interface/google-api.interface.dart';
import '../../widgets/index.dart';
import '../cloud-backup/index.dart';
import '../google-flow/google-flow.controller.dart';
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

  ApiInterface get api => service<ApiInterface>(runtimeType: false);
  GoogleApiInterface get google => service<GoogleApiInterface>(runtimeType: false);

  CloudBackupController get cloudController => controller<CloudBackupController>();

  // ignore: cancel_subscriptions
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  Future<void> initialize() async {
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

    await google.restorePurchases();
  }

  void _checkPurchaseUpdated(PurchaseDetails purchaseDetails) async {
    final status = await google.processPurchaseUpdated(purchaseDetails);
    switch (status) {
      case UpdatedPurchaseStatus.none:
        break;
      case UpdatedPurchaseStatus.purchaseIsPending:
        model.update(purchaseIsPending: true);
        break;
      case UpdatedPurchaseStatus.subscriptionValid:
        model.update(subscriptionActive: true);
        break;
      case UpdatedPurchaseStatus.subscriptionInvalid:
        model.update(subscriptionActive: false);
        break;
      case UpdatedPurchaseStatus.purchaseDetailsError:
        model.update(subscriptionActive: false, purchaseIsPending: false);
        break;
      case UpdatedPurchaseStatus.completingPurchaseError:
        model.update(subscriptionActive: false);
        break;
    }
    initializedAds();
  }

  Future<void> checkStore() async {
    final bool available = await google.checkStore();
    model.update(storeIsAvailable: available);
  }

  /// This is currently called when `Support the developer` button is clicked.
  Future<void> getSupporterSubscription() async {
    if (model.subscriptionActive) {
      showToast('You are already supporting the developer.');
      return;
    }
    model.update(loading: true);
    if (google.pendingPurchase == null) {
      await google.getSupporterSubscription();
    } else if (google.pendingPurchase != null) {
      final valid = await google.isPurchaseValid(google.pendingPurchase!);
      if (valid) {
        model.update(subscriptionActive: valid);
        initializedAds();
      }
    }
    model.update(loading: false);
  }

  void initializedAds() {
    controller<GoogleFlowController>().initializeAdmob();
  }
}
