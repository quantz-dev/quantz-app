import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:momentum/momentum.dart';

import '../core/index.dart';
import '../data/feed/feed.animenewsnetwork.dart';
import '../data/feed/feed.livechart.dart';
import '../data/feed/feed.myanimelist.dart';
import '../data/feed/feed.ranime.dart';
import '../data/index.dart';
import '../widgets/index.dart';

class ApiService extends MomentumService {
  final _dio = Dio();

  Future<AnimeListResponse> getAnimeList() async {
    try {
      var path = '$api/anime/list';
      var response = await _dio.get(path);
      return AnimeListResponse.fromJson(response.data);
    } catch (e) {
      showToast('$e', error: true);
      print(e);
      return AnimeListResponse(count: 0, entries: []);
    }
  }

  Future<JikanUserAnimeList> getUserAnimeList({
    required String username,
    required String type,
    required String airingStatus,
    required int page,
  }) async {
    try {
      var path = 'https://api.jikan.moe/v3/user/$username/animelist/$type';
      var response = await _dio.get(
        path,
        queryParameters: {
          'page': page,
          'airing_status': airingStatus,
        },
      );
      await Future.delayed(Duration(milliseconds: 500));
      var result = JikanUserAnimeList.fromJson(response.data);
      if (result.anime.isEmpty) {
        return JikanUserAnimeList(anime: []);
      }
      return result;
    } catch (e) {
      showToast('$e', error: true);
      print(e);
      return JikanUserAnimeList(anime: []);
    }
  }

  Future<FirebaseSubscription> getFirebaseSubscription() async {
    try {
      var token = await FirebaseMessaging.instance.getToken();
      var response = await _dio.post('$api/topics/$token');
      return FirebaseSubscription.fromJson(response.data);
    } catch (e) {
      showToast('$e', error: true);
      print(e);
      return FirebaseSubscription();
    }
  }

  Future<String> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        return googleAuth.idToken ?? '';
      }
      return '';
    } catch (e) {
      print(e);
      showToast('$e', error: true);
      return '';
    }
  }

  Future<String> refreshToken() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signInSilently();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        return googleAuth.idToken ?? '';
      }
      return '';
    } catch (e) {
      print(e);
      showToast('$e', error: true);
      return '';
    }
  }

  Future<CloudBackup> newBackup({required String token, required String data}) async {
    try {
      final param = {
        'jwt_token': token,
        'data': data,
      };
      var response = await _dio.post(
        '$api/backup/new',
        data: param,
      );
      return CloudBackup.fromJson(response.data);
    } catch (e) {
      showToast('Error creating backup', error: true);
      print(e);
      return CloudBackup();
    }
  }

  Future<CloudBackup> fetchBackup({
    required String token,
    bool includeData = true,
  }) async {
    try {
      final param = <String, dynamic>{
        'jwt_token': token,
        'include_data': includeData,
      };
      var response = await _dio.post('$api/backup/fetch', data: param);
      return CloudBackup.fromJson(response.data);
    } catch (e) {
      showToast('Error fetching backup.', error: true);
      print(e);
      return CloudBackup();
    }
  }

  Future<List<AnimeNewsNetworkFeedItem>> getAnnLatest() async {
    try {
      final response = await _dio.get('$api/animenewsnetwork/latest');
      return List<AnimeNewsNetworkFeedItem>.from(response.data.map((json) => AnimeNewsNetworkFeedItem.fromJson(json)));
    } catch (e) {
      return [];
    }
  }

  Future<List<LivechartFeedItem>> getLivechartLatest() async {
    try {
      final response = await _dio.get('$api/livechart/latest');
      return List<LivechartFeedItem>.from(response.data.map((json) => LivechartFeedItem.fromJson(json)));
    } catch (e) {
      return [];
    }
  }

  Future<List<MyAnimeListFeedItem>> getMyAnimeListLatest() async {
    try {
      final response = await _dio.get('$api/myanimelist/latest');
      return List<MyAnimeListFeedItem>.from(response.data.map((json) => MyAnimeListFeedItem.fromJson(json)));
    } catch (e) {
      return [];
    }
  }

  Future<List<RAnimeFeedItem>> getRAnimeLatest() async {
    try {
      final response = await _dio.get('$api/ranime/latest');
      return List<RAnimeFeedItem>.from(response.data.map((json) => RAnimeFeedItem.fromJson(json)));
    } catch (e) {
      return [];
    }
  }
}
