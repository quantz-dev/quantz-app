import 'package:momentum/momentum.dart';

import 'index.dart';

class SupporterSubscriptionModel extends MomentumModel<SupporterSubscriptionController> {
  SupporterSubscriptionModel(
    SupporterSubscriptionController controller, {
    required this.loading,
    required this.purchaseIsPending,
    required this.purchaseError,
    required this.subscriptionActive,
    required this.storeIsAvailable,
  }) : super(controller);

  final bool loading;
  final bool purchaseIsPending;
  final String purchaseError;
  final bool subscriptionActive;
  final bool storeIsAvailable;

  @override
  void update({
    bool? loading,
    bool? purchaseIsPending,
    String? purchaseError,
    bool? subscriptionActive,
    bool? storeIsAvailable,
  }) {
    SupporterSubscriptionModel(
      controller,
      loading: loading ?? this.loading,
      purchaseIsPending: purchaseIsPending ?? this.purchaseIsPending,
      purchaseError: purchaseError ?? this.purchaseError,
      subscriptionActive: subscriptionActive ?? this.subscriptionActive,
      storeIsAvailable: storeIsAvailable ?? this.storeIsAvailable,
    ).updateMomentum();
  }
}
