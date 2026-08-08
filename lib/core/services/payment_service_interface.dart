/// Abstract Service Interface for Razorpay Integration
abstract class IPaymentService {
  void initializePaymentGateway();
  Future<void> processPayment({
    required double amount,
    required String orderId,
    required String userEmail,
    required String userContact,
    required Function(String paymentId) onSuccess,
    required Function(String code, String message) onFailure,
  });
  void dispose();
}
