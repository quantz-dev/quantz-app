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
      libraryTabAd: generateBannerAd(AD_UNIT_LIBRARY, showLibraryTabAd),
      showLibraryTabAd: false,
      sourcesTabAd: generateBannerAd(AD_UNIT_SOURCES, showSourcesTabAd),
      showSourcesTabAd: false,
      feedTabAd: generateBannerAd(AD_UNIT_FEED, showFeedTabAd),
      showFeedTabAd: false,
    );
  }

  void disposeLibraryAd() async {
    model.update(showLibraryTabAd: false);
    await model.libraryTabAd.dispose();
  }

  void disposeSourcesTabAd() async {
    model.update(showSourcesTabAd: false);
    await model.sourcesTabAd.dispose();
  }

  void disposeFeedTabAd() async {
    model.update(showFeedTabAd: false);
    await model.feedTabAd.dispose();
  }

  void loaLibraryTabAd() async {
    model.update(showLibraryTabAd: false);
    await model.libraryTabAd.load();
  }

  void loadSourcesTabAd() async {
    model.update(showSourcesTabAd: false);
    await model.sourcesTabAd.load();
  }

  void loadFeedTabAd() async {
    model.update(showFeedTabAd: false);
    await model.feedTabAd.load();
  }

  void showLibraryTabAd() {
    model.update(showLibraryTabAd: true);
  }

  void showSourcesTabAd() {
    model.update(showSourcesTabAd: true);
  }

  void showFeedTabAd() {
    model.update(showFeedTabAd: true);
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
