import 'package:flutter/material.dart';
import 'package:momentum/momentum.dart';

import '../../../components/supporter-subscription/index.dart';
import '../../index.dart';
import '../../listing/index.dart';

class SupportTheDeveloper extends StatelessWidget {
  const SupportTheDeveloper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MomentumBuilder(
      controllers: [SupporterSubscriptionController],
      builder: (context, snapshot) {
        var subscription = snapshot<SupporterSubscriptionModel>();
        final isActive = subscription.subscriptionActive;

        if (subscription.loading) {
          return MenuListItem(
            icon: Icons.attach_money,
            titleWidget: LinearProgressIndicator(),
            subtitle: 'Processing purchase ...',
          );
        }

        return MenuListItem(
          title: 'Support the developer',
          subtitle: 'Donate \$1.00 monthly and remove ads.',
          icon: Icons.attach_money,
          trail: Text(
            !isActive ? 'Donate' : 'Active',
            style: TextStyle(
              color: primary,
            ),
          ),
          onTap: () async {
            subscription.controller.getSupporterSubscription();
          },
        );
      },
    );
  }
}
