import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:smartpark_ai/l10n/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_router.dart';
import 'providers/app_state_providers.dart';

/// Root Application Widget for SmartPark AI
class SmartParkApp extends ConsumerWidget {
  const SmartParkApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final languageCode = ref.watch(activeLanguageCodeProvider);
    final isDarkMode = ref.watch(isDarkModeProvider);

    return MaterialApp.router(
      title: 'SmartPark AI',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      locale: Locale(languageCode),
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('ta', ''), // Tamil
        Locale('hi', ''), // Hindi
        Locale('ml', ''), // Malayalam
        Locale('kn', ''), // Kannada
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
