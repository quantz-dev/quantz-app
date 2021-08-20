import 'package:momentum/momentum.dart';
import '../../services/interface/api.interface.dart';

import '../../data/feed.response.dart';
import 'index.dart';

class FeedController extends MomentumController<FeedModel> {
  @override
  FeedModel init() {
    return FeedModel(
      this,
      feed: QuantzFeed(),
      loading: false,
    );
  }

  ApiInterface get api => service<ApiInterface>(runtimeType: false);

  void bootstrap() async {
    loadInitial();
  }

  Future<void> loadInitial({bool refresh = false}) async {
    if (!refresh) model.update(loading: true);

    final feed = await api.getLatestFeed();
    var feedItems = feed.items;
    if (feedItems.isNotEmpty) {
      feedItems.sort((a, b) => b.utcTimestampSeconds.compareTo(a.utcTimestampSeconds));
      model.update(feed: feed.copyWith(items: feedItems), loading: false);
    } else {
      model.update(loading: false);
    }
  }

  Future<void> loadMore() async {
    final feed = await api.getLatestFeed(page: model.feed.page + 1);
    var feedItems = List<QuantzFeedItem>.from(model.feed.items)..addAll(feed.items);
    if (feedItems.isNotEmpty) {
      feedItems = feedItems.toSet().toList();
      feedItems.sort((a, b) => b.utcTimestampSeconds.compareTo(a.utcTimestampSeconds));
      model.update(feed: feed.copyWith(items: feedItems));
    }
  }
}
