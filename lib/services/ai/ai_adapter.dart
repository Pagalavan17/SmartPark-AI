/// Abstract contract interface for pluggable AI engines in SmartPark AI
abstract class AIAdapter {
  /// Predicts future occupancy percentages across multiple time horizons (15m, 30m, 1h, 2h)
  Future<Map<String, double>> predictOccupancy({
    required Map<String, dynamic> inputs,
  });

  /// Calculates an AI recommendation match score (0-100) and confidence percentage
  Future<Map<String, double>> calculateRecommendationScore({
    required Map<String, dynamic> inputs,
  });

  /// Generates natural language bullet points explaining why a parking lot was recommended
  Future<List<String>> generateExplanation({
    required Map<String, dynamic> inputs,
  });

  /// Computes real-time dynamic hourly pricing rate
  Future<double> calculateDynamicPrice({
    required Map<String, dynamic> inputs,
  });
}
