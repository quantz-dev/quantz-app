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
  String get emailObscure {
    final e = profile.email;
    if (e.isNotEmpty) {
      final username = e.substring(0, e.indexOf('@'));
      final domain = e.replaceAll('$username@', '');
      final firstLetter = username[0];
      final lastLetter = username[username.length - 1];
      return '$firstLetter********$lastLetter@$domain';
    }
    return '';
  }

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
