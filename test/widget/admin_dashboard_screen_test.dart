import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartpark_ai/l10n/app_localizations.dart';
import 'package:smartpark_ai/features/admin/presentation/admin_dashboard_screen.dart';
import 'package:smartpark_ai/models/analytics_report_model.dart';
import 'package:smartpark_ai/models/digital_twin_model.dart';
import 'package:smartpark_ai/providers/repository_providers.dart';
import 'package:smartpark_ai/repositories/analytics_repository.dart';
import 'package:smartpark_ai/services/sensor/sensor_providers.dart';

class MockAnalyticsRepository implements IAnalyticsRepository {
  @override
  Future<AnalyticsReportModel> getAnalyticsReport(String timeFrame) async {
    return AnalyticsReportModel(
      reportId: 'rep_1',
      timeFrame: timeFrame,
      totalRevenue: 125000.0,
      globalOccupancyRate: 84.5,
      totalReservations: 342,
      evChargingEnergyKWh: 12000.0,
      co2SavingsKg: 2400.0,
      aiPredictionAccuracy: 97.2,
      generatedAt: DateTime.now(),
    );
  }

  @override
  Future<void> saveAnalyticsReport(AnalyticsReportModel report) async {}
}

void main() {
  final mockTwin = DigitalTwinModel(
    parkingId: 'spot_metro',
    liveTotalSlots: 100,
    liveOccupiedSlots: 76,
    vehicleInflowRatePerHour: 42,
    vehicleOutflowRatePerHour: 28,
    currentSurgeMultiplier: 1.2,
    liveTrafficCongestion: 'Clear Flow (15%)',
    lastTelemetryUpdate: DateTime.now(),
  );

  Widget createAdminWidget() {
    return ProviderScope(
      overrides: [
        analyticsRepositoryProvider.overrideWithValue(MockAnalyticsRepository()),
        digitalTwinStreamProvider('spot_metro').overrideWith((ref) => Stream.value(mockTwin)),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: AdminDashboardScreen(),
      ),
    );
  }

  testWidgets('AdminDashboardScreen renders without RenderFlex overflow at 360px width', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(createAdminWidget());
    await tester.pumpAndSettle();

    expect(find.text('Enterprise AI Admin Dashboard'), findsOneWidget);
    expect(find.text('Platform Executive Summary'), findsOneWidget);
    expect(find.text('System Health'), findsOneWidget);
    expect(find.text('Digital Twin & Hardware Telemetry'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('AdminDashboardScreen renders without RenderFlex overflow at 390px width', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(createAdminWidget());
    await tester.pumpAndSettle();

    expect(find.text('Enterprise AI Admin Dashboard'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('AdminDashboardScreen renders without RenderFlex overflow at 412px width', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(412, 915);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(createAdminWidget());
    await tester.pumpAndSettle();

    expect(find.text('Enterprise AI Admin Dashboard'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
