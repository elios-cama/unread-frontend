import 'package:freezed_annotation/freezed_annotation.dart';

part 'apple_auth_data.freezed.dart';
part 'apple_auth_data.g.dart';

@freezed
abstract class AppleAuthData with _$AppleAuthData {
  const factory AppleAuthData({
    @JsonKey(name: 'id_token') required String idToken,
    @JsonKey(name: 'authorization_code') required String authorizationCode,
  }) = _AppleAuthData;

  factory AppleAuthData.fromJson(Map<String, dynamic> json) =>
      _$AppleAuthDataFromJson(json);

  factory AppleAuthData.empty() =>
      const AppleAuthData(idToken: '', authorizationCode: '');
}
