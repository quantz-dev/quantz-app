import 'dart:convert';

import 'package:dio/dio.dart';

import '../../data/mal-user.animelist.dart';
import '../../data/mal-user.animeupdate.dart';
import '../../data/mal-user.profile.dart';
import '../interface/mal.interface.dart';

class MalMockService extends MalInterface {
  final _dio = Dio();

  @override
  bool get loggedIn => _loggedIn;
  bool _loggedIn = false;

  @override
  Future<String> getLoginUrl() async {
    await Future.delayed(Duration(seconds: 1));
    _loggedIn = true;
    return '';
  }

  @override
  Future<MalUserAnimeListResponse> getUserAnimeList({required String status, required int offset}) async {
    const path = 'https://gist.githubusercontent.com/xamantra/2c6b8d8cec2004c5030753b08e65a981/raw/3d39b6e11cc4ce368e8f8ae8166c15207879b33a/mock_mal_user_animelist.json';
    try {
      final response = await _dio.get(path);
      final json = jsonDecode(response.data);
      return MalUserAnimeListResponse.fromJson(json);
    } catch (e) {
      return MalUserAnimeListResponse();
    }
  }

  @override
  Future<MalUserProfile> getUserProfile() async {
    await Future.delayed(Duration(seconds: 1));
    return MalUserProfile.fromJson({
      "id": 91292189, // random number only
      "name": "mockdata",
      "location": "",
      "joined_at": "2020-12-20T21:18:18+00:00",
      "picture": "https://cdn.myanimelist.net/images/anime/1527/113656.jpg",
    });
  }

  @override
  Future<void> logout() async {
    await Future.delayed(Duration(seconds: 1));
    _loggedIn = false;
  }

  @override
  Future<MalUserAnimeUpdate> updateUserAnime({
    required int malId,
    String? status,
    int? numWatchedEpisodes,
    String? startDate,
    String? finishDate,
  }) async {
    await Future.delayed(Duration(seconds: 2));
    return MalUserAnimeUpdate(
      status: status ?? 'watching',
      numEpisodesWatched: numWatchedEpisodes ?? 0,
      startDate: startDate ?? '',
      finishDate: finishDate ?? '',
    );
  }

  @override
  Future<MalUserAnimeDetails> getUserAnime(int malId) async {
    await Future.delayed(Duration(seconds: 2));
    return MalUserAnimeDetails();
  }
}
