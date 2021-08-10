import 'package:momentum/momentum.dart';

import '../../data/feed/feed.interface.dart';
import '../../services/api.service.dart';
import 'index.dart';

class FeedController extends MomentumController<FeedModel> {
  @override
  FeedModel init() {
    return FeedModel(
      this,
      feedItems: [],
      loading: false,
    );
  }

  ApiService get api => service<ApiService>();

  void bootstrap() async {
    model.update(loading: true);
    final feedItems = <FeedItem>[];

    final animeNewsNetworkFeed = await api.getAnnLatest();
    final livechartFeed = await api.getLivechartLatest();
    final myanimelistFeed = await api.getMyAnimeListLatest();
    final ranimeFeed = await api.getRAnimeLatest();

    feedItems.addAll(animeNewsNetworkFeed);
    feedItems.addAll(livechartFeed);
    feedItems.addAll(myanimelistFeed);
    feedItems.addAll(ranimeFeed);
    feedItems.sort((a, b) => b.utcTimestampSeconds.compareTo(a.utcTimestampSeconds));

    model.update(feedItems: feedItems, loading: false);
  }
}
