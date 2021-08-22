import 'package:momentum/momentum.dart';

import '../../data/mal-user.animelist.dart';
import '../../data/mal-user.animeupdate.dart';
import '../../data/mal-user.profile.dart';

abstract class MalInterface extends MomentumService {
  bool get loggedIn;

  Future<String> getLoginUrl();

  Future<MalUserAnimeListResponse> getUserAnimeList({required String status, required int offset});

  Future<MalUserProfile> getUserProfile();

  Future<MalUserAnimeUpdate> updateUserAnime({
    required int malId,
    String? status,
    int? numWatchedEpisodes,
    String? startDate,
    String? finishDate,
  });

  Future<MalUserAnimeDetails> getUserAnime(int malId);

  Future<void> logout();
}
