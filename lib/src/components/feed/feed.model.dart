import 'package:momentum/momentum.dart';

import '../../data/feed/feed.interface.dart';
import 'index.dart';

class FeedModel extends MomentumModel<FeedController> {
  FeedModel(
    FeedController controller, {
    required this.feedItems,
    required this.loading,
  }) : super(controller);

  final List<FeedItem> feedItems;
  final bool loading;

  @override
  void update({
    List<FeedItem>? feedItems,
    bool? loading,
  }) {
    FeedModel(
      controller,
      feedItems: feedItems ?? this.feedItems,
      loading: loading ?? this.loading,
    ).updateMomentum();
  }
}
