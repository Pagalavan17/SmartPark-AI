import '../../../models/parking_spot_model.dart';

abstract class ISearchRepository {
  Future<List<ParkingSpotModel>> searchParking(String query, {double? lat, double? lng});
}
