import 'package:momentum/momentum.dart';
import 'package:quantz/src/components/google-flow/google-flow.controller.dart';

import '../../data/index.dart';
import 'index.dart';

class CloudBackupModel extends MomentumModel<CloudBackupController> {
  CloudBackupModel(
    CloudBackupController controller, {
    required this.latestBackupInfo,
    required this.loading,
    this.lastRestore,
  }) : super(controller);

  final CloudBackup latestBackupInfo;
  final DateTime? lastRestore;
  final bool loading;

  bool get hasLatestBackup => latestBackupInfo.updatedAt != null;
  bool get hasLastRestored => lastRestore != null;

  bool get signedIn => controller.controller<GoogleFlowController>().model.signedIn;
  String get token => controller.controller<GoogleFlowController>().model.token;

  @override
  void update({
    CloudBackup? latestBackupInfo,
    DateTime? lastRestore,
    bool? loading,
  }) {
    CloudBackupModel(
      controller,
      latestBackupInfo: latestBackupInfo ?? this.latestBackupInfo,
      lastRestore: lastRestore ?? this.lastRestore,
      loading: loading ?? this.loading,
    ).updateMomentum();
  }

  void modifyLastRestore({
    DateTime? lastRestore,
  }) {
    CloudBackupModel(
      controller,
      latestBackupInfo: this.latestBackupInfo,
      lastRestore: lastRestore,
      loading: false,
    ).updateMomentum();
  }

  Map<String, dynamic> toJson() {
    return {
      'lastRestore': lastRestore?.millisecondsSinceEpoch,
    };
  }

  CloudBackupModel? fromJson(Map<String, dynamic>? map) {
    if (map == null) return null;
    return CloudBackupModel(
      controller,
      latestBackupInfo: CloudBackup(),
      lastRestore: map['lastRestore'] == null ? null : DateTime.fromMillisecondsSinceEpoch(map['lastRestore']),
      loading: false,
    );
  }
}
