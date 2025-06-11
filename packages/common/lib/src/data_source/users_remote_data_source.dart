import 'package:dio/dio.dart';
import '../models/models.dart';

abstract class UsersRemoteDataSource {
  Future<UserProfile> getCurrentUser();
  Future<UserPublic> getUser(String userId);
  Future<UserPublic> getUserByUsername(String username);
  Future<UserProfile> updateUser(UserProfile user);
}

class UsersRemoteDataSourceImpl implements UsersRemoteDataSource {
  final Dio dio;

  UsersRemoteDataSourceImpl(this.dio);

  @override
  Future<UserProfile> getCurrentUser() async {
    try {
      final response = await dio.get('/api/v1/users/me');
      return UserProfile.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception('Failed to fetch current user: ${e.message}');
    }
  }

  @override
  Future<UserPublic> getUser(String userId) async {
    try {
      final response = await dio.get('/api/v1/users/$userId');
      return UserPublic.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception('Failed to fetch user: ${e.message}');
    }
  }

  @override
  Future<UserPublic> getUserByUsername(String username) async {
    try {
      final response = await dio.get('/api/v1/users/username/$username');
      return UserPublic.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception('Failed to fetch user by username: ${e.message}');
    }
  }

  @override
  Future<UserProfile> updateUser(UserProfile user) async {
    try {
      final response = await dio.put(
        '/api/v1/users/me',
        data: {
          'username': user.username,
          if (user.avatarUrl != null) 'avatar_url': user.avatarUrl,
        },
      );
      return UserProfile.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception('Failed to update user: ${e.message}');
    }
  }
}
