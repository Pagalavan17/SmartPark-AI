// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get appName => 'ஸ்மார்ட்பார்க் AI';

  @override
  String get welcomeTitle => 'AI உதவியுடன் சுலபமாக பார்க்கிங் கண்டறியவும்';

  @override
  String get welcomeSubtitle =>
      'நேரலை பார்க்கிங், ஸ்மார்ட் பாதைகள் மற்றும் உடனடி முன்பதிவு.';

  @override
  String get loading => 'ஏற்றப்படுகிறது...';

  @override
  String get error => 'பிழை';

  @override
  String get retry => 'மீண்டும் முயல்க';

  @override
  String get cancel => 'ரத்து செய்';

  @override
  String get confirm => 'உறுதி செய்';

  @override
  String get save => 'சேமி';

  @override
  String get done => 'முடிந்தது';

  @override
  String get back => 'பின்செல்';

  @override
  String get ok => 'சரி';

  @override
  String get viewAll => 'அனைத்தையும் காண்க';

  @override
  String get search => 'தேடுக';

  @override
  String get searchPlaceholder => 'இடம் அல்லது பார்க்கிங் தேடுக...';

  @override
  String get searchDestination => 'இடம் அல்லது அடையாளத்தை தேடுக...';

  @override
  String get aiRecommendation => 'AI பார்க்கிங் பரிந்துரை';

  @override
  String get aiRecommended => 'AI பரிந்துரைத்தது';

  @override
  String get trafficPrediction => 'போக்குவரத்து அறிவிப்பு';

  @override
  String get nearest => 'அருகிலுள்ள';

  @override
  String get cheapest => 'குறைந்த விலை';

  @override
  String get evCharging => 'EV சார்ஜிங்';

  @override
  String get covered => 'மூடப்பட்ட பார்க்கிங்';

  @override
  String get aiSmartPick => 'AI ஸ்மார்ட் தேர்வு';

  @override
  String get all => 'அனைத்தும்';

  @override
  String get currentLocation => 'தற்போதைய இடம்';

  @override
  String get parking => 'பார்க்கிங்';

  @override
  String get nearbyFacilities => 'அருகிலுள்ள இடங்கள்';

  @override
  String get liveParkingMap => 'நேரலை பார்க்கிங் வரைபடம்';

  @override
  String get parkingAvailable => 'பார்க்கிங் கிடைக்கிறது';

  @override
  String get noParkingAvailable => 'பார்க்கிங் இடங்கள் ஏதும் இல்லை.';

  @override
  String get unableToLoadParking =>
      'பார்க்கிங் விவரங்களை ஏற்ற முடியவில்லை.\nஇணைய இணைப்பை சரிபார்க்கவும்.';

  @override
  String get parkingDetails => 'பார்க்கிங் விவரங்கள்';

  @override
  String get parkingLocation => 'பார்க்கிங் அமைவிடம்';

  @override
  String get distance => 'தூரம்';

  @override
  String get walkingTime => 'நடக்கும் நேரம்';

  @override
  String get availableSlots => 'காலியாக உள்ள இடங்கள்';

  @override
  String get occupiedSlots => 'நிரப்பப்பட்ட இடங்கள்';

  @override
  String get totalSlots => 'மொத்த இடங்கள்';

  @override
  String get price => 'விலை';

  @override
  String get perHour => 'மணிநேரத்திற்கு';

  @override
  String ratePerHour(num rate) {
    return '₹$rate/மணி';
  }

  @override
  String slotsFree(int count) {
    return '$count இடங்கள் காலியாக உள்ளன';
  }

  @override
  String minsWalk(num count) {
    return '$count நிமிடம் நடை';
  }

  @override
  String kmAway(num count) {
    return '$count கி.மீ';
  }

  @override
  String aiScore(num score) {
    return '$score% AI மதிப்பெண்';
  }

  @override
  String get rating => 'மதிப்பீடு';

  @override
  String get totalCapacity => 'மொத்த கொள்ளளவு';

  @override
  String get hourlyRate => 'மணிநேர கட்டணம்';

  @override
  String get reserveSpot => 'பார்க்கிங் இடத்தை முன்பதிவு செய்';

  @override
  String get reserveNow => 'இப்போதே முன்பதிவு செய்';

  @override
  String get booking => 'முன்பதிவு';

  @override
  String get reservation => 'முன்பதிவு';

  @override
  String get activeBooking => 'செயலில் உள்ள பார்க்கிங் முன்பதிவு';

  @override
  String get selectDuration => 'நேரத்தைத் தேர்ந்தெடுக்கவும்';

  @override
  String get selectVehicle => 'வாகனத்தைத் தேர்ந்தெடுக்கவும்';

  @override
  String durationHours(int count) {
    return '$count மணிநேரம்';
  }

  @override
  String get startTime => 'தொடக்க நேரம்';

  @override
  String get endTime => 'முடிவு நேரம்';

  @override
  String get totalAmount => 'மொத்தத் தொகை';

  @override
  String get proceedToPay => 'பணம் செலுத்த தொடரவும்';

  @override
  String get bookingSuccessful => 'முன்பதிவு வெற்றிகரமாக முடிந்தது!';

  @override
  String get bookingFailed => 'முன்பதிவு தோல்வியடைந்தது. மீண்டும் முயல்க.';

  @override
  String get reservationConfirmed => 'முன்பதிவு உறுதிசெய்யப்பட்டது';

  @override
  String get spotReservedSuccessfully =>
      'உங்கள் பார்க்கிங் இடம் வெற்றிகரமாக முன்பதிவு செய்யப்பட்டது.';

  @override
  String get payment => 'பணம் செலுத்துதல்';

  @override
  String get payNow => 'இப்போதே செலுத்துக';

  @override
  String get payWithRazorpay => 'Razorpay மூலம் பணம் செலுத்துங்கள்';

  @override
  String get amount => 'தொகை';

  @override
  String get paymentSuccessful => 'பணம் செலுத்துதல் வெற்றி!';

  @override
  String get paymentFailed =>
      'பணம் செலுத்துதல் தோல்வியடைந்தது. மீண்டும் முயல்க.';

  @override
  String get transaction => 'பரிவர்த்தனை';

  @override
  String get transactionId => 'பரிவர்த்தனை எண்';

  @override
  String get paymentMethod => 'பணம் செலுத்தும் முறை';

  @override
  String get upi => 'UPI';

  @override
  String get card => 'கிரெடிட் / டெபிட் கார்டு';

  @override
  String get netBanking => 'நெட் பேங்கிங்';

  @override
  String get wallet => 'மொபைல் வாலட்';

  @override
  String get retryPayment => 'மீண்டும் செலுத்த முயல்க';

  @override
  String get qrPassTitle => 'நுழைவு / வெளியேற்ற QR பாஸ்';

  @override
  String get qrPass => 'QR பாஸ்';

  @override
  String get showQr => 'QR ஐக் காட்டு';

  @override
  String get scanQr => 'QR ஐ ஸ்கேன் செய்';

  @override
  String get scanQrAtGate =>
      'பார்க்கிங் நுழைவாயிலில் இந்த QR குறியீட்டை ஸ்கேன் செய்க';

  @override
  String get bookingId => 'முன்பதிவு எண்';

  @override
  String get validUntil => 'செல்லுபடியாகும் காலம்';

  @override
  String get download => 'பதிவிறக்கு';

  @override
  String get share => 'பகிர்';

  @override
  String get passActive => 'செயலில் உள்ள பாஸ்';

  @override
  String get profileTitle => 'பயனர் சுயவிவரம்';

  @override
  String get settingsTitle => 'பயன்பாட்டு அமைப்புகள்';

  @override
  String get settings => 'அமைப்புகள்';

  @override
  String get language => 'மொழி';

  @override
  String get selectLanguage => 'மொழியைத் தேர்ந்தெடுக்கவும்';

  @override
  String get english => 'ஆங்கிலம்';

  @override
  String get tamil => 'தமிழ்';

  @override
  String get hindi => 'இந்தி';

  @override
  String get malayalam => 'மலையாளம்';

  @override
  String get kannada => 'கன்னடம்';

  @override
  String get darkMode => 'டார்க் மோட்';

  @override
  String get themeLight => 'லைட் மோட்';

  @override
  String get themeDark => 'டார்க் மோட்';

  @override
  String get switchToLightMode => 'லைட் மோடிற்கு மாறவும்';

  @override
  String get switchToDarkMode => 'டார்க் மோடிற்கு மாறவும்';

  @override
  String get notifications => 'அறிவிப்புகள்';

  @override
  String get notificationsTitle => 'ஸ்மார்ட் அறிவிப்புகள்';

  @override
  String get helpSupport => 'உதவி & ஆதரவு';

  @override
  String get logout => 'வெளியேறு';

  @override
  String get myBookings => 'என் முன்பதிவுகள்';

  @override
  String get myVehicles => 'என் வாகனங்கள்';

  @override
  String get editProfile => 'சுயவிவரத்தைத் திருத்து';

  @override
  String get navigate => 'வழிசெலுத்து';

  @override
  String get startNavigation => 'வழிகாட்டலைத் தொடங்கு';

  @override
  String get destination => 'செல்லுமிடம்';

  @override
  String get home => 'முகப்பு';

  @override
  String get liveMap => 'நேரலை வரைபடம்';

  @override
  String get bookingHistory => 'முன்பதிவு வரலாறு';

  @override
  String get locationPermissionRequired =>
      'அருகிலுள்ள பார்க்கிங்கைக் கண்டறிய இருப்பிட அனுமதி தேவை.';

  @override
  String get locationPermissionDenied => 'இருப்பிட அனுமதி மறுக்கப்பட்டது.';

  @override
  String get internetConnectionRequired => 'இணைய இணைப்பு தேவை.';

  @override
  String get somethingWentWrong => 'ஏதோ தவறு நடந்தது. மீண்டும் முயல்க.';

  @override
  String get pleaseTryAgain => 'தயவுசெய்து மீண்டும் முயல்க.';

  @override
  String get adminDashboard => 'ஏஐ நிர்வாக டாஷ்போர்டு';

  @override
  String get platformExecutiveSummary => 'தளத்தின் முக்கிய சுருக்கம்';

  @override
  String get exportReports => 'அறிக்கைகளை ஏற்றுமதி செய்';

  @override
  String get exportPdfReport => 'PDF அறிக்கையை ஏற்றுமதி செய்';

  @override
  String get exportCsvData => 'CSV தரவை ஏற்றுமதி செய்';

  @override
  String get exportExcelSheet => 'Excel ஏட்டை ஏற்றுமதி செய்';

  @override
  String exportingReport(String timeframe, String format) {
    return '$timeframe அறிக்கையை $format ஆக ஏற்றுமதி செய்கிறது...';
  }

  @override
  String get today => 'இன்று';

  @override
  String get thisWeek => 'இந்த வாரம்';

  @override
  String get thisMonth => 'இந்த மாதம்';

  @override
  String get daily => 'தினசரி';

  @override
  String get weekly => 'வாராந்திர';

  @override
  String get monthly => 'மாதாந்திர';

  @override
  String get activeSensors => 'செயலில் உள்ள உணரிகள்';

  @override
  String get systemHealth => 'அமைப்பின் நிலை';

  @override
  String get occupancyRate => 'ஆக்கிரமிப்பு விகிதம்';

  @override
  String get totalRevenue => 'மொத்த வருவாய்';

  @override
  String get recentIncidents => 'சமீபத்திய சம்பவங்கள்';

  @override
  String get noIncidentsFound => 'எந்த சம்பவங்களும் பதிவு செய்யப்படவில்லை.';

  @override
  String get paymentHistoryTitle => 'பணம் செலுத்தல் & பரிவர்த்தனை வரலாறு';

  @override
  String get transactionHistory => 'பரிவர்த்தனை வரலாறு';

  @override
  String get noTransactionsFound => 'பரிவர்த்தனைகள் எதுவும் காணப்படவில்லை.';

  @override
  String get downloadInvoice => 'ரசீதைப் பதிவிறக்கு';

  @override
  String downloadingInvoice(String id) {
    return '#$id க்கான ரசீது பதிவிறக்கப்படுகிறது...';
  }

  @override
  String passNumber(String id) {
    return 'பாஸ் எண் #$id';
  }

  @override
  String methodLabel(String method) {
    return 'முறை: $method';
  }

  @override
  String dateLabel(String date) {
    return 'தேதி: $date';
  }

  @override
  String get statusSuccess => 'வெற்றி';

  @override
  String get statusFailed => 'தோல்வி';

  @override
  String get statusPending => 'நிலுவையில்';

  @override
  String get markAllAsRead => 'அனைத்தையும் படித்ததாகக் குறி';

  @override
  String get allNotificationsMarkedRead =>
      'அனைத்து அறிவிப்புகளும் படித்ததாகக் குறிக்கப்பட்டன.';

  @override
  String get noNotificationsAvailable => 'அறிவிப்புகள் எதுவும் இல்லை.';

  @override
  String get unableToLoadNotifications => 'அறிவிப்புகளை ஏற்ற முடியவில்லை.';

  @override
  String get categoryAll => 'அனைத்தும்';

  @override
  String get categoryReservation => 'முன்பதிவு';

  @override
  String get categoryAi => 'AI';

  @override
  String get categoryAdaptive => 'அடாப்டிவ்';

  @override
  String get categoryExpiry => 'காலாவதி';

  @override
  String get categorySurge => 'கூடுதல் கட்டணம்';

  @override
  String get aiSmartPickAvailable => 'AI ஸ்மார்ட் தேர்வு கிடைக்கிறது';

  @override
  String get lowTrafficRouteDetected =>
      'குறைந்த போக்குவரத்து பாதை கண்டறியப்பட்டது...';

  @override
  String get parkingExpiryWarning => 'பார்க்கிங் காலாவதி எச்சரிக்கை';

  @override
  String get peakSurgeAlert => 'அதிக போக்குவரத்து அறிவிப்பு';

  @override
  String minsAgo(int count) {
    return '$count நிமிடங்களுக்கு முன்';
  }

  @override
  String hoursAgo(int count) {
    return '$count மணிநேரத்திற்கு முன்';
  }

  @override
  String get lowestTraffic => 'குறைந்த போக்குவரத்து';

  @override
  String get openNow => 'தற்போது திறந்துள்ளது';

  @override
  String get locationServicesDisabled =>
      'இருப்பிடச் சேவை முடக்கப்பட்டுள்ளது. GPS ஐ இயக்கவும்.';

  @override
  String get locationPermissionRequiredMsg =>
      'வரைபடத்தில் உங்கள் இடத்தைக் காட்ட அனுமதி தேவை.';

  @override
  String get locationPermissionPermanentDeniedMsg =>
      'இருப்பிட அனுமதி நிரந்தரமாக மறுக்கப்பட்டது.';

  @override
  String get aiAdaptiveRerouting => 'AI தானியங்கி மாற்றுப்பாதை';

  @override
  String get betterParkingFound => 'சிறந்த பார்க்கிங் கண்டறியப்பட்டது:';

  @override
  String get priceDifference => 'விலை வித்தியாசம்:';

  @override
  String get acceptReroute => 'மாற்றுப்பாதையை ஏற்றுக்கொள்';

  @override
  String get decline => 'நிராகரி';

  @override
  String get openingGoogleMaps => 'Google Maps வழிகாட்டல் திறக்கப்படுகிறது...';

  @override
  String get parkingLotNotFound => 'பார்க்கிங் இடம் காணப்படவில்லை';

  @override
  String get unableToShareParking => 'பார்க்கிங் இணைப்பைப் பகிர முடியவில்லை';

  @override
  String get googleMapsNotOpened => 'Google Maps ஐ திறக்க முடியவில்லை.';

  @override
  String get lowestRouteTraffic => 'குறைந்த போக்குவரத்து பாதை';

  @override
  String walkingDistanceMeters(int meters) {
    return '$meters மீட்டர் நடை தூரம் மட்டுமே';
  }

  @override
  String get competitivePrice => 'சிறந்த பார்க்கிங் விலை';

  @override
  String peakSurgePlus(int percent) {
    return '⚡ உச்ச நேர கட்டணம் +$percent%';
  }

  @override
  String get highlySuitableLocation =>
      'அதிக இடவசதி கொண்ட மிகச் சிறந்த பார்க்கிங் இடம்.';

  @override
  String stepProgress(int step) {
    return 'படி $step / 5';
  }

  @override
  String get smartReservationWizard => 'ஸ்மார்ட் முன்பதிவு வழிகாட்டி';

  @override
  String get selectArrivalTime => '1. வரும் நேரத்தைத் தேர்ந்தெடுக்கவும்';

  @override
  String get selectParkingDuration =>
      '2. பார்க்கிங் கால அளவைத் தேர்ந்தெடுக்கவும்';

  @override
  String get selectVehicleStep => '3. வாகனத்தைத் தேர்ந்தெடுக்கவும்';

  @override
  String get reviewBookingSummary => '4. முன்பதிவை சரிபார்க்கவும்';

  @override
  String get instantEntryNow => 'இப்போது (உடனடி நுழைவு)';

  @override
  String get vehicleTypeFilter => 'வாகன வகை வடிகட்டி';

  @override
  String get copiedToClipboard => 'முன்பதிவு எண் நகலெடுக்கப்பட்டது!';

  @override
  String get viewFullPass => 'முழு பாஸைக் காண்க';

  @override
  String passIdLabel(String id) {
    return 'பாஸ் எண்: #$id';
  }

  @override
  String slotAllocatedLabel(String slot) {
    return 'ஒதுக்கப்பட்ட இடம்: $slot';
  }

  @override
  String get parkingAndReasoning => 'பார்க்கிங் & விவரங்கள்';

  @override
  String get userAndAccount => 'பயனர் & கணக்கு';

  @override
  String get systemAndSupport => 'அமைப்பு & உதவி';

  @override
  String get aboutSmartPark => 'ஸ்மார்ட்பார்க் AI பற்றி';

  @override
  String get returnToHome => 'முகப்பிற்குத் திரும்பு';
}
