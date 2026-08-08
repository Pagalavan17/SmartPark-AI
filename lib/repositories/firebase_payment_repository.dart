import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/payment_transaction_model.dart';
import 'payment_repository.dart';

class FirebasePaymentRepository implements IPaymentRepository {
  final FirebaseFirestore? _firestore;
  final List<PaymentTransactionModel> _fallback = [];

  FirebasePaymentRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<PaymentTransactionModel> recordTransaction(PaymentTransactionModel transaction) async {
    try {
      if (_firestore != null) {
        await _firestore
            .collection('payments')
            .doc(transaction.transactionId)
            .set(transaction.toMap());
      }
    } catch (_) {}
    _fallback.insert(0, transaction);
    return transaction;
  }

  @override
  Future<List<PaymentTransactionModel>> getUserTransactions(String userId) async {
    try {
      if (_firestore != null) {
        final snapshot = await _firestore.collection('payments').where('userId', isEqualTo: userId).get();
        if (snapshot.docs.isNotEmpty) {
          return snapshot.docs.map((doc) => PaymentTransactionModel.fromMap(doc.data(), doc.id)).toList();
        }
      }
    } catch (_) {}
    return _fallback;
  }
}
