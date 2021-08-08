import 'package:momentum/momentum.dart';

import '../../data/index.dart';
import 'index.dart';

class CloudBackupModel extends MomentumModel<CloudBackupController> {
  CloudBackupModel(
    CloudBackupController controller, {
    required this.token,
    required this.profile,
    required this.latestBackupInfo,
    this.lastRestore,
  }) : super(controller);

  final String token;
  final JwtTokenProfile profile;
  final CloudBackup latestBackupInfo;
  final DateTime? lastRestore;

  bool get signedIn => profile.picture.isNotEmpty;
  bool get hasLatestBackup => latestBackupInfo.updatedAt != null;
  bool get hasLastRestored => lastRestore != null;

  @override
  void update({
    String? token,
    JwtTokenProfile? profile,
    CloudBackup? latestBackupInfo,
    DateTime? lastRestore,
  }) {
    CloudBackupModel(
      controller,
      token: token ?? this.token,
      profile: profile ?? this.profile,
      latestBackupInfo: latestBackupInfo ?? this.latestBackupInfo,
      lastRestore: lastRestore ?? this.lastRestore,
    ).updateMomentum();
  }

  void modifyLastRestore({
    DateTime? lastRestore,
  }) {
    CloudBackupModel(
      controller,
      token: this.token,
      profile: this.profile,
      latestBackupInfo: this.latestBackupInfo,
      lastRestore: lastRestore,
    ).updateMomentum();
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'lastRestore': lastRestore?.millisecondsSinceEpoch,
    };
  }

  CloudBackupModel? fromJson(Map<String, dynamic>? map) {
    if (map == null) return null;
    return CloudBackupModel(
      controller,
      token: map['token'],
      profile: JwtTokenProfile(),
      latestBackupInfo: CloudBackup(),
      lastRestore: map['lastRestore'] == null ? null : DateTime.fromMillisecondsSinceEpoch(map['lastRestore']),
    );
  }
}
