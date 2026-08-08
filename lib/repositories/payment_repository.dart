import '../models/payment_transaction_model.dart';

abstract class IPaymentRepository {
  Future<PaymentTransactionModel> recordTransaction(PaymentTransactionModel transaction);
  Future<List<PaymentTransactionModel>> getUserTransactions(String userId);
}
