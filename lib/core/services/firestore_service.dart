import 'package:cloud_firestore/cloud_firestore.dart';
import '../errors/exceptions.dart';

/// Reusable Core Firestore Service for Querying, Transactions, and Batch operations
class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance {
    // Configure settings for offline persistence
    try {
      _firestore.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );
    } catch (_) {}
  }

  CollectionReference<Map<String, dynamic>> collection(String path) {
    return _firestore.collection(path);
  }

  DocumentReference<Map<String, dynamic>> doc(String path) {
    return _firestore.doc(path);
  }

  /// Executes action with retry policy
  Future<T> runWithRetry<T>(Future<T> Function() action, {int maxAttempts = 3}) async {
    int attempts = 0;
    while (attempts < maxAttempts) {
      try {
        attempts++;
        return await action();
      } catch (e) {
        if (attempts >= maxAttempts) {
          throw FirestoreException('Action failed after $maxAttempts attempts: ${e.toString()}');
        }
        await Future.delayed(Duration(milliseconds: 500 * attempts));
      }
    }
    throw FirestoreException('Failed to execute action');
  }

  /// Batch Write Executor
  Future<void> runBatch(void Function(WriteBatch batch) batchHandler) async {
    try {
      final batch = _firestore.batch();
      batchHandler(batch);
      await batch.commit();
    } catch (e) {
      throw FirestoreException('Batch operation failed: ${e.toString()}');
    }
  }

  /// Transaction Executor
  Future<T> runTransaction<T>(Future<T> Function(Transaction tx) transactionHandler) async {
    try {
      return await _firestore.runTransaction(transactionHandler);
    } catch (e) {
      throw FirestoreException('Transaction failed: ${e.toString()}');
    }
  }
}
