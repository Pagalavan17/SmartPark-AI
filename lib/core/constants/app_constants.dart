class AppConstants {
  AppConstants._();

  static const String appName = 'SmartPark AI';
  static const String appVersion = '1.0.0';

  // Design Constants
  static const double cardBorderRadius = 20.0;
  static const double buttonBorderRadius = 14.0;
  static const double defaultPadding = 16.0;
  static const double largePadding = 24.0;

  // Supported Locales
  static const List<String> supportedLanguages = [
    'en', // English
    'ta', // Tamil
    'hi', // Hindi
    'ml', // Malayalam
    'kn', // Kannada
  ];

  // Hive Box Names
  static const String profileBox = 'user_profile_box';
  static const String settingsBox = 'app_settings_box';
  static const String bookingsBox = 'recent_bookings_box';
  static const String favoritesBox = 'favorite_parking_box';

  // Animation Durations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration pageTransitionDuration = Duration(milliseconds: 250);
}
