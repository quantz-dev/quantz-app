import 'dart:convert';

class MalUserProfile {
  MalUserProfile({
    this.id = -1,
    this.name = '',
    this.location = '',
    this.picture = '',
  });

  final int id;
  final String name;
  final String location;
  final String picture;

  MalUserProfile copyWith({
    int? id,
    String? name,
    String? location,
    String? picture,
  }) =>
      MalUserProfile(
        id: id ?? this.id,
        name: name ?? this.name,
        location: location ?? this.location,
        picture: picture ?? this.picture,
      );

  factory MalUserProfile.fromRawJson(String str) => MalUserProfile.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MalUserProfile.fromJson(Map<String, dynamic> json) => MalUserProfile(
        id: json["id"],
        name: json["name"],
        location: json["location"],
        picture: json["picture"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "location": location,
        "picture": picture,
      };
}
