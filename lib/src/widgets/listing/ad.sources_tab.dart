import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:momentum/momentum.dart';

import '../../components/admob/index.dart';
import '../../components/supporter-subscription/index.dart';

class AdSourcesTab extends StatefulWidget {
  AdSourcesTab({Key? key}) : super(key: key);

  @override
  _AdSourcesTabState createState() => _AdSourcesTabState();
}

class _AdSourcesTabState extends State<AdSourcesTab> {
  AdmobController? _admobController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _admobController = admobCtrl(context)..loadSourcesTabAd();
  }

  @override
  void dispose() {
    super.dispose();
    _admobController?.disposeSourcesTabAd();
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
        if (!admob.showSourcesTabAd) {
          return SizedBox();
        } else {
          return SizedBox(
            height: 50,
            child: AdWidget(
              ad: admob.sourcesTabAd,
            ),
          );
        }
      },
    );
  }
}
