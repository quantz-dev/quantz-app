import 'dart:convert';

import '../misc/index.dart';

class BackupData {
  final Map<String, dynamic> importState;
  final Map<String, dynamic> animeListState;
  final Map<String, dynamic> sourcesState;

  BackupData({
    required this.importState,
    required this.animeListState,
    required this.sourcesState,
  });

  Map<String, dynamic> toJson() {
    return {
      IMPORT_STATE_KEY: importState,
      ANIMELIST_STATE_KEY: animeListState,
      NEWS_STATE_KEY: sourcesState,
    };
  }

  factory BackupData.fromJson(Map<String, dynamic> map) {
    return BackupData(
      importState: Map<String, dynamic>.from(map[IMPORT_STATE_KEY]),
      animeListState: Map<String, dynamic>.from(map[ANIMELIST_STATE_KEY]),
      sourcesState: Map<String, dynamic>.from(map[NEWS_STATE_KEY]),
    );
  }

  String toRawJson() => json.encode(toJson());

  factory BackupData.fromRawJson(String source) => BackupData.fromJson(json.decode(source));
}

class CloudBackup {
  CloudBackup({
    this.id = '',
    this.userId = '',
    this.data = '',
    this.createdAt,
    this.updatedAt,
    this.v = -1,
  });

  final String id;
  final String userId;
  final String data;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int v;

  CloudBackup copyWith({
    String? id,
    String? userId,
    String? data,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) =>
      CloudBackup(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        data: data ?? this.data,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        v: v ?? this.v,
      );

  factory CloudBackup.fromRawJson(String str) => CloudBackup.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CloudBackup.fromJson(Map<String, dynamic> json) => CloudBackup(
        id: json["_id"] == null ? '' : json["_id"],
        userId: json["user_id"] == '' ? null : json["user_id"],
        data: json["data"] == null ? '' : json["data"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
        v: json["__v"] == null ? -1 : json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "user_id": userId,
        "data": data,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}
