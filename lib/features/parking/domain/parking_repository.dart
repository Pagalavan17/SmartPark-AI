import '../../../models/parking_lot_model.dart';
import '../../../models/prediction_model.dart';
import '../../../models/parking_review_model.dart';

/// Clean Architecture Repository Interface for Parking Data
abstract class IParkingRepository {
  Future<List<ParkingLotModel>> getAllParkingLots();
  Future<ParkingLotModel?> getParkingLotById(String id);
  Future<PredictionModel?> getPredictionForLot(String id);
  Future<List<ParkingReviewModel>> getReviewsForLot(String id);
}
