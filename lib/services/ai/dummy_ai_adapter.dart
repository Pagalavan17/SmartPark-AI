import 'ai_adapter.dart';

/// Deterministic offline mock AI adapter for testing and offline fallback
class DummyAIAdapter implements AIAdapter {
  @override
  Future<Map<String, double>> predictOccupancy({
    required Map<String, dynamic> inputs,
  }) async {
    final double base = (inputs['currentOccupancy'] ?? 75.0).toDouble();
    return {
      '15m': (base + 5.0).clamp(0.0, 100.0),
      '30m': (base + 10.0).clamp(0.0, 100.0),
      '1h': (base + 16.0).clamp(0.0, 100.0),
      '2h': (base - 10.0).clamp(0.0, 100.0),
    };
  }

  @override
  Future<Map<String, double>> calculateRecommendationScore({
    required Map<String, dynamic> inputs,
  }) async {
    final double distanceKm = (inputs['distanceKm'] ?? 1.0).toDouble();
    final double congestion = (inputs['congestionLevel'] ?? 0.2).toDouble();
    double score = 100.0 - (distanceKm * 10.0) - (congestion * 25.0);
    return {
      'score': score.clamp(0.0, 100.0).roundToDouble(),
      'confidence': 96.0,
    };
  }

  @override
  Future<List<String>> generateExplanation({
    required Map<String, dynamic> inputs,
  }) async {
    final double distanceKm = (inputs['distanceKm'] ?? 1.0).toDouble();
    final bool isEV = inputs['isEVChargingAvailable'] ?? false;
    final double baseRate = (inputs['baseHourlyRate'] ?? 50.0).toDouble();

    final List<String> bullets = [
      'Lowest predicted route traffic',
      'High probability of immediate spot availability',
      'Walking distance only ${(distanceKm * 1000).toInt()} meters',
      'Competitive rate (₹${baseRate.toInt()}/hr)',
    ];

    if (isEV) {
      bullets.add('EV fast-charging station available on site');
    }
    return bullets;
  }

  @override
  Future<double> calculateDynamicPrice({
    required Map<String, dynamic> inputs,
  }) async {
    final double base = (inputs['baseHourlyRate'] ?? 50.0).toDouble();
    final bool isPeak = inputs['isPeakHour'] ?? false;
    return isPeak ? (base * 1.20).roundToDouble() : base;
  }
}
