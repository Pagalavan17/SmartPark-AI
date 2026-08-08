import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ai_adapter.dart';
import 'dummy_ai_adapter.dart';
import 'gemini_ai_adapter.dart';
import 'local_ml_adapter.dart';
import 'ai_config.dart';
import 'ai_decision_engine.dart';

import 'parking_prediction_service.dart';
import 'recommendation_engine.dart';
import 'explainable_ai_service.dart';
import 'adaptive_reservation_engine.dart';
import 'dynamic_pricing_engine.dart';
import 'parking_digital_twin_service.dart';

/// Provider for dynamic AI Adapter selection (Dummy, Gemini, LocalML)
final aiAdapterTypeProvider = StateProvider<String>((ref) => 'Dummy');

final aiAdapterProvider = Provider<AIAdapter>((ref) {
  final type = ref.watch(aiAdapterTypeProvider);
  switch (type) {
    case 'Gemini':
      return GeminiAIAdapter();
    case 'LocalML':
      return LocalMLAdapter();
    case 'Dummy':
    default:
      return DummyAIAdapter();
  }
});

final aiConfigurationProvider = StateProvider<AIConfiguration>((ref) {
  return const AIConfiguration();
});

/// Individual AI Sub-Services Providers
final subPredictionServiceProvider = Provider<ParkingPredictionService>((ref) => ParkingPredictionService());
final subRecommendationEngineProvider = Provider<RecommendationEngine>((ref) => RecommendationEngine());
final subExplainableServiceProvider = Provider<ExplainableAIService>((ref) => ExplainableAIService());
final subAdaptiveEngineProvider = Provider<AdaptiveReservationEngine>((ref) => AdaptiveReservationEngine());
final subDynamicPricingEngineProvider = Provider<DynamicPricingEngine>((ref) => DynamicPricingEngine());
final subDigitalTwinServiceProvider = Provider<ParkingDigitalTwinService>((ref) => ParkingDigitalTwinService());

/// Central Master AI Decision Engine Provider
final aiDecisionEngineProvider = Provider<AIDecisionEngine>((ref) {
  return AIDecisionEngine(
    aiAdapter: ref.watch(aiAdapterProvider),
    aiConfig: ref.watch(aiConfigurationProvider),
    predictionService: ref.watch(subPredictionServiceProvider),
    recommendationEngine: ref.watch(subRecommendationEngineProvider),
    explainableService: ref.watch(subExplainableServiceProvider),
    adaptiveEngine: ref.watch(subAdaptiveEngineProvider),
    dynamicPricingEngine: ref.watch(subDynamicPricingEngineProvider),
    digitalTwinService: ref.watch(subDigitalTwinServiceProvider),
  );
});
