import '../models/user_model.dart';

abstract class IUserRepository {
  Future<UserModel?> getUserProfile(String uid);
  Future<void> saveUserProfile(UserModel user);
  Stream<UserModel?> streamUserProfile(String uid);
}
