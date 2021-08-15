import 'package:momentum/momentum.dart';

import 'index.dart';

class SourcesModel extends MomentumModel<SourcesController> {
  SourcesModel(
    SourcesController controller, {
    required this.initialized,
    required this.loading,
    required this.sourcesSubscriptionList,
  }) : super(controller);

  final bool initialized;
  final bool loading;
  final List<NewsSource> sourcesSubscriptionList;

  @override
  void update({
    bool? initialized,
    bool? loading,
    List<NewsSource>? sourcesSubscriptionList,
  }) {
    SourcesModel(
      controller,
      initialized: initialized ?? this.initialized,
      loading: loading ?? this.loading,
      sourcesSubscriptionList: sourcesSubscriptionList ?? this.sourcesSubscriptionList,
    ).updateMomentum();
  }

  Map<String, dynamic> toJson() {
    return {
      'initialized': initialized,
      'sourcesSubscriptionList': sourcesSubscriptionList.map((x) => x.toMap()).toList(),
    };
  }

  SourcesModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return SourcesModel(
      controller,
      initialized: json['initialized'],
      loading: false,
      sourcesSubscriptionList: List<NewsSource>.from(json['sourcesSubscriptionList']?.map((x) => NewsSource.fromMap(x))),
    );
  }
}
