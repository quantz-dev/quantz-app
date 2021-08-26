import 'dart:convert';

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
      lastTimeUserClickedAnAd: 0,
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
    await loadAd(model.libraryTabAd);
  }

  void loadFeedTabAd() async {
    lastActiveTab = 1;
    if (!ready) return;
    model.update(showFeedTabAd: false);
    print(['QUANTZ', 'loadFeedTabAd()']);
    await loadAd(model.feedTabAd);
  }

  void loadSourcesTabAd() async {
    lastActiveTab = 2;
    if (!ready) return;
    model.update(showSourcesTabAd: false);
    print(['QUANTZ', 'loadSourcesTabAd()']);
    await loadAd(model.sourcesTabAd);
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

  /// When an Ad is clicked, only show next Ads in 30 minutes.
  ///
  /// This is to prevent users from abusing Ad clicks.
  Future<void> loadAd(BannerAd ad) async {
    if (model.lastTimeUserClickedAnAd <= 0) {
      await ad.load();
    } else {
      final diffSeconds = (DateTime.now().millisecondsSinceEpoch - model.lastTimeUserClickedAnAd) ~/ 1000; // seconds
      final diffMinutes = diffSeconds ~/ 60; // minutes
      print(['QUANTZ', 'loadAd(..)', 'diffMinutes = $diffMinutes']);
      if (diffMinutes <= 30) {
        // don't load any Ad to avoid invalid traffic.
        return;
      } else {
        await ad.load();
      }
    }
  }

  void hideAllAd() {
    model.update(
      showFeedTabAd: false,
      showLibraryTabAd: false,
      showSourcesTabAd: false,
    );
  }

  BannerAd generateBannerAd(String adUnitId, void Function() callback) {
    return BannerAd(
      adUnitId: adUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          print(['QUANTZ', 'onAdLoaded()']);
          callback();
        },
        onAdFailedToLoad: (ad, error) {
          final errorJson = {
            "code": error.code,
            "domain": error.domain,
            "message": error.message,
            "responseId": error.responseInfo?.responseId,
            "mediationAdapterClassName": error.responseInfo?.mediationAdapterClassName,
          };
          final adJson = {
            "responseId": ad.responseInfo?.responseId,
            "mediationAdapterClassName": ad.responseInfo?.mediationAdapterClassName,
          };
          print(['QUANTZ', 'onAdFailedToLoad()', jsonEncode(errorJson), jsonEncode(adJson)]);
          ad.dispose();
        },
        onAdOpened: (ad) async {
          // this gets executed when a banner ad is clicked.
          print(['QUANTZ', 'onAdOpened()']);
          model.update(lastTimeUserClickedAnAd: DateTime.now().millisecondsSinceEpoch);
          hideAllAd();
          await ad.dispose();
        },
        onAdWillDismissScreen: (ad) {
          print(['QUANTZ', 'onAdWillDismissScreen()']);
        },
        onAdImpression: (ad) {
          print(['QUANTZ', 'onAdImpression()']);
        },
      ),
    );
  }
}
