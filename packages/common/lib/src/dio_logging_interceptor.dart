import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Comprehensive Dio logging interceptor for debugging network requests
class DioLoggingInterceptor extends Interceptor {
  final bool logRequests;
  final bool logResponses;
  final bool logErrors;
  final bool logHeaders;
  final bool logRequestBody;
  final bool logResponseBody;

  const DioLoggingInterceptor({
    this.logRequests = true,
    this.logResponses = true,
    this.logErrors = true,
    this.logHeaders = false,
    this.logRequestBody = true,
    this.logResponseBody = true,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (logRequests && kDebugMode) {
      log('🚀 Sending ${options.method.toUpperCase()} request');
      log('🌍 URL: ${options.baseUrl}${options.path}');

      if (options.queryParameters.isNotEmpty) {
        log('🔍 Query params: ${options.queryParameters}');
      }

      if (logHeaders && options.headers.isNotEmpty) {
        log('📋 Headers: ${_formatHeaders(options.headers)}');
      }

      if (logRequestBody && options.data != null) {
        log('📤 Request body: ${_formatData(options.data)}');
      }

      log('⏱️  Request timeout: ${options.sendTimeout?.inMilliseconds}ms');
      log('-------------------------');
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (logResponses && kDebugMode) {
      final statusCode = response.statusCode ?? 0;
      final isSuccess = statusCode >= 200 && statusCode < 300;

      log('⬅️ Received network response');
      log('${isSuccess ? '✅' : '⚠️'} Status: $statusCode ${isSuccess ? '✅' : '⚠️'}');
      log('🌍 URL: ${response.requestOptions.baseUrl}${response.requestOptions.path}');

      if (response.requestOptions.queryParameters.isNotEmpty) {
        log('🔍 Query params: ${response.requestOptions.queryParameters}');
      }

      if (logHeaders && response.headers.map.isNotEmpty) {
        log('📋 Response headers: ${_formatHeaders(response.headers.map)}');
      }

      if (logResponseBody && response.data != null) {
        log('📥 Response body: ${_formatData(response.data)}');
      }

      log('⏱️  Response time: ${response.requestOptions.receiveTimeout?.inMilliseconds}ms');
      log('-------------------------');
    }

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (logErrors && kDebugMode) {
      log('❌ Dio Error occurred!');
      log('❌ Error type: ${err.type}');
      log('❌ Error message: ${err.message}');
      log('❌ URL: ${err.requestOptions.uri}');

      if (err.requestOptions.data != null) {
        log('❌ Request data: ${_formatData(err.requestOptions.data)}');
      }

      if (logHeaders && err.requestOptions.headers.isNotEmpty) {
        log('❌ Request headers: ${_formatHeaders(err.requestOptions.headers)}');
      }

      if (err.response != null) {
        log('❌ Response status: ${err.response?.statusCode}');
        log('❌ Response headers: ${_formatHeaders(err.response?.headers.map ?? {})}');

        if (logResponseBody && err.response?.data != null) {
          log('❌ Response error body: ${_formatData(err.response?.data)}');
        }
      }

      log('-------------------------');
    }

    super.onError(err, handler);
  }

  /// Format headers for logging (hide sensitive information)
  String _formatHeaders(Map<String, dynamic> headers) {
    final sanitizedHeaders = <String, dynamic>{};

    headers.forEach((key, value) {
      if (_isSensitiveHeader(key)) {
        sanitizedHeaders[key] = '***HIDDEN***';
      } else {
        sanitizedHeaders[key] = value;
      }
    });

    return sanitizedHeaders.toString();
  }

  /// Check if header contains sensitive information
  bool _isSensitiveHeader(String headerName) {
    final lowerName = headerName.toLowerCase();
    return lowerName.contains('authorization') ||
        lowerName.contains('token') ||
        lowerName.contains('password') ||
        lowerName.contains('secret') ||
        lowerName.contains('key');
  }

  /// Format request/response data for logging
  String _formatData(dynamic data) {
    if (data == null) return 'null';

    try {
      // Limit the size of logged data to prevent overwhelming logs
      final dataString = data.toString();
      if (dataString.length > 1000) {
        return '${dataString.substring(0, 1000)}... (truncated)';
      }
      return dataString;
    } catch (e) {
      return 'Could not format data: $e';
    }
  }
}

/// Factory methods for different logging levels
class DioLoggingInterceptors {
  /// Minimal logging - only errors and status
  static DioLoggingInterceptor minimal() {
    return const DioLoggingInterceptor(
      logRequests: false,
      logResponses: true,
      logErrors: true,
      logHeaders: false,
      logRequestBody: false,
      logResponseBody: false,
    );
  }

  /// Standard logging - requests, responses, and errors
  static DioLoggingInterceptor standard() {
    return const DioLoggingInterceptor(
      logRequests: true,
      logResponses: true,
      logErrors: true,
      logHeaders: false,
      logRequestBody: true,
      logResponseBody: true,
    );
  }

  /// Verbose logging - everything including headers
  static DioLoggingInterceptor verbose() {
    return const DioLoggingInterceptor(
      logRequests: true,
      logResponses: true,
      logErrors: true,
      logHeaders: true,
      logRequestBody: true,
      logResponseBody: true,
    );
  }

  /// Only errors
  static DioLoggingInterceptor errorsOnly() {
    return const DioLoggingInterceptor(
      logRequests: false,
      logResponses: false,
      logErrors: true,
      logHeaders: false,
      logRequestBody: false,
      logResponseBody: false,
    );
  }
}
