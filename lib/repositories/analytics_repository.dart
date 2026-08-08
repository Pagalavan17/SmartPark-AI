import '../models/analytics_report_model.dart';

abstract class IAnalyticsRepository {
  Future<AnalyticsReportModel> getAnalyticsReport(String timeFrame);
  Future<void> saveAnalyticsReport(AnalyticsReportModel report);
}
