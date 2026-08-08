import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/analytics_report_model.dart';
import 'analytics_repository.dart';

class FirebaseAnalyticsRepository implements IAnalyticsRepository {
  final FirebaseFirestore? _firestore;

  FirebaseAnalyticsRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<AnalyticsReportModel> getAnalyticsReport(String timeFrame) async {
    try {
      if (_firestore != null) {
        final doc = await _firestore.collection('analytics').doc(timeFrame.toLowerCase()).get();
        if (doc.exists && doc.data() != null) {
          return AnalyticsReportModel.fromMap(doc.data()!, doc.id);
        }
      }
    } catch (_) {}
    return AnalyticsReportModel(
      reportId: timeFrame.toLowerCase(),
      timeFrame: timeFrame,
      totalRevenue: 48500.0,
      globalOccupancyRate: 78.5,
      totalReservations: 342,
      evChargingEnergyKWh: 1280.0,
      co2SavingsKg: 380.0,
      aiPredictionAccuracy: 96.8,
      generatedAt: DateTime.now(),
    );
  }

  @override
  Future<void> saveAnalyticsReport(AnalyticsReportModel report) async {
    try {
      if (_firestore != null) {
        await _firestore.collection('analytics').doc(report.reportId).set(report.toMap());
      }
    } catch (_) {}
  }
}
