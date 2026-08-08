import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../models/user_model.dart';
import '../../../core/errors/exceptions.dart';
import '../data/auth_repository_impl.dart';
import '../domain/auth_repository.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Auth Repository Provider
// ─────────────────────────────────────────────────────────────────────────────

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return AuthRepositoryImpl();
});

// ─────────────────────────────────────────────────────────────────────────────
// Firebase Auth State Stream Provider
// Reacts to Firebase login/logout automatically (persistent session)
// ─────────────────────────────────────────────────────────────────────────────

final firebaseAuthStateProvider = StreamProvider<User?>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.authStateChanges;
});

// ─────────────────────────────────────────────────────────────────────────────
// Auth Controller State
// ─────────────────────────────────────────────────────────────────────────────

class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? errorMessage;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
  });

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? errorMessage,
    bool clearUser = false,
    bool clearError = false,
  }) {
    return AuthState(
      user: clearUser ? null : user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Auth Controller StateNotifier
// ─────────────────────────────────────────────────────────────────────────────

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref.read(authRepositoryProvider));
});

class AuthController extends StateNotifier<AuthState> {
  final IAuthRepository _repository;

  AuthController(this._repository) : super(const AuthState());

  // ────────── EMAIL LOGIN ──────────

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _repository.login(email, password);
      state = state.copyWith(isLoading: false, user: user, clearError: true);
      return true;
    } on AuthenticationException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      return false;
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Something went wrong. Please try again.',
      );
      return false;
    }
  }

  // ────────── REGISTRATION ──────────

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _repository.register(
        name: name,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
      );
      state = state.copyWith(isLoading: false, user: user, clearError: true);
      return true;
    } on AuthenticationException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      return false;
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Something went wrong. Please try again.',
      );
      return false;
    }
  }

  // ────────── GOOGLE SIGN-IN ──────────

  Future<bool?> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _repository.signInWithGoogle();
      if (user == null) {
        // User cancelled — not an error
        state = state.copyWith(isLoading: false);
        return null;
      }
      state = state.copyWith(isLoading: false, user: user, clearError: true);
      return true;
    } on AuthenticationException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      return false;
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Google Sign-In failed. Please try again.',
      );
      return false;
    }
  }

  // ────────── PASSWORD RESET ──────────

  Future<bool> resetPassword(String email) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repository.sendPasswordResetEmail(email);
      state = state.copyWith(isLoading: false, clearError: true);
      return true;
    } on AuthenticationException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      return false;
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Something went wrong. Please try again.',
      );
      return false;
    }
  }

  // ────────── EMAIL VERIFICATION ──────────

  Future<bool> resendEmailVerification() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repository.sendEmailVerification();
      state = state.copyWith(isLoading: false, clearError: true);
      return true;
    } on AuthenticationException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
      return false;
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to send verification email.',
      );
      return false;
    }
  }

  /// Reloads Firebase user and checks emailVerified.
  /// Returns true if now verified.
  Future<bool> reloadVerificationStatus() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repository.reloadCurrentUser();
      final firebaseUser = _repository.currentUser;
      if (firebaseUser == null) {
        state = state.copyWith(isLoading: false);
        return false;
      }
      final isVerified = firebaseUser.emailVerified;
      if (isVerified && state.user != null) {
        final updatedUser = state.user!.copyWith(isVerified: true);
        state = state.copyWith(isLoading: false, user: updatedUser, clearError: true);
      } else {
        state = state.copyWith(isLoading: false);
      }
      return isVerified;
    } catch (_) {
      state = state.copyWith(isLoading: false);
      return false;
    }
  }

  // ────────── LOGOUT ──────────

  Future<void> logout() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repository.logout();
      state = const AuthState(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Logout failed. Please try again.',
      );
    }
  }

  // ────────── LOAD PROFILE ──────────

  Future<void> loadCurrentUserProfile() async {
    try {
      final profile = await _repository.getCurrentUserProfile();
      if (profile != null) {
        state = state.copyWith(user: profile);
      }
    } catch (_) {}
  }

  // ────────── CLEAR ERROR ──────────

  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Legacy authStateProvider (kept for backward compatibility with existing code)
// ─────────────────────────────────────────────────────────────────────────────
// ignore: deprecated_member_use_from_same_package
@Deprecated('Use authControllerProvider instead')
final authStateProvider = authControllerProvider;
