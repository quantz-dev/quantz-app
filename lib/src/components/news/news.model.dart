import 'package:momentum/momentum.dart';

import 'index.dart';

class NewsModel extends MomentumModel<NewsController> {
  NewsModel(
    NewsController controller, {
    required this.initialized,
    required this.loading,
    required this.newsSubscriptionList,
  }) : super(controller);

  final bool initialized;
  final bool loading;
  final List<NewsSource> newsSubscriptionList;

  @override
  void update({
    bool? initialized,
    bool? loading,
    List<NewsSource>? newsSubscriptionList,
  }) {
    NewsModel(
      controller,
      initialized: initialized ?? this.initialized,
      loading: loading ?? this.loading,
      newsSubscriptionList: newsSubscriptionList ?? this.newsSubscriptionList,
    ).updateMomentum();
  }

  Map<String, dynamic> toJson() {
    return {
      'initialized': initialized,
      'newsSubscriptionList': newsSubscriptionList.map((x) => x.toMap()).toList(),
    };
  }

  NewsModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return NewsModel(
      controller,
      initialized: json['initialized'],
      loading: false,
      newsSubscriptionList: List<NewsSource>.from(json['newsSubscriptionList']?.map((x) => NewsSource.fromMap(x))),
    );
  }
}
