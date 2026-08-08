import '../../models/payment_transaction_model.dart';
import '../../repositories/payment_repository.dart';

/// Refund Workflow Service processing cancellations & partial/full refunds
class RefundService {
  final IPaymentRepository paymentRepository;

  RefundService({required this.paymentRepository});

  Future<PaymentTransactionModel> processRefund({
    required String transactionId,
    required double refundAmount,
    required String reason,
  }) async {
    final refundTx = PaymentTransactionModel(
      transactionId: 'REF-${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}',
      reservationId: 'RES-REF',
      userId: 'user_1',
      amount: refundAmount,
      currency: 'INR',
      paymentMethod: 'Razorpay Refund',
      status: 'Refunded',
      invoiceUrl: '',
      timestamp: DateTime.now(),
    );

    return await paymentRepository.recordTransaction(refundTx);
  }
}
