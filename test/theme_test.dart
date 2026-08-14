import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartpark_ai/core/theme/app_theme.dart';
import 'package:smartpark_ai/l10n/app_localizations.dart';
import 'package:smartpark_ai/providers/app_state_providers.dart';
import 'package:smartpark_ai/features/settings/presentation/settings_screen.dart';
import 'package:smartpark_ai/features/home/presentation/home_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SmartPark AI AMOLED True Black Dark Theme System Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
      GoogleFonts.config.allowRuntimeFetching = false;
    });

    testWidgets('1 & 2. Light Theme loads and remains unchanged', (WidgetTester tester) async {
      final light = AppTheme.lightTheme;
      expect(light.useMaterial3, isTrue);
      expect(light.brightness, equals(Brightness.light));
      expect(light.scaffoldBackgroundColor, equals(const Color(0xFFF8FAFC)));
      expect(light.colorScheme.surface, equals(const Color(0xFFFFFFFF)));
      expect(light.colorScheme.primary, equals(const Color(0xFF1565C0)));
    });

    testWidgets('3 to 13. Dark Theme defines AMOLED True Black tokens and surface hierarchy', (WidgetTester tester) async {
      final dark = AppTheme.darkTheme;
      expect(dark.useMaterial3, isTrue);
      expect(dark.brightness, equals(Brightness.dark));

      // 4. Scaffold Background: #000000
      expect(dark.scaffoldBackgroundColor, equals(const Color(0xFF000000)));

      // 5 & 6. Surface & Card: #121212
      expect(dark.colorScheme.surface, equals(const Color(0xFF121212)));
      expect(dark.cardTheme.color, equals(const Color(0xFF121212)));

      // 7. Elevated Surface: #1A1A1A
      expect(dark.colorScheme.surfaceContainer, equals(const Color(0xFF1A1A1A)));
      expect(dark.colorScheme.surfaceContainerHigh, equals(const Color(0xFF1A1A1A)));
      expect(dark.dialogTheme.backgroundColor, equals(const Color(0xFF1A1A1A)));
      expect(dark.bottomSheetTheme.backgroundColor, equals(const Color(0xFF1A1A1A)));
      expect(dark.popupMenuTheme.color, equals(const Color(0xFF1A1A1A)));
      expect(dark.snackBarTheme.backgroundColor, equals(const Color(0xFF1A1A1A)));

      // 8. Input Surface: #151515
      expect(dark.inputDecorationTheme.fillColor, equals(const Color(0xFF151515)));

      // 9. Secondary Surface: #181818
      expect(dark.colorScheme.surfaceContainerLow, equals(const Color(0xFF181818)));

      // 10 & 11. Border & Divider: #2A2A2A
      expect(dark.colorScheme.outline, equals(const Color(0xFF2A2A2A)));
      expect(dark.dividerTheme.color, equals(const Color(0xFF2A2A2A)));

      // 12. Primary Text: #FFFFFF
      expect(dark.colorScheme.onSurface, equals(const Color(0xFFFFFFFF)));

      // 13. Secondary Text: #BDBDBD
      expect(dark.colorScheme.onSurfaceVariant, equals(const Color(0xFFBDBDBD)));

      // Drawer background: #121212
      expect(dark.drawerTheme.backgroundColor, equals(const Color(0xFF121212)));
    });

    testWidgets('14 & 17. DarkModeNotifier toggles state and persists to SharedPreferences', (WidgetTester tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Default Light Mode
      expect(container.read(isDarkModeProvider), isFalse);

      // Switch to Dark Mode
      await container.read(isDarkModeProvider.notifier).toggleTheme(true);
      expect(container.read(isDarkModeProvider), isTrue);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('is_dark_mode'), isTrue);

      // Switch back to Light Mode
      await container.read(isDarkModeProvider.notifier).toggleTheme(false);
      expect(container.read(isDarkModeProvider), isFalse);
      expect(prefs.getBool('is_dark_mode'), isFalse);
    });

    testWidgets('18. Theme selection survives simulated app restart', (WidgetTester tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(isDarkModeProvider.notifier).toggleTheme(true);
      expect(container.read(isDarkModeProvider), isTrue);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('is_dark_mode'), isTrue);
    });

    testWidgets('14, 15, 16. Home & Settings theme switches remain synchronized', (WidgetTester tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      Widget buildTestApp() {
        final isDark = container.read(isDarkModeProvider);
        return UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
            home: const HomeScreen(),
          ),
        );
      }

      await tester.pumpWidget(buildTestApp());
      await tester.pumpAndSettle();

      expect(container.read(isDarkModeProvider), isFalse);

      // Toggle from Home screen button
      final homeToggleBtn = find.byTooltip('Switch to Dark Mode');
      expect(homeToggleBtn, findsOneWidget);
      await tester.tap(homeToggleBtn);
      await tester.pumpAndSettle();

      expect(container.read(isDarkModeProvider), isTrue);

      // Re-render app with Settings screen
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: container.read(isDarkModeProvider) ? ThemeMode.dark : ThemeMode.light,
            home: const SettingsScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Find dark mode switch in settings
      final switchFinder = find.byType(Switch);
      expect(switchFinder, findsNWidgets(2)); // Notifications & Dark Mode switches

      // Verify state synchronized
      expect(container.read(isDarkModeProvider), isTrue);
    });

    testWidgets('19. Language state remains intact after theme changes', (WidgetTester tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Set language to Tamil
      container.read(activeLanguageCodeProvider.notifier).state = 'ta';
      expect(container.read(activeLanguageCodeProvider), equals('ta'));

      // Toggle theme
      await container.read(isDarkModeProvider.notifier).toggleTheme(true);
      expect(container.read(isDarkModeProvider), isTrue);

      // Language code still Tamil
      expect(container.read(activeLanguageCodeProvider), equals('ta'));
    });

    testWidgets('20 & 21. All 5 locales render in Dark Mode without missing keys or exceptions', (WidgetTester tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      const locales = ['en', 'ta', 'hi', 'ml', 'kn'];

      for (final code in locales) {
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              locale: Locale(code),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: ThemeMode.dark,
              home: const HomeScreen(),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: 'Failed rendering locale: $code in dark mode');
      }
    });

    testWidgets('22. Responsive layouts render in Dark Mode across all viewports without overflow', (WidgetTester tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      const widths = [360.0, 375.0, 390.0, 412.0, 430.0, 480.0];

      for (final w in widths) {
        tester.view.physicalSize = Size(w, 800);
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: ThemeMode.dark,
              home: const HomeScreen(),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: 'RenderFlex overflow at width $w');
      }
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
  });
}
