import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/analytics_report_model.dart';
import '../../../providers/repository_providers.dart';

final adminAnalyticsProvider = FutureProvider.family<AnalyticsReportModel, String>((ref, timeFrame) {
  final repo = ref.watch(analyticsRepositoryProvider);
  return repo.getAnalyticsReport(timeFrame);
});

final systemHealthStatusProvider = Provider<Map<String, bool>>((ref) {
  return const {
    'Firestore Database': true,
    'AI Decision Engine': true,
    'Digital Twin Gateway': true,
    'FCM Notification Engine': true,
    'Razorpay Payment Gateway': true,
    'Google Maps Location API': true,
    'IoT Sensor Gateway': true,
  };
});
