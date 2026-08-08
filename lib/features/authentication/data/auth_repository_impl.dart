import 'package:firebase_auth/firebase_auth.dart';
import '../../../models/user_model.dart';
import '../domain/auth_repository.dart';
import 'auth_remote_data_source.dart';

/// Concrete implementation of IAuthRepository using Firebase
class AuthRepositoryImpl implements IAuthRepository {
  final AuthRemoteDataSource _dataSource;

  AuthRepositoryImpl({AuthRemoteDataSource? dataSource})
      : _dataSource = dataSource ?? AuthRemoteDataSource();

  @override
  Stream<User?> get authStateChanges => _dataSource.authStateChanges;

  @override
  User? get currentUser => _dataSource.currentUser;

  @override
  Future<UserModel> login(String email, String password) =>
      _dataSource.loginWithEmail(email, password);

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
  }) =>
      _dataSource.registerWithEmail(
        name: name,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
      );

  @override
  Future<UserModel?> signInWithGoogle() => _dataSource.signInWithGoogle();

  @override
  Future<void> sendPasswordResetEmail(String email) =>
      _dataSource.sendPasswordResetEmail(email);

  @override
  Future<void> sendEmailVerification() => _dataSource.sendEmailVerification();

  @override
  Future<void> reloadCurrentUser() => _dataSource.reloadCurrentUser();

  @override
  Future<UserModel?> getCurrentUserProfile() =>
      _dataSource.getCurrentUserProfile();

  @override
  Future<void> logout() => _dataSource.logout();
}
