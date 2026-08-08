import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/parking_lot_model.dart';
import '../../../models/prediction_model.dart';
import '../../../models/digital_twin_model.dart';
import '../../../models/parking_review_model.dart';
import '../../../models/reservation_model.dart';

import '../../../providers/repository_providers.dart';
import '../../../services/ai/ai_providers.dart';

export '../../../providers/repository_providers.dart';
export '../../../services/ai/ai_providers.dart';

/// Family Providers utilizing master AIDecisionEngine and Central Repositories
final parkingDetailsProvider = FutureProvider.family<ParkingLotModel?, String>((ref, id) async {
  final repo = ref.watch(parkingRepositoryProvider);
  return repo.getParkingLotById(id);
});

final predictionProvider = FutureProvider.family<PredictionModel?, String>((ref, id) async {
  final engine = ref.watch(aiDecisionEngineProvider);
  final lot = await ref.watch(parkingDetailsProvider(id).future);
  if (lot != null) {
    return engine.getOccupancyPrediction(lot);
  }
  return null;
});

final digitalTwinProvider = FutureProvider.family<DigitalTwinModel?, String>((ref, id) async {
  final engine = ref.watch(aiDecisionEngineProvider);
  final lot = await ref.watch(parkingDetailsProvider(id).future);
  if (lot != null) {
    return engine.getDigitalTwin(lot);
  }
  return null;
});

final parkingReviewsProvider = FutureProvider.family<List<ParkingReviewModel>, String>((ref, id) async {
  final repo = ref.watch(parkingRepositoryProvider);
  return repo.getReviewsForLot(id);
});

final activeReservationProvider = StateProvider<ReservationModel?>((ref) => null);
