import '../data_source/users_remote_data_source.dart';
import '../models/models.dart';
import 'users_repository.dart';

class UsersRepositoryImpl implements UsersRepository {
  final UsersRemoteDataSource remoteDataSource;

  UsersRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserProfile> getCurrentUser() async {
    try {
      return await remoteDataSource.getCurrentUser();
    } catch (e) {
      throw Exception('Failed to get current user: $e');
    }
  }

  @override
  Future<UserPublic> getUser(String userId) async {
    try {
      return await remoteDataSource.getUser(userId);
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  @override
  Future<UserPublic> getUserByUsername(String username) async {
    try {
      return await remoteDataSource.getUserByUsername(username);
    } catch (e) {
      throw Exception('Failed to get user by username: $e');
    }
  }

  @override
  Future<UserProfile> updateUser(UserProfile user) async {
    try {
      return await remoteDataSource.updateUser(user);
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }
}
