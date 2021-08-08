import 'package:momentum/momentum.dart';

import 'index.dart';

class NotificationModel extends MomentumModel<NotificationController> {
  NotificationModel(
    NotificationController controller, {
    required this.loading,
    required this.permalinks,
  }) : super(controller);

  final bool loading;
  final List<String> permalinks;

  @override
  void update({
    bool? loading,
    List<String>? permalinks,
  }) {
    NotificationModel(
      controller,
      loading: loading ?? this.loading,
      permalinks: permalinks ?? this.permalinks,
    ).updateMomentum();
  }

  Map<String, dynamic> toJson() {
    return {
      'permalinks': permalinks,
    };
  }

  NotificationModel? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;

    return NotificationModel(
      controller,
      loading: false,
      permalinks: List<String>.from(json['permalinks']),
    );
  }
}
