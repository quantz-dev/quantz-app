import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:momentum/momentum.dart';

import '../../core/index.dart';
import '../supporter-subscription/index.dart';
import 'index.dart';

AdmobController admobCtrl(BuildContext context) => Momentum.controller<AdmobController>(context);

class AdmobController extends MomentumController<AdmobModel> {
  @override
  AdmobModel init() {
    return AdmobModel(
      this,
      initialized: false,
      libraryTabAd: generateBannerAd(AD_UNIT_LIBRARY, showLibraryTabAd),
      showLibraryTabAd: false,
      sourcesTabAd: generateBannerAd(AD_UNIT_SOURCES, showSourcesTabAd),
      showSourcesTabAd: false,
      feedTabAd: generateBannerAd(AD_UNIT_FEED, showFeedTabAd),
      showFeedTabAd: false,
    );
  }

  bool get subscribed => controller<SupporterSubscriptionController>().model.subscriptionActive;
  bool get ready => model.initialized && !subscribed;

  bootstrap() {
    initialize();
  }

  Future<void> initialize() async {
    if (!subscribed) {
      // initialize Ads if user is not subscribed as Supporter.
      final status = await MobileAds.instance.initialize();
      print(status.adapterStatuses);
      model.update(initialized: true);
    }
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
    if (!ready) return;
    model.update(showLibraryTabAd: false);
    await model.libraryTabAd.load();
  }

  void loadSourcesTabAd() async {
    model.update(showSourcesTabAd: false);
    await model.sourcesTabAd.load();
  }

  void loadFeedTabAd() async {
    if (!ready) return;
    model.update(showFeedTabAd: false);
    await model.feedTabAd.load();
  }

  void showLibraryTabAd() {
    if (!ready) return;
    model.update(showLibraryTabAd: true);
  }

  void showSourcesTabAd() {
    if (!ready) return;
    model.update(showSourcesTabAd: true);
  }

  void showFeedTabAd() {
    if (!ready) return;
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
