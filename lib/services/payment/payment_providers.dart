import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/payment_transaction_model.dart';
import '../../providers/repository_providers.dart';
import '../notification/notification_providers.dart';
import 'payment_service.dart';
import 'invoice_service.dart';
import 'refund_service.dart';

final paymentServiceProvider = Provider<PaymentService>((ref) {
  final service = PaymentService(
    paymentRepository: ref.watch(paymentRepositoryProvider),
    notificationService: ref.watch(notificationServiceProvider),
  );
  ref.onDispose(() => service.dispose());
  return service;
});

final invoiceServiceProvider = Provider<InvoiceService>((ref) {
  return InvoiceService();
});

final refundServiceProvider = Provider<RefundService>((ref) {
  return RefundService(paymentRepository: ref.watch(paymentRepositoryProvider));
});

final userTransactionsProvider = FutureProvider.family<List<PaymentTransactionModel>, String>((ref, userId) {
  final repo = ref.watch(paymentRepositoryProvider);
  return repo.getUserTransactions(userId);
});
