import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/booking_model.dart';

final bookingHistoryProvider = FutureProvider<List<BookingModel>>((ref) async {
  return [];
});
