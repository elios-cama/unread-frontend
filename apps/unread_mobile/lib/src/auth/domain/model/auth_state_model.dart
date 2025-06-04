import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:common/common.dart';

part 'auth_state_model.freezed.dart';
part 'auth_state_model.g.dart';

enum AuthStatus {
  unauthenticated,
  newUser,
  returningUser,
  authenticated,
  error,
}

@freezed
abstract class AuthStateModel with _$AuthStateModel {
  const factory AuthStateModel({
    required AuthStatus status,
    UserProfile? user,
    String? errorMessage,
  }) = _AuthStateModel;

  factory AuthStateModel.fromJson(Map<String, dynamic> json) =>
      _$AuthStateModelFromJson(json);

  factory AuthStateModel.empty() => const AuthStateModel(
        status: AuthStatus.unauthenticated,
        user: null,
      );
}
