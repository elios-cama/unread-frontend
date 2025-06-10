import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:authentication/authentication.dart';
import 'package:common/common.dart';

/// Repository for authentication-related API calls
class AuthRepository {
  final Dio _dio;

  AuthRepository(this._dio);

  /// Get current user profile (requires authentication)
  Future<UserProfile> getCurrentUser() async {
    try {
      final response = await _dio.get('/api/v1/users/me');

      return UserProfile.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception('Failed to get user profile: ${e.message}');
    }
  }

  /// Update username (requires authentication)
  Future<UserProfile> updateUsername(String newUsername) async {
    try {
      final response = await _dio.put(
        '/api/v1/users/me',
        data: {'username': newUsername},
      );

      return UserProfile.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception('Failed to update username: ${e.message}');
    }
  }

  /// Check username availability (requires authentication)
  Future<bool> checkUsernameAvailability(String username) async {
    try {
      final response = await _dio.get('/api/v1/users/check-username/$username');

      // Assuming the API returns {"available": true/false}
      return response.data['available'] as bool;
    } on DioException catch (e) {
      throw Exception('Failed to check username: ${e.message}');
    }
  }

  /// Delete user account (requires authentication)
  Future<void> deleteAccount() async {
    try {
      await _dio.delete('/api/v1/users/me');
    } on DioException catch (e) {
      throw Exception('Failed to delete account: ${e.message}');
    }
  }
}

/// Authenticated repository provider
/// This automatically injects JWT tokens for all API calls
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final authenticatedDio = ref.watch(authenticatedDioProvider);
  return AuthRepository(authenticatedDio);
});
