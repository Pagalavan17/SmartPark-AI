import '../../../models/parking_lot_model.dart';
import '../../../models/prediction_model.dart';
import '../../../models/parking_review_model.dart';

/// Clean Architecture Repository Interface for Parking Data
abstract class IParkingRepository {
  // ── Future-based (kept for backward compatibility) ──
  Future<List<ParkingLotModel>> getAllParkingLots();
  Future<ParkingLotModel?> getParkingLotById(String id);
  Future<PredictionModel?> getPredictionForLot(String id);
  Future<List<ParkingReviewModel>> getReviewsForLot(String id);

  // ── Real-time streams ──

  /// Live stream of all parking lots ordered by name.
  /// Emits an empty list when the collection is empty.
  /// Propagates Firestore errors to the caller — no dummy fallback.
  Stream<List<ParkingLotModel>> watchAllParkingLots();

  /// Live stream of a single parking lot.
  /// Emits null when the document does not exist.
  Stream<ParkingLotModel?> watchParkingLotById(String id);
}
