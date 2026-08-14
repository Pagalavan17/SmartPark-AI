import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/parking_lot_model.dart';
import '../../../models/prediction_model.dart';
import '../../../models/digital_twin_model.dart';
import '../../../models/parking_review_model.dart';
import '../../../models/reservation_model.dart';

import '../../../providers/repository_providers.dart';
import '../../../services/ai/ai_providers.dart';
import 'package:flutter/foundation.dart';

export '../../../providers/repository_providers.dart';
export '../../../services/ai/ai_providers.dart';

// ─────────────────────────────────────────────────────────────────────────────
// REAL-TIME PARKING STREAM PROVIDER
// Primary data source for all screens that display parking lots.
// Automatically receives live Firestore updates — no manual refresh needed.
// Emits:
//   AsyncData([]) when collection is empty
//   AsyncError when Firestore is unavailable
//   AsyncData(lots) when data is present
// ─────────────────────────────────────────────────────────────────────────────

final parkingLotsProvider =
    StreamProvider<List<ParkingLotModel>>((ref) {
  final repo = ref.watch(parkingRepositoryProvider);
  try {
    return repo.watchAllParkingLots();
  } catch (e, st) {
    debugPrint('PARKING LOT PROVIDER ERROR: $e');
    debugPrintStack(stackTrace: st);
    rethrow;
  }
});

// ─────────────────────────────────────────────────────────────────────────────
// SINGLE LOT REAL-TIME STREAM PROVIDER (family)
// Used by ParkingDetailsScreen and any screen needing live updates for one lot.
// ─────────────────────────────────────────────────────────────────────────────

final parkingLotStreamProvider =
    StreamProvider.family<ParkingLotModel?, String>((ref, id) {
  final repo = ref.watch(parkingRepositoryProvider);
  return repo.watchParkingLotById(id);
});

// ─────────────────────────────────────────────────────────────────────────────
// EXISTING FAMILY PROVIDERS — kept for backward compatibility
// These use the Future-based methods and are still used by ParkingDetailsScreen,
// AI prediction, digital twin, and reviews.
// ─────────────────────────────────────────────────────────────────────────────

final parkingDetailsProvider =
    FutureProvider.family<ParkingLotModel?, String>((ref, id) async {
  final repo = ref.watch(parkingRepositoryProvider);
  return repo.getParkingLotById(id);
});

final predictionProvider =
    FutureProvider.family<PredictionModel?, String>((ref, id) async {
  final engine = ref.watch(aiDecisionEngineProvider);
  final lot = await ref.watch(parkingDetailsProvider(id).future);
  if (lot != null) {
    return engine.getOccupancyPrediction(lot);
  }
  return null;
});

final digitalTwinProvider =
    FutureProvider.family<DigitalTwinModel?, String>((ref, id) async {
  final engine = ref.watch(aiDecisionEngineProvider);
  final lot = await ref.watch(parkingDetailsProvider(id).future);
  if (lot != null) {
    return engine.getDigitalTwin(lot);
  }
  return null;
});

final parkingReviewsProvider =
    FutureProvider.family<List<ParkingReviewModel>, String>((ref, id) async {
  final repo = ref.watch(parkingRepositoryProvider);
  return repo.getReviewsForLot(id);
});

final activeReservationProvider = StateProvider<ReservationModel?>((ref) => null);
