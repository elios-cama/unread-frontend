import 'package:freezed_annotation/freezed_annotation.dart';

part 'google_auth_data.freezed.dart';
part 'google_auth_data.g.dart';

@freezed
abstract class GoogleAuthData with _$GoogleAuthData {
  const factory GoogleAuthData({
    @JsonKey(name: 'id_token') required String idToken,
  }) = _GoogleAuthData;

  factory GoogleAuthData.fromJson(Map<String, dynamic> json) =>
      _$GoogleAuthDataFromJson(json);

  factory GoogleAuthData.empty() => const GoogleAuthData(idToken: '');
}
