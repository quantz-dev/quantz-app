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
  bool get ready => model.initialized;

  /// - `0` = Library Tab
  /// - `1` = Feed Tab
  /// - `2` = Sources Tab
  /// - `3` = More Tab *(no ad here)*
  int lastActiveTab = -1;

  Future<void> initialize() async {
    print(['QUANTZ', 'AdmobController.initialize()', 'subscribed = $subscribed']);
    if (subscribed) {
      model.update(initialized: false);
    } else {
      // initialize Ads if user is not subscribed as Supporter.
      final status = await MobileAds.instance.initialize();
      print(status.adapterStatuses);
      model.update(initialized: true);
      loadAdForActiveTab();
    }
  }

  void loadAdForActiveTab() {
    print(['QUANTZ', 'loadAdForActiveTab() : $lastActiveTab']);
    switch (lastActiveTab) {
      case 0:
        loadLibraryTabAd();
        break;
      case 1:
        loadFeedTabAd();
        break;
      case 2:
        loadSourcesTabAd();
        break;
      default:
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

  void loadLibraryTabAd() async {
    lastActiveTab = 0;
    if (!ready) return;
    model.update(showLibraryTabAd: false);
    print(['QUANTZ', 'loadLibraryTabAd()']);
    await model.libraryTabAd.load();
  }

  void loadFeedTabAd() async {
    lastActiveTab = 1;
    if (!ready) return;
    model.update(showFeedTabAd: false);
    print(['QUANTZ', 'loadFeedTabAd()']);
    await model.feedTabAd.load();
  }

  void loadSourcesTabAd() async {
    lastActiveTab = 2;
    if (!ready) return;
    model.update(showSourcesTabAd: false);
    print(['QUANTZ', 'loadSourcesTabAd()']);
    await model.sourcesTabAd.load();
  }

  void showLibraryTabAd() {
    if (!ready) return;
    model.update(showLibraryTabAd: true);
  }

  void showFeedTabAd() {
    if (!ready) return;
    model.update(showFeedTabAd: true);
  }

  void showSourcesTabAd() {
    if (!ready) return;
    model.update(showSourcesTabAd: true);
  }

  BannerAd generateBannerAd(String adUnitId, void Function() callback) {
    return BannerAd(
      adUnitId: adUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          print(['QUANTZ', 'onAdLoaded() : $adUnitId']);
          callback();
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
  }
}
