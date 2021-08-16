import 'dart:convert';

class MalTokenResponse {
  MalTokenResponse({
    this.tokenType = '',
    this.expiresIn = -1,
    this.accessToken = '',
    this.refreshToken = '',
  });

  final String tokenType;
  final int expiresIn;
  final String accessToken;
  final String refreshToken;

  MalTokenResponse copyWith({
    String? tokenType,
    int? expiresIn,
    String? accessToken,
    String? refreshToken,
  }) =>
      MalTokenResponse(
        tokenType: tokenType ?? this.tokenType,
        expiresIn: expiresIn ?? this.expiresIn,
        accessToken: accessToken ?? this.accessToken,
        refreshToken: refreshToken ?? this.refreshToken,
      );

  factory MalTokenResponse.fromRawJson(String str) => MalTokenResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MalTokenResponse.fromJson(Map<String, dynamic> json) => MalTokenResponse(
        tokenType: json["token_type"],
        expiresIn: json["expires_in"],
        accessToken: json["access_token"],
        refreshToken: json["refresh_token"],
      );

  Map<String, dynamic> toJson() => {
        "token_type": tokenType,
        "expires_in": expiresIn,
        "access_token": accessToken,
        "refresh_token": refreshToken,
      };
}
