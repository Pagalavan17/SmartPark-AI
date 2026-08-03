import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_park_ai/app.dart';

void main() {
  testWidgets('SmartPark AI smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: SmartParkApp(),
      ),
    );
    expect(find.byType(SmartParkApp), findsOneWidget);
  });
}
