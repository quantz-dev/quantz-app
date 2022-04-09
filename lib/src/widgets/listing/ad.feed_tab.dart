import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:momentum/momentum.dart';

import '../../components/admob/index.dart';
import '../../components/supporter-subscription/index.dart';

class AdFeedTab extends StatefulWidget {
  AdFeedTab({Key? key}) : super(key: key);

  @override
  _AdFeedTabState createState() => _AdFeedTabState();
}

class _AdFeedTabState extends State<AdFeedTab> {
  AdmobController? _admobController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _admobController = admobCtrl(context)..loadFeedTabAd();
  }

  @override
  void dispose() {
    super.dispose();
    _admobController?.disposeFeedTabAd();
  }

  @override
  Widget build(BuildContext context) {
    return MomentumBuilder(
      controllers: [
        AdmobController,
        SupporterSubscriptionController,
      ],
      builder: (context, snapshot) {
        final admob = snapshot<AdmobModel>();
        if (!admob.showFeedTabAd) {
          return SizedBox();
        } else {
          return SizedBox(
            height: 50,
            child: AdWidget(
              ad: admob.feedTabAd,
            ),
          );
        }
      },
    );
  }
}
