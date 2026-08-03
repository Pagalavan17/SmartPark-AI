import '../../../models/parking_spot_model.dart';
import '../../../models/ai_recommendation_model.dart';

abstract class IHomeRepository {
  Future<List<ParkingSpotModel>> getNearbyParkingSpots(double lat, double lng);
  Future<AIRecommendationModel?> getTopAiRecommendation(double lat, double lng);
}
