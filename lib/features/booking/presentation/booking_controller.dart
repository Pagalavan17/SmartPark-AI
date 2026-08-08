import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/booking_model.dart';

final activeBookingProvider = StateProvider<BookingModel?>((ref) => null);
