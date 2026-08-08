import 'package:firebase_auth/firebase_auth.dart';
import '../../../models/user_model.dart';

/// Authentication Feature Domain Repository Interface
abstract class IAuthRepository {
  /// Stream of Firebase auth state changes
  Stream<User?> get authStateChanges;

  /// Currently signed-in Firebase User (null if not logged in)
  User? get currentUser;

  /// Email + Password login. Returns the user profile on success.
  Future<UserModel> login(String email, String password);

  /// Email + Password registration. Returns the user profile on success.
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
  });

  /// Google Sign-In. Returns the user profile on success.
  Future<UserModel?> signInWithGoogle();

  /// Sends a password reset email.
  Future<void> sendPasswordResetEmail(String email);

  /// Sends an email verification to the current user.
  Future<void> sendEmailVerification();

  /// Reloads the current user to refresh emailVerified state.
  Future<void> reloadCurrentUser();

  /// Retrieves the Firestore user profile for the current user.
  Future<UserModel?> getCurrentUserProfile();

  /// Signs out the current user from Firebase (and Google if applicable).
  Future<void> logout();
}
