import 'dart:convert';

import 'package:dio/dio.dart';

import '../../data/backup.dart';
import '../../data/feed.response.dart';
import '../../data/response.all_anime.dart';
import '../../widgets/toast.dart';
import '../interface/api.interface.dart';

class ApiMockService extends ApiInterface {
  final _dio = Dio();

  CloudBackup _backupData = CloudBackup();

  @override
  Future<AnimeListResponse> getAnimeList() async {
    const path = 'https://gist.githubusercontent.com/xamantra/6607da2e19b3b4a6749aa4e25df15281/raw/ecc9380cc6e03b53aa97b90b4f6477709c0a9ddd/mock_anime_list.json';
    try {
      var response = await _dio.get(path);
      final json = jsonDecode(response.data);
      return AnimeListResponse.fromJson(json);
    } catch (e) {
      showToast('$e', error: true);
      print(e);
      print(['ERROR', path]);
      return AnimeListResponse(count: 0, entries: []);
    }
  }

  @override
  Future<CloudBackup> newBackup({required String token, required String data}) async {
    try {
      await Future.delayed(Duration(seconds: 2));
      _backupData = CloudBackup(
        id: '60f3aa8051a6980015c9904e',
        userId: '106243734760415480007',
        data: data,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      return _backupData;
    } catch (e) {
      showToast('Error creating backup', error: true);
      print(e);
      return CloudBackup();
    }
  }

  @override
  Future<CloudBackup> fetchBackup({required String token, bool includeData = true}) async {
    await Future.delayed(Duration(seconds: 2));
    if (includeData) {
      return _backupData;
    }
    return _backupData.copyWith(data: '');
  }

  @override
  Future<QuantzFeed> getLatestFeed({int page = 1, int limit = 10}) async {
    try {
      if (page > 1) {
        return QuantzFeed();
      }
      final response = await _dio.get('https://gist.githubusercontent.com/xamantra/c005d735474c0dea2f76738be15925dc/raw/c91b3c1bb3e27ffd0e2ee17560146ddd1eb9a06a/mock_news_feed.json');
      final json = jsonDecode(response.data);
      return QuantzFeed.fromJson(json);
    } catch (e) {
      return QuantzFeed();
    }
  }
}
