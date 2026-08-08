abstract class IPaymentRepository {
  Future<String> createRazorpayOrder(double amount);
  Future<bool> verifyPaymentSignature(String paymentId, String orderId, String signature);
}
