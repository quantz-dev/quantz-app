import 'package:dio/dio.dart';
import 'package:random_string/random_string.dart';
import 'package:uni_links/uni_links.dart';

import '../../core/mal.client.dart';
import '../../core/persistence.dart';
import '../../data/mal-token.dart';
import '../../data/mal-user.animelist.dart';
import '../../data/mal-user.animeupdate.dart';
import '../../data/mal-user.profile.dart';
import '../interface/mal.interface.dart';

class MalService extends MalInterface {
  final _dio = Dio();

  bool get loggedIn => _accessToken.isNotEmpty;
  String _accessToken = '';
  String _codeChallenge = '';
  String _authCode = '';

  MalService() {
    linkStream.listen((event) {
      _authCode = event ?? '';
      if (_authCode.isNotEmpty) {
        _getToken();
      }
    });
    _refreshAccessToken();
  }

  Future<void> _saveRefreshToken(String refreshToken) async {
    await sharedPreferences.setString('MAL_REFRESH_TOKEN', refreshToken);
  }

  String _getRefreshToken() {
    return sharedPreferences.getString('MAL_REFRESH_TOKEN') ?? '';
  }

  Future<void> _refreshAccessToken() async {
    try {
      if (_accessToken.isNotEmpty) return;
      await initSharedPreferences();
      final refreshToken = _getRefreshToken();
      final param = <String, dynamic>{
        'grant_type': 'refresh_token',
        'refresh_token': refreshToken,
      };
      final response = await _dio.post(
        'https://myanimelist.net/v1/oauth2/token',
        data: param,
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
          headers: <String, dynamic>{
            'Authorization': MAL_AUTH,
          },
        ),
      );
      final malToken = MalTokenResponse.fromJson(response.data);
      _accessToken = malToken.accessToken;
      await _saveRefreshToken(malToken.refreshToken);
    } catch (e) {
      print(e);
    }
  }

  Future<String> _getLoginCode() async {
    try {
      if (_authCode.isEmpty) {
        _authCode = (await getInitialLink()) ?? '';
      }
      final uri = Uri.parse(_authCode);
      return uri.queryParameters['malcode'] ?? '';
    } catch (e) {
      return '';
    }
  }

  Future<bool> _getToken() async {
    try {
      if (_accessToken.isNotEmpty) return true;
      final param = <String, dynamic>{
        'client_id': MAL_CLIENT_ID,
        'grant_type': 'authorization_code',
        'code': await _getLoginCode(),
        'code_verifier': _codeChallenge,
        'redirect_uri': MAL_REDIRECT_URI,
      };
      final response = await _dio.post(
        'https://myanimelist.net/v1/oauth2/token',
        data: param,
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
          headers: <String, dynamic>{
            'Authorization': MAL_AUTH,
          },
        ),
      );
      final malToken = MalTokenResponse.fromJson(response.data);
      _accessToken = malToken.accessToken;
      await _saveRefreshToken(malToken.refreshToken);
      _codeChallenge = '';
      _authCode = '';
      return true;
    } catch (e) {
      _codeChallenge = '';
      _authCode = '';
      return false;
    }
  }

  Future<String> getLoginUrl() async {
    await _refreshAccessToken();
    if (loggedIn) return '';
    if (_codeChallenge.isEmpty) {
      _codeChallenge = randomAlpha(43);
    }
    return 'https://myanimelist.net/v1/oauth2/authorize?response_type=code&client_id=$MAL_CLIENT_ID&redirect_uri=$MAL_REDIRECT_URI&code_challenge=$_codeChallenge';
  }

  Future<MalUserAnimeListResponse> getUserAnimeList({
    required String status,
    required int offset,
  }) async {
    try {
      await _refreshAccessToken();
      final params = {
        'status': status,
        'limit': 1000,
        'offset': offset,
        'fields': 'list_status{status,score,num_episodes_watched,start_date,finish_date},num_episodes,status',
      };
      final response = await _dio.get(
        'https://api.myanimelist.net/v2/users/@me/animelist',
        queryParameters: params,
        options: Options(
          headers: <String, dynamic>{
            'Authorization': 'Bearer $_accessToken',
          },
        ),
      );
      return MalUserAnimeListResponse.fromJson(response.data);
    } catch (e) {
      return MalUserAnimeListResponse();
    }
  }

  Future<MalUserProfile> getUserProfile() async {
    try {
      await _refreshAccessToken();
      final response = await _dio.get(
        'https://api.myanimelist.net/v2/users/@me',
        options: Options(
          headers: <String, dynamic>{
            'Authorization': 'Bearer $_accessToken',
          },
        ),
      );
      return MalUserProfile.fromJson(response.data);
    } catch (e) {
      return MalUserProfile();
    }
  }

  @override
  Future<MalUserAnimeUpdate> updateUserAnime({
    required int malId,
    String? status,
    int? numWatchedEpisodes,
    String? startDate,
    String? finishDate,
  }) async {
    try {
      await _refreshAccessToken();
      final data = {
        "status": status,
        "num_watched_episodes": numWatchedEpisodes,
        "start_date": startDate,
        "finish_date": finishDate,
      }..removeWhere((key, value) => value == null);
      final response = await _dio.put(
        'https://api.myanimelist.net/v2/anime/$malId/my_list_status',
        data: data,
        options: Options(
          headers: <String, dynamic>{
            'Authorization': 'Bearer $_accessToken',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );
      return MalUserAnimeUpdate.fromJson(response.data);
    } catch (e) {
      return MalUserAnimeUpdate();
    }
  }

  @override
  Future<MalUserAnimeDetails> getUserAnime(int malId) async {
    try {
      await _refreshAccessToken();
      final response = await _dio.get(
        'https://api.myanimelist.net/v2/anime/$malId',
        queryParameters: {"fields": "my_list_status{status,score,num_episodes_watched,start_date,finish_date},num_episodes,status"},
        options: Options(
          headers: <String, dynamic>{
            'Authorization': 'Bearer $_accessToken',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );
      return MalUserAnimeDetails.fromJson(response.data);
    } catch (e) {
      return MalUserAnimeDetails();
    }
  }

  Future<void> logout() async {
    _accessToken = '';
    _codeChallenge = '';
    _authCode = '';
    await sharedPreferences.setString('MAL_REFRESH_TOKEN', '');
  }
}
