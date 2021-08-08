import 'package:momentum/momentum.dart';

import '../../data/index.dart';
import 'index.dart';

class TopicModel extends MomentumModel<TopicController> {
  TopicModel(
    TopicController controller, {
    required this.loading,
    required this.firebaseSubscription,
  }) : super(controller);

  final bool loading;
  final FirebaseSubscription firebaseSubscription;

  @override
  void update({
    bool? loading,
    FirebaseSubscription? firebaseSubscription,
  }) {
    TopicModel(
      controller,
      loading: loading ?? this.loading,
      firebaseSubscription: firebaseSubscription ?? this.firebaseSubscription,
    ).updateMomentum();
  }
}
