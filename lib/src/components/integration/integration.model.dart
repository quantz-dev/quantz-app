import 'package:momentum/momentum.dart';

import '../../data/index.dart';
import '../../data/mal-user.animelist.dart';
import 'index.dart';

class IntegrationModel extends MomentumModel<IntegrationController> {
  IntegrationModel(
    IntegrationController controller, {
    required this.loading,
    required this.malList,
    required this.toFollow,
    required this.toUnfollow,
    required this.malUsername,
    required this.syncSub,
    required this.syncDub,
    required this.malUserAnimeListCache,
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

  final List<MalUserAnimeItem> malUserAnimeListCache;

  final int statProgress;
  final int statToImport;

  bool get loggedIn => controller.mal.loggedIn;

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
    List<MalUserAnimeItem>? malUserAnimeListCache,
  }) {
    IntegrationModel(
      controller,
      loading: loading ?? this.loading,
      malList: malList ?? this.malList,
      toFollow: toFollow ?? this.toFollow,
      toUnfollow: toUnfollow ?? this.toUnfollow,
      malUsername: malUsername ?? this.malUsername,
      syncSub: syncSub ?? this.syncSub,
      syncDub: syncDub ?? this.syncDub,
      malUserAnimeListCache: malUserAnimeListCache ?? this.malUserAnimeListCache,
      statProgress: statProgress ?? this.statProgress,
      statToImport: statToImport ?? this.statToImport,
    ).updateMomentum();
  }

  Map<String, dynamic> toJson() {
    return {
      'syncSub': syncSub,
      'syncDub': syncDub,
      'malUsername': malUsername,
      'malUserAnimeListCache': malUserAnimeListCache.map((e) => e.toJson()).toList(),
    };
  }

  IntegrationModel? fromJson(Map<String, dynamic>? map) {
    if (map == null) return null;
    return IntegrationModel(
      controller,
      loading: false,
      malList: [],
      toFollow: [],
      toUnfollow: [],
      malUsername: map['malUsername'] ?? '',
      syncSub: map['syncSub'],
      syncDub: map['syncDub'],
      malUserAnimeListCache: map['malUserAnimeListCache'] == null ? [] : List<MalUserAnimeItem>.from((map['malUserAnimeListCache'] as List).map((e) => MalUserAnimeItem.fromJson(e))),
      statProgress: statProgress,
      statToImport: statToImport,
    );
  }
}
