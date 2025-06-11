import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:common/common.dart';
import 'authentication_service.dart';

/// Authentication interceptor that handles token injection and refresh
class AuthTokenInterceptor extends Interceptor {
  final Ref ref;

  AuthTokenInterceptor(this.ref);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      // Get the current backend token from authentication service
      final authService = ref.read(authenticationServiceProvider);
      final token = await authService.getBackendToken();

      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
        if (kDebugMode) {
          debugPrint('🔐 Added auth token to request: ${options.uri.path}');
        }
      } else {
        if (kDebugMode) {
          debugPrint(
              '⚠️ No auth token available for request: ${options.uri.path}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error getting auth token: $e');
      }
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 Unauthorized errors
    if (err.response?.statusCode == 401) {
      if (kDebugMode) {
        debugPrint('🚪 Received 401 Unauthorized - token expired or invalid');
      }

      try {
        // Sign out user since token is invalid
        final authService = ref.read(authenticationServiceProvider);
        await authService.signOut();

        if (kDebugMode) {
          debugPrint('🔄 User signed out due to invalid token');
        }
      } catch (e) {
        if (kDebugMode) {
          debugPrint('❌ Error signing out user: $e');
        }
      }
    }

    handler.next(err);
  }
}

/// Authenticated Dio provider that automatically injects JWT tokens
/// Use this for all API calls that require authentication
final authenticatedDioProvider = Provider<Dio>((ref) {
  final dio = DioProviderFactory.createApiClient(
    customLoggingInterceptor: DioLoggingInterceptors.standard(),
  );

  // Add authentication interceptor
  dio.interceptors.add(AuthTokenInterceptor(ref));

  return dio;
});

/// Authenticated file upload/download provider
/// Use this for file operations that require authentication
final authenticatedFileDioProvider = Provider<Dio>((ref) {
  final dio = DioProviderFactory.createFileClient(
      // Use minimal logging for file operations
      );

  // Add authentication interceptor
  dio.interceptors.add(AuthTokenInterceptor(ref));

  return dio;
});
