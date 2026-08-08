import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/parking_lot_model.dart';
import '../../../models/prediction_model.dart';
import '../../../models/parking_review_model.dart';
import '../domain/parking_repository.dart';
import 'parking_dummy_data.dart';

/// Clean Architecture Implementation of IParkingRepository using Firestore with Dummy Fallback
class FirebaseParkingRepository implements IParkingRepository {
  final FirebaseFirestore? _firestore;

  FirebaseParkingRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? (FirebaseFirestore.instance);

  @override
  Future<List<ParkingLotModel>> getAllParkingLots() async {
    try {
      if (_firestore == null) return ParkingDummyData.sampleLots;
      final snapshot = await _firestore.collection('parking_lots').get();
      if (snapshot.docs.isEmpty) {
        return ParkingDummyData.sampleLots;
      }
      return snapshot.docs.map((doc) => ParkingLotModel.fromMap(doc.data(), doc.id)).toList();
    } catch (_) {
      // Fallback to dummy sample data on error/offline
      return ParkingDummyData.sampleLots;
    }
  }

  @override
  Future<ParkingLotModel?> getParkingLotById(String id) async {
    try {
      if (_firestore == null) {
        return ParkingDummyData.sampleLots.firstWhere(
          (lot) => lot.id == id,
          orElse: () => ParkingDummyData.sampleLots.first,
        );
      }
      final doc = await _firestore.collection('parking_lots').doc(id).get();
      if (doc.exists && doc.data() != null) {
        return ParkingLotModel.fromMap(doc.data()!, doc.id);
      }
      return ParkingDummyData.sampleLots.firstWhere(
        (lot) => lot.id == id,
        orElse: () => ParkingDummyData.sampleLots.first,
      );
    } catch (_) {
      return ParkingDummyData.sampleLots.firstWhere(
        (lot) => lot.id == id,
        orElse: () => ParkingDummyData.sampleLots.first,
      );
    }
  }

  @override
  Future<PredictionModel?> getPredictionForLot(String id) async {
    try {
      if (_firestore == null) return ParkingDummyData.samplePrediction(id);
      final doc = await _firestore.collection('parking_predictions').doc(id).get();
      if (doc.exists && doc.data() != null) {
        return PredictionModel.fromMap(doc.data()!, doc.id);
      }
      return ParkingDummyData.samplePrediction(id);
    } catch (_) {
      return ParkingDummyData.samplePrediction(id);
    }
  }

  @override
  Future<List<ParkingReviewModel>> getReviewsForLot(String id) async {
    try {
      if (_firestore == null) return ParkingDummyData.sampleReviews(id);
      final snapshot = await _firestore
          .collection('parking_reviews')
          .where('parkingId', isEqualTo: id)
          .get();
      if (snapshot.docs.isEmpty) {
        return ParkingDummyData.sampleReviews(id);
      }
      return snapshot.docs.map((doc) => ParkingReviewModel.fromMap(doc.data(), doc.id)).toList();
    } catch (_) {
      return ParkingDummyData.sampleReviews(id);
    }
  }
}
