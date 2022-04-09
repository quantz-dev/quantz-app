import 'package:momentum/momentum.dart';

import '../../data/feed.response.dart';
import 'index.dart';

class FeedModel extends MomentumModel<FeedController> {
  FeedModel(
    FeedController controller, {
    required this.feed,
    required this.loading,
  }) : super(controller);

  final QuantzFeed feed;
  final bool loading;

  @override
  void update({
    QuantzFeed? feed,
    bool? loading,
  }) {
    FeedModel(
      controller,
      feed: feed ?? this.feed,
      loading: loading ?? this.loading,
    ).updateMomentum();
  }

  Map<String, dynamic> toJson() {
    return {
      "feed": feed.toJson(),
      "loading": false,
    };
  }

  FeedModel? fromJson(Map<String, dynamic>? map) {
    if (map == null) return null;

    return FeedModel(
      controller,
      feed: QuantzFeed.fromJson(map['feed']),
      loading: false,
    );
  }
}
