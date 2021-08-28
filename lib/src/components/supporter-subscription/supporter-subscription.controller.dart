import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
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

  FirebaseMessaging get messaging => FirebaseMessaging.instance;

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

    // need to deactivate the reward everything the app gets opened
    // it will be activated when the plugin detects the user has active subscription.
    await deactivateReward();

    await google.restorePurchases();
  }

  void _checkPurchaseUpdated(PurchaseDetails purchaseDetails) async {
    print(['QUANTZ', '_checkPurchaseUpdated($purchaseDetails)']);
    model.update(loading: true);
    final status = await google.processPurchaseUpdated(purchaseDetails);
    print(['QUANTZ', '_checkPurchaseUpdated($purchaseDetails)', status]);
    switch (status) {
      case UpdatedPurchaseStatus.none:
        break;
      case UpdatedPurchaseStatus.purchaseIsPending:
        model.update(purchaseIsPending: true);
        break;
      case UpdatedPurchaseStatus.subscriptionValid:
        model.update(subscriptionActive: true, purchaseIsPending: false);
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
    switch (status) {
      case UpdatedPurchaseStatus.subscriptionValid:
        await activateReward();
        break;
      default:
        await deactivateReward();
        break;
    }
    initializedAds();
    model.update(loading: false);
  }

  Future<void> checkStore() async {
    model.update(loading: true);
    final bool available = await google.checkStore();
    print(['QUANTZ', 'checkStore()', 'available = $available']);
    model.update(storeIsAvailable: available, loading: false);
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
        await activateReward();
        model.update(subscriptionActive: valid);
        initializedAds();
      } else {
        await deactivateReward();
      }
    }
    model.update(loading: false);
  }

  void initializedAds() {
    print(['QUANTZ', 'initializedAds()']);
    controller<GoogleFlowController>().initializeAdmob();
  }

  Future<void> activateReward() async {
    print(['QUANTZ', 'activateReward()']);
    await messaging.subscribeToTopic('dev_supporter');
  }

  Future<void> deactivateReward() async {
    print(['QUANTZ', 'deactivateReward()']);
    await messaging.unsubscribeFromTopic('dev_supporter');
  }
}
