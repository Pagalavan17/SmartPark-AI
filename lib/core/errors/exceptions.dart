// Custom Exceptions for SmartPark AI Architecture

class FirestoreException implements Exception {
  final String message;
  final String? code;
  FirestoreException(this.message, {this.code});
  @override
  String toString() => 'FirestoreException: $message (Code: $code)';
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
  @override
  String toString() => 'NetworkException: $message';
}

class RepositoryException implements Exception {
  final String message;
  final dynamic originalError;
  RepositoryException(this.message, {this.originalError});
  @override
  String toString() => 'RepositoryException: $message (Original: $originalError)';
}

class AuthenticationException implements Exception {
  final String message;
  final String? code;
  AuthenticationException(this.message, {this.code});
  @override
  String toString() => 'AuthenticationException: $message';

  /// Maps Firebase Auth error codes to user-friendly messages
  static String fromFirebaseCode(String code) {
    switch (code) {
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password. Please try again.';
      case 'user-not-found':
        return 'No account found with this email. Please register first.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'weak-password':
        return 'Password is too weak. Please choose a stronger password.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please wait a moment and try again.';
      case 'network-request-failed':
        return 'Network error. Please check your connection and try again.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled. Please contact support.';
      case 'credential-already-in-use':
        return 'This credential is already associated with a different account.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with the same email but different sign-in method.';
      case 'requires-recent-login':
        return 'Please sign in again to continue.';
      case 'popup-closed-by-user':
        return 'Sign-in was cancelled.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
