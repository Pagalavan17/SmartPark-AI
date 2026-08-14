import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartpark_ai/l10n/app_localizations.dart';
import 'package:smartpark_ai/core/widgets/primary_button.dart';
import 'package:smartpark_ai/core/widgets/secondary_button.dart';
import 'package:smartpark_ai/features/search/presentation/live_parking_map_screen.dart';
import 'package:smartpark_ai/models/parking_lot_model.dart';

void main() {
  const sampleLot = ParkingLotModel(
    id: 'spot_cit',
    name: 'CIT Main Gate Parking',
    address: 'Chennai Institute of Technology, Kundrathur',
    latitude: 12.9716,
    longitude: 80.0443,
    distanceInKm: 0.5,
    walkingTimeInMins: 6,
    driveTimeInMins: 3,
    baseHourlyRate: 40.0,
    currentHourlyRate: 40.0,
    isPeakHour: false,
    peakSurgeMultiplier: 1.0,
    totalSlots: 100,
    availableSlots: 24,
    rating: 4.8,
    reviewCount: 124,
    securityRating: 4.9,
    imageUrls: [],
    aiMatchScore: 90.0,
    aiConfidence: 95.0,
    aiReasoningSummary: 'Nearest available spot',
    trafficStatus: 'Low Traffic Flow',
    congestionLevel: 0.2,
    isEVChargingAvailable: true,
    hasCCTV: true,
    isCovered: true,
    accessibilityFeatures: ['Wheelchair Ramp'],
    operatingHours: '24/7 Open',
    amenities: ['Covered', 'EV Fast Charging'],
    availableVehicleTypes: ['Car', 'Bike', 'EV'],
  );

  Widget createCardTestWidget() {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SelectedParkingCard(
              parkingLot: sampleLot,
              freeSlots: 24,
              onDetails: () {},
              onReserve: () {},
            ),
          ),
        ),
      ),
    );
  }

  group('Parking Result Card Responsive Overflow Tests', () {
    const testWidths = [360.0, 375.0, 390.0, 412.0, 430.0, 480.0];

    for (final width in testWidths) {
      testWidgets('SelectedParkingCard renders cleanly without overflow at ${width}px width', (WidgetTester tester) async {
        tester.view.physicalSize = Size(width, 850);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.pumpWidget(createCardTestWidget());
        await tester.pumpAndSettle();

        // Verify key text elements on the card are present
        expect(find.text('CIT Main Gate Parking'), findsOneWidget);
        expect(find.text('₹40/hr'), findsOneWidget);
        expect(find.text('0.5 km'), findsOneWidget);
        expect(find.text('6 mins walk'), findsOneWidget);
        expect(find.text('24 slots free'), findsOneWidget);
        expect(find.text('90% AI Score'), findsOneWidget);

        // Verify buttons
        final detailsBtn = find.text('Parking Details');
        final reserveBtn = find.text('Reserve Now');
        expect(detailsBtn, findsOneWidget);
        expect(reserveBtn, findsOneWidget);

        // Verify no exception / zero RenderFlex overflow
        expect(tester.takeException(), isNull);

        // Bounds check: Card must fit within screen bounds
        final cardBox = tester.renderObject(find.byType(Card)) as RenderBox;
        final cardSize = cardBox.size;
        final cardOffset = cardBox.localToGlobal(Offset.zero);

        expect(cardOffset.dx >= 0, isTrue);
        expect(cardOffset.dx + cardSize.width <= width + 0.1, isTrue);
        expect(cardOffset.dy + cardSize.height <= 850 + 0.1, isTrue);

        // Verify button render boxes are within card bounds
        final detailsBox = tester.renderObject(find.widgetWithText(SecondaryButton, 'Parking Details')) as RenderBox;
        final detailsPos = detailsBox.localToGlobal(Offset.zero);
        expect(detailsPos.dx >= cardOffset.dx, isTrue);
        expect(detailsPos.dx + detailsBox.size.width <= cardOffset.dx + cardSize.width + 0.1, isTrue);

        final reserveBox = tester.renderObject(find.widgetWithText(PrimaryButton, 'Reserve Now')) as RenderBox;
        final reservePos = reserveBox.localToGlobal(Offset.zero);
        expect(reservePos.dx >= cardOffset.dx, isTrue);
        expect(reservePos.dx + reserveBox.size.width <= cardOffset.dx + cardSize.width + 0.1, isTrue);
      });
    }
  });
}
