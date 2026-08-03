import '../../../models/parking_spot_model.dart';

abstract class IParkingRepository {
  Future<ParkingSpotModel?> getParkingSpotDetails(String id);
  Future<List<String>> getAvailableSlots(String spotId);
}
