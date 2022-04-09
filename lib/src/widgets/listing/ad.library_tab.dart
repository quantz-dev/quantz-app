import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:momentum/momentum.dart';

import '../../components/admob/index.dart';
import '../../components/supporter-subscription/index.dart';

class AdLibraryTab extends StatefulWidget {
  AdLibraryTab({Key? key}) : super(key: key);

  @override
  _AdLibraryTabState createState() => _AdLibraryTabState();
}

class _AdLibraryTabState extends State<AdLibraryTab> {
  AdmobController? _admobController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _admobController = admobCtrl(context)..loadLibraryTabAd();
  }

  @override
  void dispose() {
    super.dispose();
    _admobController?.disposeLibraryAd();
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
        if (!admob.showLibraryTabAd) {
          return SizedBox();
        } else {
          return SizedBox(
            height: 50,
            child: AdWidget(
              ad: admob.libraryTabAd,
            ),
          );
        }
      },
    );
  }
}
