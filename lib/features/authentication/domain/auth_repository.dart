import '../../../models/user_profile_model.dart';

/// Authentication Feature Domain Repository Interface
abstract class IAuthRepository {
  Future<UserProfileModel?> login(String email, String password);
  Future<UserProfileModel?> register(String name, String email, String password, String phone);
  Future<void> logout();
  Future<UserProfileModel?> getCurrentUser();
}
