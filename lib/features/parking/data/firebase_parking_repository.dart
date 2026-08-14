import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '../../../core/errors/exceptions.dart';
import '../../../models/parking_lot_model.dart';
import '../../../models/prediction_model.dart';
import '../../../models/parking_review_model.dart';
import '../domain/parking_repository.dart';
import 'parking_dummy_data.dart';

/// Production implementation of IParkingRepository.
///
/// PRIMARY SOURCE: Firestore `parking_lots` collection.
/// - watchAllParkingLots() / getAllParkingLots() → NO dummy fallback.
///   Returns empty list when empty; propagates errors when Firestore fails.
/// - Predictions and reviews retain dummy fallback because they are
///   AI-generated and do not represent live availability.
///
/// NOTE: No server-side .orderBy() is used to avoid requiring a Firestore
/// composite index on a freshly created collection. Sorting is client-side.
class FirebaseParkingRepository implements IParkingRepository {
  final FirebaseFirestore _firestore;

  FirebaseParkingRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // ─────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────

  /// Safely parses a Firestore document into ParkingLotModel, logging raw
  /// and parsed values so any field-mapping issue is immediately visible.
  ParkingLotModel _parseDoc(String id, Map<String, dynamic> data) {
    return ParkingLotModel.fromMap(data, id);
  }

  List<ParkingLotModel> _sortByName(List<ParkingLotModel> lots) {
    final sorted = [...lots];
    sorted.sort((a, b) => a.name.compareTo(b.name));
    return sorted;
  }

  // ─────────────────────────────────────────
  // FUTURE-BASED (backward compatible)
  // ─────────────────────────────────────────

  @override
  Future<List<ParkingLotModel>> getAllParkingLots() async {
    try {
      // No orderBy — avoids Firestore index requirement; sort client-side.
      final snapshot =
          await _firestore.collection('parking_lots').get();
      debugPrint(
          'FIRESTORE getAllParkingLots: ${snapshot.docs.length} documents');
      if (snapshot.docs.isEmpty) return [];
      return _sortByName(
        snapshot.docs
            .map((doc) => _parseDoc(doc.id, doc.data()))
            .toList(),
      );
    } on FirebaseException catch (e) {
      throw FirestoreException(
        'Failed to load parking lots: ${e.message}',
        code: e.code,
      );
    } catch (e) {
      throw FirestoreException('Unexpected error loading parking lots: $e');
    }
  }

  @override
  Future<ParkingLotModel?> getParkingLotById(String id) async {
    try {
      final doc =
          await _firestore.collection('parking_lots').doc(id).get();
      if (doc.exists && doc.data() != null) {
        return _parseDoc(doc.id, doc.data()!);
      }
      return null;
    } on FirebaseException catch (e) {
      throw FirestoreException(
        'Failed to load parking lot $id: ${e.message}',
        code: e.code,
      );
    } catch (e) {
      throw FirestoreException('Unexpected error loading parking lot $id: $e');
    }
  }

  // ─────────────────────────────────────────
  // REAL-TIME STREAMS
  // ─────────────────────────────────────────

  @override
  Stream<List<ParkingLotModel>> watchAllParkingLots() {
    debugPrint('=== PARKING LOT STREAM START ===');
    try {
      debugPrint('Firestore project: ${Firebase.app().options.projectId}');
    } catch (e) {
      debugPrint('Firebase.app() options check error: $e');
    }
    debugPrint('Reading collection: parking_lots');

    return _firestore
        .collection('parking_lots')
        .snapshots()
        .map((snapshot) {
      debugPrint('Firestore documents: ${snapshot.docs.length}');
      for (final doc in snapshot.docs) {
        debugPrint('DOC ID: ${doc.id}');
        debugPrint('DOC DATA: ${doc.data()}');
      }
      final lots = snapshot.docs
          .map((doc) => _parseDoc(doc.id, doc.data()))
          .toList();
      return _sortByName(lots);
    }).handleError((error, stackTrace) {
      debugPrint('=== FIRESTORE ERROR ===');
      debugPrint('$error');
      debugPrintStack(stackTrace: stackTrace);
      throw error;
    });
  }

  @override
  Stream<ParkingLotModel?> watchParkingLotById(String id) {
    return _firestore
        .collection('parking_lots')
        .doc(id)
        .snapshots()
        .map((doc) {
      if (doc.exists && doc.data() != null) {
        return _parseDoc(doc.id, doc.data()!);
      }
      return null;
    });
  }

  // ─────────────────────────────────────────
  // PREDICTIONS — dummy fallback is acceptable
  // ─────────────────────────────────────────

  @override
  Future<PredictionModel?> getPredictionForLot(String id) async {
    try {
      final doc =
          await _firestore.collection('parking_predictions').doc(id).get();
      if (doc.exists && doc.data() != null) {
        return PredictionModel.fromMap(doc.data()!, doc.id);
      }
      return ParkingDummyData.samplePrediction(id);
    } catch (_) {
      return ParkingDummyData.samplePrediction(id);
    }
  }

  // ─────────────────────────────────────────
  // REVIEWS — dummy fallback is acceptable
  // ─────────────────────────────────────────

  @override
  Future<List<ParkingReviewModel>> getReviewsForLot(String id) async {
    try {
      final snapshot = await _firestore
          .collection('parking_reviews')
          .where('parkingId', isEqualTo: id)
          .get();
      if (snapshot.docs.isEmpty) {
        return ParkingDummyData.sampleReviews(id);
      }
      return snapshot.docs
          .map((doc) => ParkingReviewModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (_) {
      return ParkingDummyData.sampleReviews(id);
    }
  }
}
