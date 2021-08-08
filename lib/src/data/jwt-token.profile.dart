import 'dart:convert';

class JwtTokenProfile {
  JwtTokenProfile({
    this.iss = '',
    this.azp = '',
    this.aud = '',
    this.sub = '',
    this.email = '',
    this.emailVerified = false,
    this.name = '',
    this.picture = '',
    this.givenName = '',
    this.familyName = '',
    this.locale = '',
    this.iat = -1,
    this.exp = -1,
  });

  final String iss;
  final String azp;
  final String aud;
  final String sub;
  final String email;
  final bool emailVerified;
  final String name;
  final String picture;
  final String givenName;
  final String familyName;
  final String locale;
  final int iat;
  final int exp;

  JwtTokenProfile copyWith({
    String? iss,
    String? azp,
    String? aud,
    String? sub,
    String? email,
    bool? emailVerified,
    String? name,
    String? picture,
    String? givenName,
    String? familyName,
    String? locale,
    int? iat,
    int? exp,
  }) =>
      JwtTokenProfile(
        iss: iss ?? this.iss,
        azp: azp ?? this.azp,
        aud: aud ?? this.aud,
        sub: sub ?? this.sub,
        email: email ?? this.email,
        emailVerified: emailVerified ?? this.emailVerified,
        name: name ?? this.name,
        picture: picture ?? this.picture,
        givenName: givenName ?? this.givenName,
        familyName: familyName ?? this.familyName,
        locale: locale ?? this.locale,
        iat: iat ?? this.iat,
        exp: exp ?? this.exp,
      );

  factory JwtTokenProfile.fromRawJson(String str) => JwtTokenProfile.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory JwtTokenProfile.fromJson(Map<String, dynamic> json) => JwtTokenProfile(
        iss: json["iss"] == null ? '' : json["iss"],
        azp: json["azp"] == null ? '' : json["azp"],
        aud: json["aud"] == null ? '' : json["aud"],
        sub: json["sub"] == null ? '' : json["sub"],
        email: json["email"] == null ? '' : json["email"],
        emailVerified: json["email_verified"] == null ? false : json["email_verified"],
        name: json["name"] == null ? '' : json["name"],
        picture: json["picture"] == null ? '' : json["picture"],
        givenName: json["given_name"] == null ? '' : json["given_name"],
        familyName: json["family_name"] == null ? '' : json["family_name"],
        locale: json["locale"] == null ? '' : json["locale"],
        iat: json["iat"] == null ? -1 : json["iat"],
        exp: json["exp"] == null ? -1 : json["exp"],
      );

  Map<String, dynamic> toJson() => {
        "iss": iss,
        "azp": azp,
        "aud": aud,
        "sub": sub,
        "email": email,
        "email_verified": emailVerified,
        "name": name,
        "picture": picture,
        "given_name": givenName,
        "family_name": familyName,
        "locale": locale,
        "iat": iat,
        "exp": exp,
      };
}
