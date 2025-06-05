import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_public.freezed.dart';
part 'user_public.g.dart';

@freezed
abstract class UserPublic with _$UserPublic {
  const factory UserPublic({
    required String id,
    required String username,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = _UserPublic;

  factory UserPublic.fromJson(Map<String, dynamic> json) =>
      _$UserPublicFromJson(json);

  factory UserPublic.empty() => const UserPublic(
        id: '',
        username: '',
        avatarUrl: null,
        createdAt: '',
      );

  factory UserPublic.mock() => const UserPublic(
        id: '550e8400-e29b-41d4-a716-446655440010',
        username: 'sci_fi_lover',
        avatarUrl: 'https://example.com/avatars/sci_fi_lover.jpg',
        createdAt: '2023-12-01T09:00:00Z',
      );
}
