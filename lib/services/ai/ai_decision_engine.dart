import 'ai_adapter.dart';
import 'ai_config.dart';
import '../../models/parking_lot_model.dart';
import '../../models/prediction_model.dart';
import '../../models/digital_twin_model.dart';
import '../../models/reservation_model.dart';

import 'parking_prediction_service.dart';
import 'recommendation_engine.dart';
import 'explainable_ai_service.dart';
import 'adaptive_reservation_engine.dart';
import 'dynamic_pricing_engine.dart';
import 'parking_digital_twin_service.dart';

/// Master AI Decision Engine Coordinator for SmartPark AI
class AIDecisionEngine {
  final AIAdapter aiAdapter;
  final AIConfiguration aiConfig;

  final ParkingPredictionService predictionService;
  final RecommendationEngine recommendationEngine;
  final ExplainableAIService explainableService;
  final AdaptiveReservationEngine adaptiveEngine;
  final DynamicPricingEngine dynamicPricingEngine;
  final ParkingDigitalTwinService digitalTwinService;

  AIDecisionEngine({
    required this.aiAdapter,
    required this.aiConfig,
    required this.predictionService,
    required this.recommendationEngine,
    required this.explainableService,
    required this.adaptiveEngine,
    required this.dynamicPricingEngine,
    required this.digitalTwinService,
  });

  /// Evaluates and predicts multi-horizon occupancy via AI Adapter
  Future<PredictionModel> getOccupancyPrediction(ParkingLotModel parkingLot) async {
    final Map<String, dynamic> inputs = {
      'currentOccupancy': ((parkingLot.totalSlots - parkingLot.availableSlots) / parkingLot.totalSlots) * 100.0,
      'congestionLevel': parkingLot.congestionLevel,
      'availableSlots': parkingLot.availableSlots,
    };

    final predictions = await aiAdapter.predictOccupancy(inputs: inputs);

    return PredictionModel(
      parkingId: parkingLot.id,
      currentOccupancyPercentage: (inputs['currentOccupancy'] as double).roundToDouble(),
      predictedOccupancy15Min: predictions['15m'] ?? 80.0,
      predictedOccupancy30Min: predictions['30m'] ?? 85.0,
      predictedOccupancy1Hour: predictions['1h'] ?? 92.0,
      predictedOccupancy2Hours: predictions['2h'] ?? 70.0,
      bestArrivalTime: '10:15 AM (Low congestion window)',
      predictedWaitingTimeMins: parkingLot.availableSlots < 10 ? 8 : 2,
      trafficTrend: parkingLot.congestionLevel > 0.4 ? 'Increasing ↗' : 'Stable ➔',
      demandTrend: parkingLot.availableSlots < 15 ? 'High Demand 🔥' : 'Moderate Demand',
      dynamicPricingTrend: parkingLot.isPeakHour ? 'Price rising in 30m 📈' : 'Optimal Rate 👍',
      hourlyOccupancyTrend: const [35, 42, 50, 65, 76, 85, 92, 88, 74, 60, 48, 40],
    );
  }

  /// Calculates AI recommendation match score and confidence percentage
  Future<Map<String, double>> getRecommendationScore(ParkingLotModel parkingLot) async {
    final Map<String, dynamic> inputs = {
      'distanceKm': parkingLot.distanceInKm,
      'congestionLevel': parkingLot.congestionLevel,
      'rating': parkingLot.rating,
      'isEVChargingAvailable': parkingLot.isEVChargingAvailable,
      'availableSlots': parkingLot.availableSlots,
    };

    return aiAdapter.calculateRecommendationScore(inputs: inputs);
  }

  /// Generates human-readable bullet points explaining the recommendation
  Future<List<String>> getRecommendationExplanation(ParkingLotModel parkingLot) async {
    final Map<String, dynamic> inputs = {
      'distanceKm': parkingLot.distanceInKm,
      'isEVChargingAvailable': parkingLot.isEVChargingAvailable,
      'baseHourlyRate': parkingLot.baseHourlyRate,
      'availableSlots': parkingLot.availableSlots,
      'congestionLevel': parkingLot.congestionLevel,
    };

    return aiAdapter.generateExplanation(inputs: inputs);
  }

  /// Calculates real-time dynamic hourly pricing rate
  Future<double> getDynamicPricingRate(ParkingLotModel parkingLot) async {
    final Map<String, dynamic> inputs = {
      'baseHourlyRate': parkingLot.baseHourlyRate,
      'isPeakHour': parkingLot.isPeakHour,
      'congestionLevel': parkingLot.congestionLevel,
    };

    return aiAdapter.calculateDynamicPrice(inputs: inputs);
  }

  /// Fetches virtual Digital Twin telemetry state
  DigitalTwinModel getDigitalTwin(ParkingLotModel parkingLot) {
    return digitalTwinService.getFacilityDigitalTwin(parkingLot);
  }

  /// Evaluates and handles adaptive reservation re-routing if facility becomes full
  ReservationModel checkAdaptiveReassignment({
    required ReservationModel currentReservation,
    required List<ParkingLotModel> availableLots,
  }) {
    return adaptiveEngine.checkAndReassignIfNeeded(
      currentReservation: currentReservation,
      availableLots: availableLots,
    );
  }
}
