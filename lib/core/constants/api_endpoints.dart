/// Centralized API Endpoints registry for SmartPark AI
class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'https://api.smartpark.ai/v1';

  // AI Module Endpoints (Placeholders)
  static const String aiRecommendation = '$baseUrl/ai/parking-recommendation';
  static const String aiTrafficPrediction = '$baseUrl/ai/traffic-prediction';
  static const String aiRouteOptimization = '$baseUrl/ai/route-optimization';
  static const String aiOccupancyPrediction = '$baseUrl/ai/occupancy-prediction';

  // Payment Endpoints
  static const String razorpayCreateOrder = '$baseUrl/payments/create-order';
  static const String razorpayVerifyPayment = '$baseUrl/payments/verify-payment';
}
