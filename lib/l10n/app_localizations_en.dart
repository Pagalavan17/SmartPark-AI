// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'SmartPark AI';

  @override
  String get welcomeTitle => 'Find Parking Effortlessly with AI';

  @override
  String get welcomeSubtitle =>
      'Real-time parking, smart routes, and instant booking at your fingertips.';

  @override
  String get searchPlaceholder => 'Search parking by location or venue...';

  @override
  String get aiRecommendation => 'AI Parking Recommendation';

  @override
  String get trafficPrediction => 'Traffic & Congestion Alert';

  @override
  String get reserveSpot => 'Reserve Parking Slot';

  @override
  String get payNow => 'Pay with Razorpay';

  @override
  String get activeBooking => 'Active Parking Reservation';

  @override
  String get qrPassTitle => 'Entry / Exit QR Pass';

  @override
  String get notificationsTitle => 'Smart Notifications';

  @override
  String get profileTitle => 'User Profile';

  @override
  String get settingsTitle => 'App Settings';

  @override
  String get selectLanguage => 'Select Language';
}
