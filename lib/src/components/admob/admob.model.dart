import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:momentum/momentum.dart';

import 'index.dart';

class AdmobModel extends MomentumModel<AdmobController> {
  AdmobModel(
    AdmobController controller, {
    required this.animeListAd,
    required this.showAnimeListAd,
    required this.newsTabAd,
    required this.showNewsTabAd,
  }) : super(controller);

  final BannerAd animeListAd;
  final bool showAnimeListAd;

  final BannerAd newsTabAd;
  final bool showNewsTabAd;

  @override
  void update({
    BannerAd? animeListAd,
    bool? showAnimeListAd,
    BannerAd? newsTabAd,
    bool? showNewsTabAd,
  }) {
    AdmobModel(
      controller,
      animeListAd: animeListAd ?? this.animeListAd,
      showAnimeListAd: showAnimeListAd ?? this.showAnimeListAd,
      newsTabAd: newsTabAd ?? this.newsTabAd,
      showNewsTabAd: showNewsTabAd ?? this.showNewsTabAd,
    ).updateMomentum();
  }
}
