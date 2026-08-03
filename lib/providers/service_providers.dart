import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/services/firebase_service_interface.dart';
import '../core/services/maps_service_interface.dart';
import '../core/services/payment_service_interface.dart';
import '../core/services/ai_engine_service_interface.dart';
import '../core/services/hive_storage_service_interface.dart';
import '../core/services/notification_service_interface.dart';

/// Global Dependency Injection Service Providers using Riverpod
final firebaseServiceProvider = Provider<IFirebaseService?>((ref) => null);
final mapsServiceProvider = Provider<IMapsService?>((ref) => null);
final paymentServiceProvider = Provider<IPaymentService?>((ref) => null);
final aiEngineServiceProvider = Provider<IAIEngineService?>((ref) => null);
final storageServiceProvider = Provider<IHiveStorageService?>((ref) => null);
final notificationServiceProvider = Provider<INotificationService?>((ref) => null);
