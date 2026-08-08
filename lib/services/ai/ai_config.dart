import 'package:equatable/equatable.dart';

/// Configuration layer defining weights and thresholds for AI inference
class AIConfiguration extends Equatable {
  final List<int> predictionIntervalMinutes; // [15, 30, 60, 120]
  final double confidenceThreshold; // e.g. 85.0%
  final double trafficWeight; // e.g. 0.25
  final double priceWeight; // e.g. 0.20
  final double distanceWeight; // e.g. 0.25
  final double evPreferenceWeight; // e.g. 0.15
  final double weatherWeight; // e.g. 0.15

  const AIConfiguration({
    this.predictionIntervalMinutes = const [15, 30, 60, 120],
    this.confidenceThreshold = 85.0,
    this.trafficWeight = 0.25,
    this.priceWeight = 0.20,
    this.distanceWeight = 0.25,
    this.evPreferenceWeight = 0.15,
    this.weatherWeight = 0.15,
  });

  AIConfiguration copyWith({
    List<int>? predictionIntervalMinutes,
    double? confidenceThreshold,
    double? trafficWeight,
    double? priceWeight,
    double? distanceWeight,
    double? evPreferenceWeight,
    double? weatherWeight,
  }) {
    return AIConfiguration(
      predictionIntervalMinutes: predictionIntervalMinutes ?? this.predictionIntervalMinutes,
      confidenceThreshold: confidenceThreshold ?? this.confidenceThreshold,
      trafficWeight: trafficWeight ?? this.trafficWeight,
      priceWeight: priceWeight ?? this.priceWeight,
      distanceWeight: distanceWeight ?? this.distanceWeight,
      evPreferenceWeight: evPreferenceWeight ?? this.evPreferenceWeight,
      weatherWeight: weatherWeight ?? this.weatherWeight,
    );
  }

  @override
  List<Object?> get props => [
        predictionIntervalMinutes,
        confidenceThreshold,
        trafficWeight,
        priceWeight,
        distanceWeight,
        evPreferenceWeight,
        weatherWeight,
      ];
}
