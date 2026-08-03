import '../../../models/user_profile_model.dart';

abstract class IProfileRepository {
  Future<UserProfileModel?> getProfile(String userId);
  Future<void> updateProfile(UserProfileModel profile);
}
