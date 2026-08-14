import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartpark_ai/l10n/app_localizations.dart';
import 'package:smartpark_ai/features/parking/presentation/widgets/qr_pass_dialog.dart';
import 'package:smartpark_ai/features/qr_pass/presentation/qr_pass_screen.dart';
import 'package:smartpark_ai/models/reservation_model.dart';

void main() {
  final sampleReservation = ReservationModel(
    reservationId: 'SP-982341',
    parkingId: 'cit_main_gate',
    parkingName: 'CIT Main Gate Parking',
    parkingAddress: 'Chennai Institute of Technology, Kundrathur, Chennai',
    allocatedSlot: 'Slot A-14',
    arrivalTime: DateTime.now(),
    durationInHours: 2,
    vehicleType: 'Car',
    vehicleNumber: 'TN 07 CK 5555',
    baseRatePerHour: 30.0,
    surgeFee: 0.0,
    serviceFee: 15.0,
    totalAmount: 75.0,
    qrCodeToken: 'SMARTPARK_PASS_SP-982341_SLOT_A14',
    status: 'Active',
    createdAt: DateTime.now(),
  );

  group('QR Pass Responsive Tests', () {
    const widths = [360.0, 375.0, 390.0, 412.0];

    for (final width in widths) {
      testWidgets('QrPassDialog renders without overflow at ${width}px width', (WidgetTester tester) async {
        tester.view.physicalSize = Size(width, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: QrPassDialog(reservation: sampleReservation),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Digital QR Pass'), findsOneWidget);
        expect(find.text('View Full Pass'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('QrPassScreen renders Metro Cyber Park ACTIVE header without overflow at ${width}px width', (WidgetTester tester) async {
        tester.view.physicalSize = Size(width, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.pumpWidget(
          const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: QrPassScreen(),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Metro Cyber Park'), findsOneWidget);
        expect(find.byIcon(Icons.local_parking), findsOneWidget);
        expect(find.text('Download'), findsOneWidget);
        expect(find.text('Share'), findsOneWidget);
        expect(find.text('Navigate'), findsOneWidget);

        expect(tester.takeException(), isNull);
      });
    }
  });
}
