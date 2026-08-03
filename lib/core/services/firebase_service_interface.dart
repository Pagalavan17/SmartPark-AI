/// Abstract Service Interface for Firebase Integration
abstract class IFirebaseService {
  Future<void> initializeFirebase();
  Future<String?> signInWithEmail(String email, String password);
  Future<String?> signUpWithEmail(String email, String password);
  Future<void> signOut();
  Future<void> logEvent(String name, Map<String, dynamic>? parameters);
  Future<void> recordCrash(dynamic error, StackTrace? stack);
}
