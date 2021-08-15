import 'package:momentum/momentum.dart';

import '../../data/index.dart';
import 'index.dart';

class GoogleFlowModel extends MomentumModel<GoogleFlowController> {
  GoogleFlowModel(
    GoogleFlowController controller, {
    required this.token,
    required this.profile,
  }) : super(controller);

  final String token;
  final JwtTokenProfile profile;

  bool get signedIn => token.isNotEmpty;

  @override
  void update({
    String? token,
    JwtTokenProfile? profile,
  }) {
    GoogleFlowModel(
      controller,
      token: token ?? this.token,
      profile: profile ?? this.profile,
    ).updateMomentum();
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
    };
  }

  GoogleFlowModel? fromJson(Map<String, dynamic>? map) {
    if (map == null) return null;
    return GoogleFlowModel(
      controller,
      token: map['token'],
      profile: JwtTokenProfile(),
    );
  }
}
