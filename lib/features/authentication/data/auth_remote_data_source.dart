import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../core/errors/exceptions.dart';
import '../../../models/user_model.dart';

/// Remote Data Source for Authentication — wraps FirebaseAuth, GoogleSignIn, and Firestore
class AuthRemoteDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  AuthRemoteDataSource({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    GoogleSignIn? googleSignIn,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  // ─────────────────────────────────────────
  // AUTH STATE
  // ─────────────────────────────────────────

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  // ─────────────────────────────────────────
  // EMAIL / PASSWORD
  // ─────────────────────────────────────────

  Future<UserModel> loginWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user!;
      // Reload to get latest emailVerified state
      await user.reload();
      final refreshed = _auth.currentUser!;

      // Update lastLogin in Firestore
      await _updateLastLogin(
        uid: refreshed.uid,
        isVerified: refreshed.emailVerified,
        email: refreshed.email,
        name: refreshed.displayName,
        avatarUrl: refreshed.photoURL,
      );

      return await _getUserProfile(refreshed);
    } on FirebaseAuthException catch (e) {
      throw AuthenticationException(
        AuthenticationException.fromFirebaseCode(e.code),
        code: e.code,
      );
    } catch (e) {
      throw AuthenticationException('Something went wrong. Please try again.');
    }
  }

  Future<UserModel> registerWithEmail({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user!;

      // Update Firebase displayName
      await user.updateDisplayName(name.trim());

      // Send verification email
      await user.sendEmailVerification();

      // Create Firestore profile
      final profile = UserModel(
        uid: user.uid,
        email: email.trim(),
        name: name.trim(),
        phoneNumber: phoneNumber.trim(),
        avatarUrl: user.photoURL ?? '',
        rewardPoints: 0,
        driverScore: 5.0,
        walletBalance: 0.0,
        savedVehicleIds: const [],
        createdAt: DateTime.now(),
        isVerified: false,
        isGoogleUser: false,
      );

      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(profile.toFirestoreCreateMap());

      return profile;
    } on FirebaseAuthException catch (e) {
      throw AuthenticationException(
        AuthenticationException.fromFirebaseCode(e.code),
        code: e.code,
      );
    } catch (e) {
      throw AuthenticationException('Something went wrong. Please try again.');
    }
  }

  // ─────────────────────────────────────────
  // GOOGLE SIGN-IN
  // ─────────────────────────────────────────

  /// Shared helper to handle Firestore profile creation/updating after Firebase Auth
  Future<UserModel> _handleFirebaseUserSignIn(User user) async {
    final docRef = _firestore.collection('users').doc(user.uid);
    final doc = await docRef.get();

    if (!doc.exists || doc.data() == null) {
      // New Google user — create profile
      final profile = UserModel(
        uid: user.uid,
        email: user.email ?? '',
        name: user.displayName ?? 'Google User',
        phoneNumber: user.phoneNumber ?? '',
        avatarUrl: user.photoURL ?? '',
        rewardPoints: 0,
        driverScore: 5.0,
        walletBalance: 0.0,
        savedVehicleIds: const [],
        createdAt: DateTime.now(),
        isVerified: true,
        isGoogleUser: true,
      );
      await docRef.set(profile.toFirestoreCreateMap());
      return profile;
    } else {
      // Existing user — only update login-related fields
      await docRef.update({
        'lastLogin': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'isVerified': true,
        'isGoogleUser': true,
        if (user.photoURL != null && user.photoURL!.isNotEmpty)
          'avatarUrl': user.photoURL,
        if (user.email != null && user.email!.isNotEmpty)
          'email': user.email,
        if (user.displayName != null && user.displayName!.isNotEmpty)
          'name': user.displayName,
      });
      return UserModel.fromMap(doc.data()!, doc.id);
    }
  }

  /// Android Google Sign-In
  Future<UserModel?> signInWithGoogle() async {
    debugPrint('GOOGLE AUTH PLATFORM: ANDROID');
    try {
      final googleAccount = await _googleSignIn.signIn();
      if (googleAccount == null) {
        // User cancelled
        return null;
      }

      final googleAuth = await googleAccount.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user!;

      return await _handleFirebaseUserSignIn(user);
    } on FirebaseAuthException catch (e) {
      debugPrint('GOOGLE AUTH CODE: ${e.code}');
      debugPrint('GOOGLE AUTH MESSAGE: ${e.message}');
      throw AuthenticationException(
        AuthenticationException.fromFirebaseCode(e.code),
        code: e.code,
      );
    } catch (e) {
      debugPrint('GOOGLE AUTH ERROR: $e');
      // Don't surface cancellation as error
      if (e.toString().contains('sign_in_canceled') ||
          e.toString().contains('cancelled')) {
        return null;
      }
      throw AuthenticationException('Something went wrong. Please try again.');
    }
  }

  // ─────────────────────────────────────────
  // EMAIL VERIFICATION
  // ─────────────────────────────────────────

  Future<void> sendEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } on FirebaseAuthException catch (e) {
      throw AuthenticationException(
        AuthenticationException.fromFirebaseCode(e.code),
        code: e.code,
      );
    }
  }

  Future<void> reloadCurrentUser() async {
    try {
      await _auth.currentUser?.reload();
    } catch (_) {}
  }

  // ─────────────────────────────────────────
  // PASSWORD RESET
  // ─────────────────────────────────────────

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw AuthenticationException(
        AuthenticationException.fromFirebaseCode(e.code),
        code: e.code,
      );
    } catch (e) {
      throw AuthenticationException('Something went wrong. Please try again.');
    }
  }

  // ─────────────────────────────────────────
  // PROFILE
  // ─────────────────────────────────────────

  Future<UserModel?> getCurrentUserProfile() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    return await _getUserProfile(user);
  }

  Future<UserModel> _getUserProfile(User user) async {
    try {
      final doc =
          await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromMap(doc.data()!, doc.id);
      }
    } catch (_) {}

    // Fallback: construct from Firebase user
    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? 'User',
      phoneNumber: user.phoneNumber ?? '',
      avatarUrl: user.photoURL ?? '',
      rewardPoints: 0,
      driverScore: 5.0,
      walletBalance: 0.0,
      savedVehicleIds: const [],
      createdAt: DateTime.now(),
      isVerified: user.emailVerified,
      isGoogleUser: user.providerData.any((p) => p.providerId == 'google.com'),
    );
  }

  Future<void> _updateLastLogin({
    required String uid,
    required bool isVerified,
    String? email,
    String? name,
    String? avatarUrl,
  }) async {
    try {
      final docRef = _firestore.collection('users').doc(uid);
      await docRef.set(
        {
          'lastLogin': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
          'isVerified': isVerified,
          if (email != null && email.isNotEmpty) 'email': email,
          if (name != null && name.isNotEmpty) 'name': name,
          if (avatarUrl != null && avatarUrl.isNotEmpty) 'avatarUrl': avatarUrl,
        },
        SetOptions(merge: true),
      );
    } catch (_) {
      // Non-critical — swallow Firestore errors for login updates
    }
  }

  // ─────────────────────────────────────────
  // LOGOUT
  // ─────────────────────────────────────────

  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw AuthenticationException('Logout failed. Please try again.');
    }
    // Silently sign out Google — non-critical
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
  }
}

