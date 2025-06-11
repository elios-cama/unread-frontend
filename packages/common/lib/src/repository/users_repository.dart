import '../models/models.dart';

abstract class UsersRepository {
  Future<UserProfile> getCurrentUser();
  Future<UserPublic> getUser(String userId);
  Future<UserPublic> getUserByUsername(String username);
  Future<UserProfile> updateUser(UserProfile user);
}
