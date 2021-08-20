import 'package:momentum/momentum.dart';

import '../../data/mal-user.animelist.dart';
import '../../data/mal-user.profile.dart';

abstract class MalInterface extends MomentumService {
  bool get loggedIn;

  Future<String> getLoginUrl();

  Future<MalUserAnimeListResponse> getUserAnimeList({required String status, required int offset});

  Future<MalUserProfile> getUserProfile();

  Future<void> logout();
}
