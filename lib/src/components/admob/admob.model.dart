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
  }) : super(controller);

  final bool initialized;

  final BannerAd libraryTabAd;
  final bool showLibraryTabAd;

  final BannerAd sourcesTabAd;
  final bool showSourcesTabAd;

  final BannerAd feedTabAd;
  final bool showFeedTabAd;

  @override
  void update({
    bool? initialized,
    BannerAd? libraryTabAd,
    bool? showLibraryTabAd,
    BannerAd? sourcesTabAd,
    bool? showSourcesTabAd,
    BannerAd? feedTabAd,
    bool? showFeedTabAd,
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
    ).updateMomentum();
  }
}
