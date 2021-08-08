import 'package:momentum/momentum.dart';

import '../../data/index.dart';
import 'index.dart';

class ImportModel extends MomentumModel<ImportController> {
  ImportModel(
    ImportController controller, {
    required this.loading,
    required this.malList,
    required this.toFollow,
    required this.toUnfollow,
    required this.malUsername,
    required this.syncSub,
    required this.syncDub,
    required this.statProgress,
    required this.statToImport,
  }) : super(controller);

  final bool loading;
  final List<int> malList;
  final List<AnimeEntry> toFollow;
  final List<AnimeEntry> toUnfollow;
  final String malUsername;
  final bool syncSub;
  final bool syncDub;

  final int statProgress;
  final int statToImport;

  @override
  void update({
    bool? loading,
    List<int>? malList,
    List<AnimeEntry>? toFollow,
    List<AnimeEntry>? toUnfollow,
    String? malUsername,
    bool? syncSub,
    bool? syncDub,
    int? statProgress,
    int? statToImport,
  }) {
    ImportModel(
      controller,
      loading: loading ?? this.loading,
      malList: malList ?? this.malList,
      toFollow: toFollow ?? this.toFollow,
      toUnfollow: toUnfollow ?? this.toUnfollow,
      malUsername: malUsername ?? this.malUsername,
      syncSub: syncSub ?? this.syncSub,
      syncDub: syncDub ?? this.syncDub,
      statProgress: statProgress ?? this.statProgress,
      statToImport: statToImport ?? this.statToImport,
    ).updateMomentum();
  }

  Map<String, dynamic> toJson() {
    return {
      'malUsername': malUsername,
      'syncSub': syncSub,
      'syncDub': syncDub,
    };
  }

  ImportModel? fromJson(Map<String, dynamic>? map) {
    if (map == null) return null;
    return ImportModel(
      controller,
      loading: false,
      malList: [],
      toFollow: [],
      toUnfollow: [],
      malUsername: map['malUsername'],
      syncSub: map['syncSub'],
      syncDub: map['syncDub'],
      statProgress: statProgress,
      statToImport: statToImport,
    );
  }
}
