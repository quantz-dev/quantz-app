import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:momentum/momentum.dart';

import '../../components/admob/index.dart';

class AdAnimeList extends StatefulWidget {
  AdAnimeList({Key? key}) : super(key: key);

  @override
  _AdAnimeListState createState() => _AdAnimeListState();
}

class _AdAnimeListState extends State<AdAnimeList> {
  AdmobController? _admobController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _admobController = admobCtrl(context)..loadAnimeListAd();
  }

  @override
  void dispose() {
    super.dispose();
    _admobController?.disposeAnimeListAd();
  }

  @override
  Widget build(BuildContext context) {
    return MomentumBuilder(
      controllers: [AdmobController],
      builder: (context, snapshot) {
        final admob = snapshot<AdmobModel>();
        if (!admob.showAnimeListAd) {
          return SizedBox();
        } else {
          return SizedBox(
            height: 50,
            child: AdWidget(
              ad: admob.animeListAd,
            ),
          );
        }
      },
    );
  }
}
