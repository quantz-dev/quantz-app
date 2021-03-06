import 'package:momentum/momentum.dart';

import '../../data/index.dart';
import '../../services/interface/google-api.interface.dart';
import 'index.dart';

class TopicController extends MomentumController<TopicModel> {
  @override
  TopicModel init() {
    return TopicModel(
      this,
      loading: false,
      firebaseSubscription: FirebaseSubscription(),
    );
  }

  Future<FirebaseSubscription> loadSubscription() async {
    final api = service<GoogleApiInterface>(runtimeType: false);
    model.update(loading: true);
    var firebaseSubscription = await api.getFirebaseSubscription();
    model.update(loading: false, firebaseSubscription: firebaseSubscription);
    return firebaseSubscription;
  }
}
