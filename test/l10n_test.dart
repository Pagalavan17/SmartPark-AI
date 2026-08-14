import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartpark_ai/l10n/app_localizations.dart';
import 'package:smartpark_ai/providers/app_state_providers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Comprehensive Project-Wide Localization Audit Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('1. English (en) locale loads successfully with all new keys', () async {
      final l10n = await AppLocalizations.delegate.load(const Locale('en'));
      expect(l10n.appName, equals('SmartPark AI'));
      expect(l10n.selectLanguage, equals('Select Language'));
      expect(l10n.reserveNow, equals('Reserve Now'));
      expect(l10n.payNow, equals('Pay Now'));
      expect(l10n.qrPassTitle, equals('Digital QR Pass'));
      expect(l10n.adminDashboard, equals('Enterprise AI Admin Dashboard'));
      expect(l10n.paymentHistoryTitle, equals('Payment & Transaction History'));
      expect(l10n.notificationsTitle, equals('Smart Notifications'));
      expect(l10n.smartReservationWizard, equals('Smart Reservation Wizard'));
      expect(l10n.today, equals('Today'));
      expect(l10n.thisWeek, equals('This Week'));
      expect(l10n.thisMonth, equals('This Month'));
    });

    test('2. Tamil (ta) locale loads successfully with all new keys', () async {
      final l10n = await AppLocalizations.delegate.load(const Locale('ta'));
      expect(l10n.appName, equals('ஸ்மார்ட்பார்க் AI'));
      expect(l10n.selectLanguage, equals('மொழியைத் தேர்ந்தெடுக்கவும்'));
      expect(l10n.reserveNow, equals('இப்போதே முன்பதிவு செய்'));
      expect(l10n.payNow, equals('இப்போதே செலுத்துக'));
      expect(l10n.tamil, equals('தமிழ்'));
      expect(l10n.adminDashboard, equals('ஏஐ நிர்வாக டாஷ்போர்டு'));
      expect(l10n.paymentHistoryTitle, equals('பணம் செலுத்தல் & பரிவர்த்தனை வரலாறு'));
      expect(l10n.notificationsTitle, equals('ஸ்மார்ட் அறிவிப்புகள்'));
      expect(l10n.today, equals('இன்று'));
      expect(l10n.thisWeek, equals('இந்த வாரம்'));
      expect(l10n.thisMonth, equals('இந்த மாதம்'));
    });

    test('3. Hindi (hi) locale loads successfully with all new keys', () async {
      final l10n = await AppLocalizations.delegate.load(const Locale('hi'));
      expect(l10n.appName, equals('स्मार्टपार्क AI'));
      expect(l10n.selectLanguage, equals('भाषा चुनें'));
      expect(l10n.reserveNow, equals('अभी बुक करें'));
      expect(l10n.hindi, equals('हिंदी'));
      expect(l10n.adminDashboard, equals('एआई एडमिन डैशबोर्ड'));
      expect(l10n.paymentHistoryTitle, equals('भुगतान और लेन-देन का इतिहास'));
      expect(l10n.notificationsTitle, equals('स्मार्ट सूचनाएं'));
      expect(l10n.today, equals('आज'));
      expect(l10n.thisWeek, equals('इस सप्ताह'));
      expect(l10n.thisMonth, equals('इस महीने'));
    });

    test('4. Malayalam (ml) locale loads successfully with all new keys', () async {
      final l10n = await AppLocalizations.delegate.load(const Locale('ml'));
      expect(l10n.appName, equals('സ്മാർട്ട്പാർക്ക് AI'));
      expect(l10n.selectLanguage, equals('ഭാഷ തിരഞ്ഞെടുക്കുക'));
      expect(l10n.reserveNow, equals('ഇപ്പോൾ ബുക്ക് ചെയ്യുക'));
      expect(l10n.malayalam, equals('മലയാളം'));
      expect(l10n.adminDashboard, equals('AI അഡ്മിൻ ഡാഷ്‌ബോർഡ്'));
      expect(l10n.paymentHistoryTitle, equals('ഇടപാട് ചരിത്രം'));
      expect(l10n.notificationsTitle, equals('സ്മാർട്ട് അറിയിപ്പുകൾ'));
      expect(l10n.today, equals('ഇന്ന്'));
      expect(l10n.thisWeek, equals('ഈ ആഴ്ച'));
      expect(l10n.thisMonth, equals('ഈ മാസം'));
    });

    test('5. Kannada (kn) locale loads successfully with all new keys', () async {
      final l10n = await AppLocalizations.delegate.load(const Locale('kn'));
      expect(l10n.appName, equals('ಸ್ಮಾರ್ಟ್‌ಪಾರ್ಕ್ AI'));
      expect(l10n.selectLanguage, equals('ಭಾಷೆಯನ್ನು ಆಯ್ಕೆಮಾಡಿ'));
      expect(l10n.reserveNow, equals('ಈಗಲೇ ಕಾಯ್ದಿರಿಸಿ'));
      expect(l10n.kannada, equals('ಕನ್ನಡ'));
      expect(l10n.adminDashboard, equals('AI ನಿರ್ವಾಹಕ ಡ್ಯಾಶ್‌ಬೋರ್ಡ್'));
      expect(l10n.paymentHistoryTitle, equals('ಪಾವತಿ ಮತ್ತು ವಹಿವಾಟು ಇತಿಹಾಸ'));
      expect(l10n.notificationsTitle, equals('ಸ್ಮಾರ್ಟ್ ಸೂಚನೆಗಳು'));
      expect(l10n.today, equals('ಇಂದು'));
      expect(l10n.thisWeek, equals('ಈ ವಾರ'));
      expect(l10n.thisMonth, equals('ಈ ತಿಂಗಳು'));
    });

    test('6. Dynamic & Parameterized ARB methods work across all 5 locales', () async {
      final locales = [
        const Locale('en'),
        const Locale('ta'),
        const Locale('hi'),
        const Locale('ml'),
        const Locale('kn'),
      ];

      for (final loc in locales) {
        final l10n = await AppLocalizations.delegate.load(loc);
        expect(l10n.slotsFree(24), contains('24'));
        expect(l10n.ratePerHour(40), contains('40'));
        expect(l10n.aiScore(90), contains('90'));
        expect(l10n.kmAway(1.5), contains('1.5'));
        expect(l10n.minsWalk(5), contains('5'));
        expect(l10n.durationHours(3), contains('3'));
        expect(l10n.stepProgress(2), contains('2'));
        expect(l10n.walkingDistanceMeters(200), contains('200'));
        expect(l10n.peakSurgePlus(20), contains('20'));
        expect(l10n.passIdLabel('SP-101'), contains('SP-101'));
        expect(l10n.slotAllocatedLabel('A-12'), contains('A-12'));
        expect(l10n.methodLabel('UPI'), contains('UPI'));
        expect(l10n.exportingReport('Today', 'PDF'), contains('PDF'));
      }
    });

    test('7. LanguageNotifier changes active language state and persists to SharedPreferences', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(activeLanguageCodeProvider), equals('en'));

      await container.read(activeLanguageCodeProvider.notifier).setLanguage('ta');
      expect(container.read(activeLanguageCodeProvider), equals('ta'));

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('selected_language'), equals('ta'));

      await container.read(activeLanguageCodeProvider.notifier).setLanguage('kn');
      expect(container.read(activeLanguageCodeProvider), equals('kn'));
      expect(prefs.getString('selected_language'), equals('kn'));

      await container.read(activeLanguageCodeProvider.notifier).setLanguage('hi');
      expect(container.read(activeLanguageCodeProvider), equals('hi'));
      expect(prefs.getString('selected_language'), equals('hi'));

      await container.read(activeLanguageCodeProvider.notifier).setLanguage('ml');
      expect(container.read(activeLanguageCodeProvider), equals('ml'));
      expect(prefs.getString('selected_language'), equals('ml'));
    });
  });
}
