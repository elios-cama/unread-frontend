import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthResponse;
import 'package:supabase_flutter/supabase_flutter.dart' as supabase
    show AuthResponse;
import 'package:common/common.dart';
import 'supabase_service.dart';

/// Authentication service that handles the two-token system:
/// 1. Supabase OAuth tokens (managed by Supabase)
/// 2. Backend JWT tokens (managed by us)
class AuthenticationService {
  final SupabaseClient _supabase;
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;

  AuthenticationService(this._supabase, this._dio, this._secureStorage);

  static const String _backendTokenKey = 'backend_token';
  static const String _userProfileKey = 'user_profile';

  /// Sign in with Apple using native Sign-In (alternative approach)
  Future<AuthResponse> signInWithAppleNative() async {
    final startTime = DateTime.now();
    try {
      final rawNonce = _supabase.auth.generateRawNonce();
      final hashedNonce = sha256.convert(utf8.encode(rawNonce)).toString();

      debugPrint('🍎 Starting Apple Sign-In process...');

      // Step 1: Native Apple Sign-In
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );
      // Step 2: Sign in to Supabase with Apple credentials

      final supabaseAuthResponse = await _signInWithSupabaseRetry(
        credential.identityToken!,
        credential.authorizationCode,
        rawNonce,
      );

      if (supabaseAuthResponse.session == null) {
        debugPrint('❌ Supabase auth response has no session');
        throw Exception('Failed to authenticate with Supabase');
      }

      debugPrint(
          '✅ Supabase session obtained, access token length: ${supabaseAuthResponse.session!.accessToken.length}');

      // Step 3: Exchange Supabase token for backend token
      final backendAuth = await _exchangeSupabaseTokenForBackendToken(
        supabaseAuthResponse.session!.accessToken,
      );

      // Step 4: Store authentication data
      await _storeAuthData(backendAuth);

      final totalTime = DateTime.now().difference(startTime);
      debugPrint(
          '🎉 Apple Sign-In completed successfully in ${totalTime.inMilliseconds}ms');

      return backendAuth;
    } catch (e) {
      final totalTime = DateTime.now().difference(startTime);
      debugPrint('❌ Apple Sign-In failed after ${totalTime.inMilliseconds}ms');
      debugPrint('❌ Native Apple Sign-In error: $e');

      rethrow;
    }
  }

  /// Exchange Supabase token for backend JWT token
  Future<AuthResponse> _exchangeSupabaseTokenForBackendToken(
    String supabaseToken,
  ) async {
    try {
      final response = await _dio.post(
        '/api/v1/auth/supabase',
        options: Options(
          headers: {
            'Authorization': 'Bearer $supabaseToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return AuthResponse.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Failed to exchange tokens: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      debugPrint('Token exchange error: ${e.message}');
      throw Exception('Authentication failed: ${e.message}');
    }
  }

  /// Store authentication data securely
  Future<void> _storeAuthData(AuthResponse authResponse) async {
    await Future.wait([
      _secureStorage.write(
        key: _backendTokenKey,
        value: authResponse.accessToken,
      ),
      _secureStorage.write(
        key: _userProfileKey,
        value: jsonEncode(authResponse.user.toJson()),
      ),
    ]);
  }

  /// Check if user is authenticated by verifying stored tokens
  Future<UserProfile?> getStoredUser() async {
    try {
      final backendToken = await _secureStorage.read(key: _backendTokenKey);
      final userProfileJson = await _secureStorage.read(key: _userProfileKey);

      if (backendToken == null || userProfileJson == null) {
        return null;
      }

      // Verify backend token is still valid
      final isValid = await _verifyBackendToken(backendToken);
      if (!isValid) {
        await signOut();
        return null;
      }

      // Return stored user profile
      final userMap = jsonDecode(userProfileJson) as Map<String, dynamic>;
      return UserProfile.fromJson(userMap);
    } catch (e) {
      debugPrint('Error retrieving stored user: $e');
      await signOut(); // Clear invalid data
      return null;
    }
  }

  /// Verify backend token is still valid
  Future<bool> _verifyBackendToken(String token) async {
    try {
      final response = await _dio.get(
        '/api/v1/users/me',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Sign out from both Supabase and clear stored tokens
  Future<void> signOut() async {
    try {
      // Sign out from Supabase
      await _supabase.auth.signOut();

      // Clear stored tokens
      await Future.wait([
        _secureStorage.delete(key: _backendTokenKey),
        _secureStorage.delete(key: _userProfileKey),
      ]);
    } catch (e) {
      debugPrint('Sign out error: $e');
      // Still clear local storage even if Supabase sign out fails
      await Future.wait([
        _secureStorage.delete(key: _backendTokenKey),
        _secureStorage.delete(key: _userProfileKey),
      ]);
    }
  }

  /// Get stored backend token for API calls
  Future<String?> getBackendToken() async {
    return await _secureStorage.read(key: _backendTokenKey);
  }

  /// Sign in with Supabase with retry logic for handling intermittent 500 errors
  Future<supabase.AuthResponse> _signInWithSupabaseRetry(
    String identityToken,
    String? authorizationCode,
    String rawNonce,
  ) async {
    const maxRetries = 3;
    const baseDelay = Duration(milliseconds: 500);

    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        debugPrint('🔄 Supabase sign-in attempt $attempt/$maxRetries');

        final authResponse = await _supabase.auth.signInWithIdToken(
          provider: OAuthProvider.apple,
          idToken: identityToken,
          accessToken: authorizationCode,
          nonce: rawNonce,
        );

        debugPrint('✅ Supabase sign-in successful on attempt $attempt');
        return authResponse;
      } catch (e) {
        debugPrint('❌ Supabase sign-in attempt $attempt failed: $e');

        if (attempt == maxRetries) {
          debugPrint('🚫 All retry attempts exhausted, throwing error');
          rethrow;
        }

        // Exponential backoff
        final delay = Duration(
          milliseconds: baseDelay.inMilliseconds * (attempt * attempt),
        );
        debugPrint('⏳ Waiting ${delay.inMilliseconds}ms before retry...');
        await Future.delayed(delay);
      }
    }

    throw Exception('Retry logic failed unexpectedly');
  }
}

/// Secure storage provider
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );
});

/// Dio client provider for authentication
final authDioProvider = Provider<Dio>((ref) {
  return DioProviderFactory.createApiClient(
    customLoggingInterceptor: DioLoggingInterceptors.verbose(),
  );
});

/// Supabase client provider
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return SupabaseService.client;
});

/// Authentication service provider
final authenticationServiceProvider = Provider<AuthenticationService>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  final dio = ref.watch(authDioProvider);
  final secureStorage = ref.watch(secureStorageProvider);

  return AuthenticationService(supabase, dio, secureStorage);
});
