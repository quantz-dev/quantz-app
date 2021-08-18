import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:momentum/momentum.dart';

import '../core/index.dart';
import '../data/feed.response.dart';
import '../data/index.dart';
import '../widgets/index.dart';

class ApiService extends MomentumService {
  final _dio = Dio();

  Future<AnimeListResponse> getAnimeList() async {
    const path = '$api/anime/list';
    try {
      var response = await _dio.get(path);
      return AnimeListResponse.fromJson(response.data);
    } catch (e) {
      showToast('$e', error: true);
      print(e);
      print(['ERROR', path]);
      return AnimeListResponse(count: 0, entries: []);
    }
  }

  Future<FirebaseSubscription> getFirebaseSubscription() async {
    var token = await FirebaseMessaging.instance.getToken();
    final path = '$api/topics/$token';
    try {
      var response = await _dio.post(path);
      return FirebaseSubscription.fromJson(response.data);
    } catch (e) {
      print(e);
      print(['ERROR', path]);
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
    const path = '$api/backup/fetch';
    try {
      final param = <String, dynamic>{
        'jwt_token': token,
        'include_data': includeData,
      };
      var response = await _dio.post(path, data: param);
      return CloudBackup.fromJson(response.data);
    } catch (e) {
      if (e is DioError) {
        final notFound = e.response?.statusCode == 404;
        if (notFound) {
          return CloudBackup();
        }
      } else {
        showToast('Error fetching backup.', error: true);
      }
      print(e);
      print(['ERROR', path]);
      return CloudBackup();
    }
  }

  Future<bool> verifySupporterPurchase({
    required String authToken,
    required String purchaseToken,
    required String source,
  }) async {
    const path = '$api/supporter/verify';
    try {
      final param = <String, dynamic>{
        'auth_token': authToken,
        'purchase_token': purchaseToken,
        'source': source,
      };
      var response = await _dio.post(path, data: param);
      return response.data['valid'];
    } catch (e) {
      print(['ERROR', path]);
      return false;
    }
  }

  Future<QuantzFeed> getLatestFeed({int page = 1, int limit = 10}) async {
    try {
      final response = await _dio.get(
        '$api/feed/latest',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );
      return QuantzFeed.fromJson(response.data);
    } catch (e) {
      return QuantzFeed();
    }
  }
}
