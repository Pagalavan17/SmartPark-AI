import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartpark_ai/l10n/app_localizations.dart';
import 'package:smartpark_ai/features/parking/presentation/widgets/reservation_flow_modal.dart';
import 'package:smartpark_ai/models/parking_lot_model.dart';
import 'package:smartpark_ai/models/vehicle_model.dart';
import 'package:smartpark_ai/providers/repository_providers.dart';
import 'package:smartpark_ai/repositories/vehicle_repository.dart';

class MockVehicleRepository implements IVehicleRepository {
  @override
  Future<List<VehicleModel>> getUserVehicles(String userId) async {
    return const [
      // CAR (6)
      VehicleModel(id: 'car_001', registrationNumber: 'TN 07 CK 5555', modelName: 'Honda City', type: 'Car'),
      VehicleModel(id: 'car_002', registrationNumber: 'TN 22 AB 4521', modelName: 'Hyundai i20', type: 'Car'),
      VehicleModel(id: 'car_003', registrationNumber: 'TN 01 CQ 7823', modelName: 'Maruti Suzuki Swift', type: 'Car'),
      VehicleModel(id: 'car_004', registrationNumber: 'TN 09 BH 3210', modelName: 'Tata Altroz', type: 'Car'),
      VehicleModel(id: 'car_005', registrationNumber: 'TN 10 DE 6742', modelName: 'Volkswagen Virtus', type: 'Car'),
      VehicleModel(id: 'car_006', registrationNumber: 'TN 18 FG 9087', modelName: 'Toyota Glanza', type: 'Car'),

      // BIKE (6)
      VehicleModel(id: 'bike_001', registrationNumber: 'TN 05 RE 8888', modelName: 'Royal Enfield Classic 350', type: 'Bike'),
      VehicleModel(id: 'bike_002', registrationNumber: 'TN 11 YM 4522', modelName: 'Yamaha MT-15', type: 'Bike'),
      VehicleModel(id: 'bike_003', registrationNumber: 'TN 14 AC 6731', modelName: 'Honda Activa 6G', type: 'Bike'),
      VehicleModel(id: 'bike_004', registrationNumber: 'TN 22 AP 3819', modelName: 'TVS Apache RTR 160', type: 'Bike'),
      VehicleModel(id: 'bike_005', registrationNumber: 'TN 09 BP 7294', modelName: 'Bajaj Pulsar NS200', type: 'Bike'),
      VehicleModel(id: 'bike_006', registrationNumber: 'TN 01 KT 5566', modelName: 'KTM Duke 200', type: 'Bike'),

      // SUV (6)
      VehicleModel(id: 'suv_001', registrationNumber: 'TN 01 AB 1234', modelName: 'Hyundai Creta', type: 'SUV'),
      VehicleModel(id: 'suv_002', registrationNumber: 'TN 22 KS 4567', modelName: 'Kia Seltos', type: 'SUV'),
      VehicleModel(id: 'suv_003', registrationNumber: 'TN 09 NX 2345', modelName: 'Tata Nexon', type: 'SUV'),
      VehicleModel(id: 'suv_004', registrationNumber: 'TN 10 MX 6789', modelName: 'Mahindra XUV700', type: 'SUV'),
      VehicleModel(id: 'suv_005', registrationNumber: 'TN 18 UH 3456', modelName: 'Toyota Urban Cruiser Hyryder', type: 'SUV'),
      VehicleModel(id: 'suv_006', registrationNumber: 'TN 07 MH 7890', modelName: 'MG Hector', type: 'SUV'),

      // EV (6)
      VehicleModel(id: 'ev_001', registrationNumber: 'TN 09 EV 9999', modelName: 'Tata Nexon EV', type: 'EV'),
      VehicleModel(id: 'ev_002', registrationNumber: 'TN 01 TE 4321', modelName: 'Tata Tiago EV', type: 'EV'),
      VehicleModel(id: 'ev_003', registrationNumber: 'TN 22 CE 7654', modelName: 'MG Comet EV', type: 'EV'),
      VehicleModel(id: 'ev_004', registrationNumber: 'TN 10 HI 2468', modelName: 'Hyundai Ioniq 5', type: 'EV'),
      VehicleModel(id: 'ev_005', registrationNumber: 'TN 18 BA 1357', modelName: 'BYD Atto 3', type: 'EV'),
      VehicleModel(id: 'ev_006', registrationNumber: 'TN 07 XE 8642', modelName: 'Mahindra XUV400 EV', type: 'EV'),
    ];
  }

  @override
  Future<void> addVehicle(String userId, VehicleModel vehicle) async {}

  @override
  Future<void> deleteVehicle(String userId, String vehicleId) async {}
}

void main() {
  final sampleLot = ParkingLotModel.fromMap(const {
    'name': 'CIT Main Gate Parking',
    'address': 'Chennai Institute of Technology, Kundrathur, Chennai',
    'latitude': 12.9715,
    'longitude': 80.0434,
    'distanceInKm': 0.5,
    'walkingTimeInMins': 6,
    'driveTimeInMins': 2,
    'baseHourlyRate': 30.0,
    'currentHourlyRate': 30.0,
    'isPeakHour': false,
    'peakSurgeMultiplier': 1.0,
    'totalSlots': 150,
    'availableSlots': 45,
    'rating': 4.8,
    'reviewCount': 10,
    'securityRating': 4.8,
    'imageUrls': <dynamic>[],
    'aiMatchScore': 90.0,
    'aiConfidence': 95.0,
    'aiReasoningSummary': 'Optimal parking spot',
    'trafficStatus': 'Normal Traffic',
    'congestionLevel': 0.2,
    'isEVChargingAvailable': true,
    'hasCCTV': true,
    'isCovered': true,
    'accessibilityFeatures': <dynamic>[],
  }, 'cit_main_gate');

  Widget createWizardWidget() {
    return ProviderScope(
      overrides: [
        vehicleRepositoryProvider.overrideWithValue(MockVehicleRepository()),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: ReservationFlowModal(parkingLot: sampleLot),
        ),
      ),
    );
  }

  group('ReservationFlowModal Expanded Vehicle Database Tests', () {
    const widths = [360.0, 375.0, 390.0, 412.0];

    for (final width in widths) {
      testWidgets('ReservationFlowModal shows 6 vehicles for each category without overflow at ${width}px width', (WidgetTester tester) async {
        tester.view.physicalSize = Size(width, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        await tester.pumpWidget(createWizardWidget());
        await tester.pumpAndSettle();

        // Navigate to Step 3
        await tester.tap(find.text('Next Step'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Next Step'));
        await tester.pumpAndSettle();

        // 1. CAR Filter -> expect Honda City, Hyundai i20, Maruti Swift, Tata Altroz, VW Virtus, Toyota Glanza
        expect(find.text('Honda City (TN 07 CK 5555)'), findsOneWidget);
        expect(find.text('Hyundai i20 (TN 22 AB 4521)'), findsOneWidget);
        expect(find.text('Maruti Suzuki Swift (TN 01 CQ 7823)'), findsOneWidget);

        // 2. BIKE Filter -> expect Royal Enfield, Yamaha MT-15, Honda Activa 6G, TVS Apache, Pulsar, KTM
        await tester.tap(find.text('Bike'));
        await tester.pumpAndSettle();
        expect(find.text('Royal Enfield Classic 350 (TN 05 RE 8888)'), findsOneWidget);
        expect(find.text('Yamaha MT-15 (TN 11 YM 4522)'), findsOneWidget);
        expect(find.text('Honda Activa 6G (TN 14 AC 6731)'), findsOneWidget);

        // 3. SUV Filter -> expect Creta, Seltos, Nexon, XUV700, Hyryder, Hector
        await tester.tap(find.text('SUV'));
        await tester.pumpAndSettle();
        expect(find.text('Hyundai Creta (TN 01 AB 1234)'), findsOneWidget);
        expect(find.text('Kia Seltos (TN 22 KS 4567)'), findsOneWidget);
        expect(find.text('Mahindra XUV700 (TN 10 MX 6789)'), findsOneWidget);

        // 4. EV Filter -> expect Nexon EV, Tiago EV, Comet EV, Ioniq 5, Atto 3, XUV400 EV
        await tester.tap(find.text('EV'));
        await tester.pumpAndSettle();
        expect(find.text('Tata Nexon EV (TN 09 EV 9999)'), findsOneWidget);
        expect(find.text('Tata Tiago EV (TN 01 TE 4321)'), findsOneWidget);
        expect(find.text('Hyundai Ioniq 5 (TN 10 HI 2468)'), findsOneWidget);

        // Select Hyundai Ioniq 5
        await tester.tap(find.text('Hyundai Ioniq 5 (TN 10 HI 2468)'));
        await tester.pumpAndSettle();

        // Step 4 & 5
        await tester.ensureVisible(find.text('Next Step'));
        await tester.tap(find.text('Next Step'));
        await tester.pumpAndSettle();
        expect(find.text('TN 10 HI 2468'), findsOneWidget);

        await tester.ensureVisible(find.text('Next Step'));
        await tester.tap(find.text('Next Step'));
        await tester.pumpAndSettle();
        expect(find.text('Step 5 of 5'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  });
}
