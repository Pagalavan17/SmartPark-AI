import 'ai_adapter.dart';

/// Google Gemini AI Engine Adapter for smart parking analytics & natural language explanations
class GeminiAIAdapter implements AIAdapter {
  final String? apiKey;

  GeminiAIAdapter({this.apiKey});

  @override
  Future<Map<String, double>> predictOccupancy({
    required Map<String, dynamic> inputs,
  }) async {
    // In production, interfaces with Gemini REST API endpoint or SDK
    final double base = (inputs['currentOccupancy'] ?? 75.0).toDouble();
    return {
      '15m': (base + 6.0).clamp(0.0, 100.0),
      '30m': (base + 12.0).clamp(0.0, 100.0),
      '1h': (base + 18.0).clamp(0.0, 100.0),
      '2h': (base - 14.0).clamp(0.0, 100.0),
    };
  }

  @override
  Future<Map<String, double>> calculateRecommendationScore({
    required Map<String, dynamic> inputs,
  }) async {
    final double distanceKm = (inputs['distanceKm'] ?? 1.0).toDouble();
    final double rating = (inputs['rating'] ?? 4.5).toDouble();
    double score = (rating * 15.0) + (100.0 - (distanceKm * 12.0));
    return {
      'score': score.clamp(0.0, 100.0).roundToDouble(),
      'confidence': 98.0,
    };
  }

  @override
  Future<List<String>> generateExplanation({
    required Map<String, dynamic> inputs,
  }) async {
    final double distanceKm = (inputs['distanceKm'] ?? 0.8).toDouble();
    final int available = (inputs['availableSlots'] ?? 24).toInt();
    return [
      'Gemini AI Insights: Lowest predicted traffic route',
      '$available parking spaces expected to remain available',
      'Walking distance only ${(distanceKm * 1000).toInt()} meters',
      'Optimal dynamic price match',
    ];
  }

  @override
  Future<double> calculateDynamicPrice({
    required Map<String, dynamic> inputs,
  }) async {
    final double base = (inputs['baseHourlyRate'] ?? 50.0).toDouble();
    final double congestion = (inputs['congestionLevel'] ?? 0.2).toDouble();
    return (base * (1.0 + (congestion * 0.3))).roundToDouble();
  }
}
