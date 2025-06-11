import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'environment/app_config.dart';
import 'dio_logging_interceptor.dart';

/// Factory for creating standardized Dio providers
class DioProviderFactory {
  /// Create a Dio instance for API calls with authentication
  static Dio createApiClient({
    String? baseUrl,
    Map<String, String>? defaultHeaders,
    Duration? connectTimeout,
    Duration? sendTimeout,
    Duration? receiveTimeout,
    DioLoggingInterceptor? customLoggingInterceptor,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? AppConfig.apiBaseUrl,
        connectTimeout: connectTimeout ?? const Duration(milliseconds: 30000),
        sendTimeout: sendTimeout ?? const Duration(milliseconds: 30000),
        receiveTimeout: receiveTimeout ?? const Duration(milliseconds: 30000),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          ...?defaultHeaders,
        },
      ),
    );

    // Add logging in debug mode
    if (AppConfig.isDebug) {
      dio.interceptors.add(
        customLoggingInterceptor ?? DioLoggingInterceptors.standard(),
      );
    }

    return dio;
  }

  /// Create a Dio instance for file uploads/downloads
  static Dio createFileClient({
    String? baseUrl,
    Map<String, String>? defaultHeaders,
    Duration? connectTimeout,
    Duration? sendTimeout,
    Duration? receiveTimeout,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? AppConfig.apiBaseUrl,
        connectTimeout: connectTimeout ?? const Duration(minutes: 2),
        sendTimeout: sendTimeout ?? const Duration(minutes: 5),
        receiveTimeout: receiveTimeout ?? const Duration(minutes: 5),
        headers: {
          'Accept': 'application/json',
          ...?defaultHeaders,
        },
      ),
    );

    // Use minimal logging for file operations to avoid large data dumps
    if (AppConfig.isDebug) {
      dio.interceptors.add(DioLoggingInterceptors.minimal());
    }

    return dio;
  }

  /// Create a Dio instance for external API calls (non-backend)
  static Dio createExternalClient({
    required String baseUrl,
    Map<String, String>? defaultHeaders,
    Duration? connectTimeout,
    Duration? sendTimeout,
    Duration? receiveTimeout,
    DioLoggingInterceptor? customLoggingInterceptor,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: connectTimeout ?? const Duration(milliseconds: 15000),
        sendTimeout: sendTimeout ?? const Duration(milliseconds: 15000),
        receiveTimeout: receiveTimeout ?? const Duration(milliseconds: 15000),
        headers: {
          'Accept': 'application/json',
          ...?defaultHeaders,
        },
      ),
    );

    // Add logging in debug mode
    if (AppConfig.isDebug) {
      dio.interceptors.add(
        customLoggingInterceptor ?? DioLoggingInterceptors.standard(),
      );
    }

    return dio;
  }
}

/// Common Dio providers that can be used across packages

/// Main API client provider for backend calls
final apiDioProvider = Provider<Dio>((ref) {
  return DioProviderFactory.createApiClient();
});

/// File operations client provider
final fileDioProvider = Provider<Dio>((ref) {
  return DioProviderFactory.createFileClient();
});

/// Example of a specialized provider for a specific external service
final supabaseDioProvider = Provider<Dio>((ref) {
  return DioProviderFactory.createExternalClient(
    baseUrl: AppConfig.supabaseUrl,
    defaultHeaders: {
      'apikey': AppConfig.supabaseAnonKey,
    },
    customLoggingInterceptor: DioLoggingInterceptors.verbose(),
  );
});
