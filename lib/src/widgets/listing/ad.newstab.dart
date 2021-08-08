import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:momentum/momentum.dart';

import '../../components/admob/index.dart';

class AdNewsTab extends StatefulWidget {
  AdNewsTab({Key? key}) : super(key: key);

  @override
  _AdNewsTabState createState() => _AdNewsTabState();
}

class _AdNewsTabState extends State<AdNewsTab> {
  AdmobController? _admobController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _admobController = admobCtrl(context)..loadNewsTabAd();
  }

  @override
  void dispose() {
    super.dispose();
    _admobController?.disposeNewsTabAd();
  }

  @override
  Widget build(BuildContext context) {
    return MomentumBuilder(
      controllers: [AdmobController],
      builder: (context, snapshot) {
        final admob = snapshot<AdmobModel>();
        if (!admob.showNewsTabAd) {
          return SizedBox();
        } else {
          return SizedBox(
            height: 50,
            child: AdWidget(
              ad: admob.newsTabAd,
            ),
          );
        }
      },
    );
  }
}
