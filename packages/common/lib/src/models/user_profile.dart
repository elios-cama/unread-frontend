import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String username,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'is_active') required bool isActive,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'updated_at') required String updatedAt,
    @JsonKey(name: 'last_login') String? lastLogin,
    @JsonKey(name: 'has_google') required bool hasGoogle,
    @JsonKey(name: 'has_apple') required bool hasApple,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  factory UserProfile.empty() => const UserProfile(
    id: '',
    username: '',
    avatarUrl: null,
    isActive: false,
    createdAt: '',
    updatedAt: '',
    lastLogin: null,
    hasGoogle: false,
    hasApple: false,
  );
}
