import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/user_repository.dart';
import '../repositories/firebase_user_repository.dart';

import '../features/parking/domain/parking_repository.dart';
import '../features/parking/data/firebase_parking_repository.dart';

import '../features/booking/domain/reservation_repository.dart';
import '../features/booking/data/firebase_reservation_repository.dart';

import '../repositories/vehicle_repository.dart';
import '../repositories/firebase_vehicle_repository.dart';

import '../repositories/payment_repository.dart';
import '../repositories/firebase_payment_repository.dart';

import '../repositories/notification_repository.dart';
import '../repositories/firebase_notification_repository.dart';

import '../repositories/digital_twin_repository.dart';
import '../repositories/firebase_digital_twin_repository.dart';

import '../repositories/analytics_repository.dart';
import '../repositories/firebase_analytics_repository.dart';

import '../repositories/sensor_repository.dart';
import '../repositories/firebase_sensor_repository.dart';

/// Central Riverpod Dependency Injection for all Repositories
final userRepositoryProvider = Provider<IUserRepository>((ref) {
  return FirebaseUserRepository();
});

final parkingRepositoryProvider = Provider<IParkingRepository>((ref) {
  return FirebaseParkingRepository();
});

final reservationRepositoryProvider = Provider<IReservationRepository>((ref) {
  return FirebaseReservationRepository();
});

final vehicleRepositoryProvider = Provider<IVehicleRepository>((ref) {
  return FirebaseVehicleRepository();
});

final paymentRepositoryProvider = Provider<IPaymentRepository>((ref) {
  return FirebasePaymentRepository();
});

final notificationRepositoryProvider = Provider<INotificationRepository>((ref) {
  return FirebaseNotificationRepository();
});

final digitalTwinRepositoryProvider = Provider<IDigitalTwinRepository>((ref) {
  return FirebaseDigitalTwinRepository();
});

final analyticsRepositoryProvider = Provider<IAnalyticsRepository>((ref) {
  return FirebaseAnalyticsRepository();
});

final sensorRepositoryProvider = Provider<ISensorRepository>((ref) {
  return FirebaseSensorRepository();
});
