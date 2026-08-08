import '../../models/ai_recommendation_model.dart';
import '../../models/traffic_data_model.dart';

/// Abstract Service Interface for SmartPark AI Engine
abstract class IAIEngineService {
  /// AI Parking Recommendation
  Future<List<AIRecommendationModel>> getRecommendedParkingSpots({
    required double userLat,
    required double userLng,
    required String destination,
    required DateTime arrivalTime,
  });

  /// Traffic Prediction
  Future<TrafficDataModel> predictTrafficConditions({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
    required DateTime targetTime,
  });

  /// Route Optimization
  Future<Map<String, dynamic>> calculateOptimalRoute({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
    required bool avoidCongestion,
  });

  /// Parking Occupancy Prediction
  Future<double> predictSlotOccupancyRate({
    required String parkingLotId,
    required DateTime targetTime,
  });
}
