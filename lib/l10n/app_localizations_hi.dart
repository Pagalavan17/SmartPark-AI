// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appName => 'स्मार्टपार्र्क AI';

  @override
  String get welcomeTitle => 'AI के साथ आसानी से पार्किंग खोजें';

  @override
  String get welcomeSubtitle =>
      'रियल-टाइम पार्किंग, स्मार्ट रूट और त्वरित बुकिंग।';

  @override
  String get searchPlaceholder => 'स्थान या स्थल द्वारा पार्किंग खोजें...';

  @override
  String get aiRecommendation => 'AI पार्किंग सिफारिश';

  @override
  String get trafficPrediction => 'ट्रैफिक पूर्वानुमान';

  @override
  String get reserveSpot => 'पार्किंग स्लॉट बुक करें';

  @override
  String get payNow => 'Razorpay से भुगतान करें';

  @override
  String get activeBooking => 'सक्रिय पार्किंग बुकिंग';

  @override
  String get qrPassTitle => 'प्रवेश / निकास QR पास';

  @override
  String get notificationsTitle => 'स्मार्ट सूचनाएं';

  @override
  String get profileTitle => 'उपयोगकर्ता प्रोफ़ाइल';

  @override
  String get settingsTitle => 'ऐप सेटिंग्स';

  @override
  String get selectLanguage => 'भाषा चुनें';
}
