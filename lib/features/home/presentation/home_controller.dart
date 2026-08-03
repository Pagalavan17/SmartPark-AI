import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/parking_spot_model.dart';

final homeNearbySpotsProvider = FutureProvider<List<ParkingSpotModel>>((ref) async {
  return [];
});
