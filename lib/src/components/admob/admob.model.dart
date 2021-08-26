import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:momentum/momentum.dart';

import 'index.dart';

class AdmobModel extends MomentumModel<AdmobController> {
  AdmobModel(
    AdmobController controller, {
    required this.initialized,
    required this.libraryTabAd,
    required this.showLibraryTabAd,
    required this.sourcesTabAd,
    required this.showSourcesTabAd,
    required this.feedTabAd,
    required this.showFeedTabAd,
    required this.lastTimeUserClickedAnAd,
  }) : super(controller);

  final bool initialized;

  final BannerAd libraryTabAd;
  final bool showLibraryTabAd;

  final BannerAd sourcesTabAd;
  final bool showSourcesTabAd;

  final BannerAd feedTabAd;
  final bool showFeedTabAd;

  final int lastTimeUserClickedAnAd;

  @override
  void update({
    bool? initialized,
    BannerAd? libraryTabAd,
    bool? showLibraryTabAd,
    BannerAd? sourcesTabAd,
    bool? showSourcesTabAd,
    BannerAd? feedTabAd,
    bool? showFeedTabAd,
    int? lastTimeUserClickedAnAd,
  }) {
    AdmobModel(
      controller,
      initialized: initialized ?? this.initialized,
      libraryTabAd: libraryTabAd ?? this.libraryTabAd,
      showLibraryTabAd: showLibraryTabAd ?? this.showLibraryTabAd,
      sourcesTabAd: sourcesTabAd ?? this.sourcesTabAd,
      showSourcesTabAd: showSourcesTabAd ?? this.showSourcesTabAd,
      feedTabAd: feedTabAd ?? this.feedTabAd,
      showFeedTabAd: showFeedTabAd ?? this.showFeedTabAd,
      lastTimeUserClickedAnAd: lastTimeUserClickedAnAd ?? this.lastTimeUserClickedAnAd,
    ).updateMomentum();
  }

  Map<String, dynamic> toJson() {
    return {
      "lastTimeUserClickedAnAd": lastTimeUserClickedAnAd,
    };
  }

  AdmobModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return AdmobModel(
      controller,
      initialized: initialized,
      libraryTabAd: libraryTabAd,
      showLibraryTabAd: showLibraryTabAd,
      sourcesTabAd: sourcesTabAd,
      showSourcesTabAd: showSourcesTabAd,
      feedTabAd: feedTabAd,
      showFeedTabAd: showFeedTabAd,
      lastTimeUserClickedAnAd: json['lastTimeUserClickedAnAd'] ?? 0,
    );
  }
}
