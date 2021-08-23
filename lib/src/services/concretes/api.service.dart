import 'package:dio/dio.dart';

import '../../core/api_key.dart';
import '../../core/config.dart';
import '../../data/backup.dart';
import '../../data/feed.response.dart';
import '../../data/response.all_anime.dart';
import '../../widgets/toast.dart';
import '../interface/api.interface.dart';

class ApiService extends ApiInterface {
  final _dio = Dio();

  ApiService() {
    _dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      options.headers['api-key'] = api_key;
      return handler.next(options); //continue
    }, onResponse: (response, handler) {
      return handler.next(response); // continue
    }, onError: (DioError e, handler) {
      return handler.next(e); //continue
    }));
  }

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
