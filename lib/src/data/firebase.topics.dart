import 'dart:convert';

class FirebaseSubscription {
  FirebaseSubscription({
    this.topics = const {},
  });

  final Map<String, _Info> topics;

  FirebaseSubscription copyWith({
    Map<String, _Info>? topics,
  }) =>
      FirebaseSubscription(
        topics: topics ?? this.topics,
      );

  factory FirebaseSubscription.fromRawJson(String str) => FirebaseSubscription.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FirebaseSubscription.fromJson(Map<String, dynamic> json) => FirebaseSubscription(
        topics: json["topics"] == null ? {} : Map.from(json["topics"]).map((k, v) => MapEntry<String, _Info>(k, _Info.fromJson(v))),
      );

  Map<String, dynamic> toJson() => {
        "topics": Map.from(topics).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
      };
}

class _Info {
  _Info({
    this.addDate,
  });

  final DateTime? addDate;

  _Info copyWith({
    DateTime? addDate,
  }) =>
      _Info(
        addDate: addDate ?? this.addDate,
      );

  String toRawJson() => json.encode(toJson());

  factory _Info.fromJson(Map<String, dynamic> json) => _Info(
        addDate: json["addDate"] == null ? null : DateTime.parse(json["addDate"]),
      );

  Map<String, dynamic> toJson() => {
        "addDate": "${addDate?.year.toString().padLeft(4, '0')}-${addDate?.month.toString().padLeft(2, '0')}-${addDate?.day.toString().padLeft(2, '0')}",
      };
}
