import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:common/common.dart';
import '../../../auth/domain/model/auth_state_model.dart';

part 'auth_state_provider.g.dart';

@riverpod
class AuthState extends _$AuthState {
  @override
  AuthStateModel build() {
    return const AuthStateModel(
      status: AuthStatus.unauthenticated,
      user: null,
    );
  }

  Future<AuthStateModel> checkAuthStatus() async {
    try {
      // TODO: Implement actual auth check with secure storage and API
      // For now, simulate auth check for development
      await Future.delayed(const Duration(seconds: 1));

      // Mock logic - in real implementation, check stored tokens/credentials
      final mockUser = UserProfile(
        id: '123e4567-e89b-12d3-a456-426614174000',
        username: 'elliotalderson',
        avatarUrl: 'https://example.com/avatar.jpg',
        isActive: true,
        createdAt: '2024-01-01T12:00:00Z',
        updatedAt: DateTime.now().toIso8601String(),
        lastLogin: DateTime.now().toIso8601String(),
        hasGoogle: true,
        hasApple: false,
      );

      // Simulate different auth states for development
      final now = DateTime.now().millisecondsSinceEpoch;
      final authType = now % 4;

      late AuthStateModel newState;
      switch (authType) {
        case 0:
          newState = const AuthStateModel(
            status: AuthStatus.unauthenticated,
            user: null,
          );
          break;
        case 1:
          newState = AuthStateModel(
            status: AuthStatus.newUser,
            user: mockUser.copyWith(
              username: 'newuser123',
              avatarUrl: null,
              createdAt: DateTime.now().toIso8601String(),
            ),
          );
          break;
        case 2:
          newState = AuthStateModel(
            status: AuthStatus.returningUser,
            user: mockUser,
          );
          break;
        case 3:
          newState = AuthStateModel(
            status: AuthStatus.authenticated,
            user: mockUser,
          );
          break;
      }

      state = newState;
      return newState;
    } catch (e) {
      final errorState = const AuthStateModel(
        status: AuthStatus.error,
        user: null,
      );
      state = errorState;
      return errorState;
    }
  }

  void signOut() {
    state = const AuthStateModel(
      status: AuthStatus.unauthenticated,
      user: null,
    );
  }

  void updateAuthState(AuthStatus status, {UserProfile? user}) {
    state = AuthStateModel(status: status, user: user);
  }
}
