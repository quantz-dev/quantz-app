import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:momentum/momentum.dart';

import '../../core/index.dart';
import 'index.dart';

AdmobController admobCtrl(BuildContext context) => Momentum.controller<AdmobController>(context);

class AdmobController extends MomentumController<AdmobModel> {
  @override
  AdmobModel init() {
    return AdmobModel(
      this,
      animeListAd: generateBannerAd(AD_UNIT_ANIMELIST, showAnimeListAd),
      showAnimeListAd: false,
      newsTabAd: generateBannerAd(AD_UNIT_NEWS, showNewsTabAd),
      showNewsTabAd: false,
    );
  }

  void disposeAnimeListAd() async {
    model.update(showAnimeListAd: false);
    await model.animeListAd.dispose();
  }

  void disposeNewsTabAd() async {
    model.update(showNewsTabAd: false);
    await model.newsTabAd.dispose();
  }

  void loadAnimeListAd() async {
    model.update(showAnimeListAd: false);
    await model.animeListAd.load();
  }

  void loadNewsTabAd() async {
    model.update(showNewsTabAd: false);
    await model.newsTabAd.load();
  }

  void showAnimeListAd() {
    model.update(showAnimeListAd: true);
  }

  void showNewsTabAd() {
    model.update(showNewsTabAd: true);
  }

  BannerAd generateBannerAd(String adUnitId, void Function() callback) {
    return BannerAd(
      adUnitId: adUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          callback();
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
  }
}
