import 'package:momentum/momentum.dart';

import 'index.dart';

class FilterModel extends MomentumModel<FilterController> {
  FilterModel(
    FilterController controller, {
    required this.displayTitle,
    required this.sortBy,
    required this.orderBy,
    required this.showOngoing,
    required this.showUpcoming,
  }) : super(controller);

  final DisplayTitle displayTitle;
  final SortBy sortBy;
  final OrderBy orderBy;

  final bool showOngoing;
  final bool showUpcoming;

  @override
  void update({
    DisplayTitle? displayTitle,
    SortBy? sortBy,
    OrderBy? orderBy,
    bool? showOngoing,
    bool? showUpcoming,
  }) {
    FilterModel(
      controller,
      displayTitle: displayTitle ?? this.displayTitle,
      sortBy: sortBy ?? this.sortBy,
      orderBy: orderBy ?? this.orderBy,
      showOngoing: showOngoing ?? this.showOngoing,
      showUpcoming: showUpcoming ?? this.showUpcoming,
    ).updateMomentum();
  }

  Map<String, dynamic> toJson() {
    return {
      'displayTitle': DisplayTitle.values.indexOf(displayTitle),
      'sortBy': SortBy.values.indexOf(SortBy.desc),
      'orderBy': OrderBy.values.indexOf(OrderBy.episodeRelease),
      'showOngoing': true,
      'showUpcoming': true,
    };
  }

  FilterModel? fromJson(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    return FilterModel(
      controller,
      displayTitle: DisplayTitle.values[map['displayTitle']],
      sortBy: SortBy.values[map['sortBy']],
      orderBy: OrderBy.values[map['orderBy']],
      showOngoing: true,
      showUpcoming: true,
    );
  }
}
