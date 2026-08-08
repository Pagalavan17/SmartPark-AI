import 'ai_adapter.dart';

/// Edge Device Local ML Model Execution Adapter (TensorFlow Lite / ONNX)
class LocalMLAdapter implements AIAdapter {
  @override
  Future<Map<String, double>> predictOccupancy({
    required Map<String, dynamic> inputs,
  }) async {
    final double base = (inputs['currentOccupancy'] ?? 75.0).toDouble();
    return {
      '15m': (base + 4.0).clamp(0.0, 100.0),
      '30m': (base + 8.0).clamp(0.0, 100.0),
      '1h': (base + 14.0).clamp(0.0, 100.0),
      '2h': (base - 8.0).clamp(0.0, 100.0),
    };
  }

  @override
  Future<Map<String, double>> calculateRecommendationScore({
    required Map<String, dynamic> inputs,
  }) async {
    return {
      'score': 94.0,
      'confidence': 95.0,
    };
  }

  @override
  Future<List<String>> generateExplanation({
    required Map<String, dynamic> inputs,
  }) async {
    return [
      'Local Edge Inference: Fast low-latency recommendation',
      'Stable flow predicted for next 60 minutes',
      'Recommended based on user historical preferences',
    ];
  }

  @override
  Future<double> calculateDynamicPrice({
    required Map<String, dynamic> inputs,
  }) async {
    final double base = (inputs['baseHourlyRate'] ?? 50.0).toDouble();
    return base;
  }
}
