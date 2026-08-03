import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/parking_spot_model.dart';

final searchResultsProvider = StateProvider<List<ParkingSpotModel>>((ref) => []);
