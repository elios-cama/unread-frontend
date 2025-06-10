import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:authentication/authentication.dart';
import 'package:common/common.dart';
import '../../domain/model/auth_state_model.dart';

/// Real authentication provider that uses Supabase and backend integration
class AuthNotifier extends StateNotifier<AuthStateModel> {
  final AuthenticationService _authService;
  bool _isSigningOut = false;

  AuthNotifier(this._authService)
      : super(
          const AuthStateModel(
            status: AuthStatus.unauthenticated,
            user: null,
          ),
        ) {
    _checkStoredAuth();
  }

  /// Check if user has stored authentication data
  Future<void> _checkStoredAuth() async {
    // Don't check stored auth if we're in the middle of signing out
    if (_isSigningOut) return;

    try {
      final storedUser = await _authService.getStoredUser();

      if (storedUser != null && !_isSigningOut) {
        state = AuthStateModel(
          status: AuthStatus.authenticated,
          user: storedUser,
        );
      }
    } catch (e) {
      // If there's an error, remain unauthenticated
      if (!_isSigningOut) {
        state = const AuthStateModel(
          status: AuthStatus.unauthenticated,
          user: null,
        );
      }
    }
  }

  /// Get stored user
  Future<UserProfile?> getStoredUser() async {
    // Don't try to get stored user if we're signing out
    if (_isSigningOut) return null;
    return await _authService.getStoredUser();
  }

  /// Check stored authentication and update state
  Future<UserProfile?> checkAndUpdateStoredAuth() async {
    // Don't check auth if we're signing out
    if (_isSigningOut) return null;

    try {
      final storedUser = await _authService.getStoredUser();

      if (storedUser != null && !_isSigningOut) {
        state = AuthStateModel(
          status: AuthStatus.authenticated,
          user: storedUser,
        );
        return storedUser;
      } else {
        if (!_isSigningOut) {
          state = const AuthStateModel(
            status: AuthStatus.unauthenticated,
            user: null,
          );
        }
        return null;
      }
    } catch (e) {
      if (!_isSigningOut) {
        state = const AuthStateModel(
          status: AuthStatus.unauthenticated,
          user: null,
        );
      }
      return null;
    }
  }

  /// Sign in with Apple
  Future<void> signInWithApple() async {
    try {
      state = state.copyWith(status: AuthStatus.loading);

      final authResponse = await _authService.signInWithAppleNative();

      // Determine if this is a new user or returning user
      final isNewUser = _isNewUser(authResponse.user);

      state = AuthStateModel(
        status: isNewUser ? AuthStatus.newUser : AuthStatus.returningUser,
        user: authResponse.user,
      );
    } catch (e) {
      String errorMessage = 'Authentication failed';

      // Provide more specific error messages
      if (e.toString().contains('AuthApiException')) {
        errorMessage =
            'Apple Sign-In configuration error. Please contact support.';
      } else if (e
          .toString()
          .contains('SignInWithAppleAuthorizationException')) {
        errorMessage = 'Apple Sign-In was cancelled or failed.';
      } else if (e.toString().contains('network')) {
        errorMessage = 'Network error. Please check your connection.';
      }

      state = AuthStateModel(
        status: AuthStatus.error,
        user: null,
        errorMessage: errorMessage,
      );
    }
  }

  /// Complete onboarding for new users
  Future<void> completeOnboarding() async {
    if (state.user == null) return;

    state = AuthStateModel(
      status: AuthStatus.authenticated,
      user: state.user,
    );
  }

  /// Sign out
  Future<void> signOut() async {
    // Prevent multiple simultaneous sign-out calls
    if (_isSigningOut) return;

    _isSigningOut = true;

    // Immediately clear local state to prevent race conditions
    state = const AuthStateModel(
      status: AuthStatus.unauthenticated,
      user: null,
    );

    try {
      // Then clear the stored auth data
      await _authService.signOut();
    } catch (e) {
      // State is already cleared above, so no need to do anything
      // Just ensure we don't throw to prevent UI issues
      debugPrint('Sign out error: $e');
    } finally {
      _isSigningOut = false;
    }
  }

  /// Determine if user is new (created recently)
  bool _isNewUser(UserProfile user) {
    try {
      final createdAt = DateTime.parse(user.createdAt);
      final now = DateTime.now();
      final difference = now.difference(createdAt);

      // Consider user new if created within the last hour
      return difference.inHours < 1;
    } catch (e) {
      // If we can't parse the date, assume returning user
      return false;
    }
  }
}

/// Auth provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthStateModel>((ref) {
  final authService = ref.watch(authenticationServiceProvider);
  return AuthNotifier(authService);
});

/// Auth state stream provider for listening to auth changes
final authStateStreamProvider = StreamProvider<AuthStateModel>((ref) async* {
  yield ref.watch(authProvider);

  await for (final _ in Stream.periodic(const Duration(seconds: 30))) {
    final currentState = ref.read(authProvider);
    if (currentState.status == AuthStatus.authenticated) {
      // Periodically verify token is still valid
      try {
        final authService = ref.read(authenticationServiceProvider);
        final storedUser = await authService.getStoredUser();

        if (storedUser == null) {
          // Token expired, sign out
          ref.read(authProvider.notifier).signOut();
        }
      } catch (e) {
        // Error checking token, continue with current state
      }
    }

    yield ref.read(authProvider);
  }
});
