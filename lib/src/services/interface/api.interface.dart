import 'package:momentum/momentum.dart';

import '../../data/backup.dart';
import '../../data/feed.response.dart';
import '../../data/response.all_anime.dart';

abstract class ApiInterface extends MomentumService {
  Future<AnimeListResponse> getAnimeList();

  Future<CloudBackup> newBackup({required String token, required String data});

  Future<CloudBackup> fetchBackup({required String token, bool includeData = true});

  Future<QuantzFeed> getLatestFeed({int page = 1, int limit = 10});
}
