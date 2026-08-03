import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/user_profile_model.dart';

/// Riverpod State Controller for Authentication
final authStateProvider = StateNotifierProvider<AuthController, AsyncValue<UserProfileModel?>>((ref) {
  return AuthController();
});

class AuthController extends StateNotifier<AsyncValue<UserProfileModel?>> {
  AuthController() : super(const AsyncValue.data(null));

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    // Implementation placeholder
    await Future.delayed(const Duration(seconds: 1));
    state = const AsyncValue.data(
      UserProfileModel(
        uid: 'user_1',
        name: 'Demo User',
        email: 'demo@smartpark.ai',
        phoneNumber: '+91 9876543210',
        vehicleNumber: 'TN 01 AB 1234',
        preferredLanguage: 'en',
      ),
    );
  }
}
