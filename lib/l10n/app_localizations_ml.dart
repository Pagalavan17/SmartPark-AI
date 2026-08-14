// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malayalam (`ml`).
class AppLocalizationsMl extends AppLocalizations {
  AppLocalizationsMl([String locale = 'ml']) : super(locale);

  @override
  String get appName => 'സ്മാർട്ട്പാർക്ക് AI';

  @override
  String get welcomeTitle => 'AI സഹായത്തോടെ എളുപ്പത്തിൽ പാർക്കിംഗ് കണ്ടെത്തൂ';

  @override
  String get welcomeSubtitle =>
      'തത്സമയ പാർക്കിംഗ്, സ്മാർട്ട് വഴികൾ, തൽക്ഷണ ബുക്കിംഗ്.';

  @override
  String get loading => 'ലോഡുചെയ്യുന്നു...';

  @override
  String get error => 'പിശക്';

  @override
  String get retry => 'വീണ്ടും ശ്രമിക്കുക';

  @override
  String get cancel => 'റദ്ദാക്കുക';

  @override
  String get confirm => 'സ്ഥിരീകരിക്കുക';

  @override
  String get save => 'സേവ് ചെയ്യുക';

  @override
  String get done => 'പൂർത്തിയായി';

  @override
  String get back => 'പിന്നോട്ട്';

  @override
  String get ok => 'ശരി';

  @override
  String get viewAll => 'എല്ലാം കാണുക';

  @override
  String get search => 'തിരയുക';

  @override
  String get searchPlaceholder => 'സ്ഥലമോ പാർക്കിംഗോ തിരയുക...';

  @override
  String get searchDestination => 'ലക്ഷ്യസ്ഥാനം തിരയുക...';

  @override
  String get aiRecommendation => 'AI പാർക്കിംഗ് ശുപാർശ';

  @override
  String get aiRecommended => 'AI ശുപാർശ ചെയ്തത്';

  @override
  String get trafficPrediction => 'ഗതാഗത മുന്നറിയിപ്പ്';

  @override
  String get nearest => 'ഏറ്റവും അടുത്തുള്ളത്';

  @override
  String get cheapest => 'ഏറ്റവും കുറഞ്ഞ നിരക്ക്';

  @override
  String get evCharging => 'EV ചാർജിംഗ്';

  @override
  String get covered => 'കവേർഡ് പാർക്കിംഗ്';

  @override
  String get aiSmartPick => 'AI സ്മാർട്ട് തിരഞ്ഞെടുപ്പ്';

  @override
  String get all => 'എല്ലാം';

  @override
  String get currentLocation => 'നിലവിലെ സ്ഥലം';

  @override
  String get parking => 'പാർക്കിംഗ്';

  @override
  String get nearbyFacilities => 'സമീപത്തുള്ള പാർക്കിംഗുകൾ';

  @override
  String get liveParkingMap => 'തത്സമയ പാർക്കിംഗ് മാപ്പ്';

  @override
  String get parkingAvailable => 'പാർക്കിംഗ് ലഭ്യമാണ്';

  @override
  String get noParkingAvailable => 'പാർക്കിംഗ് സ്ഥലങ്ങൾ ലഭ്യമല്ല.';

  @override
  String get unableToLoadParking =>
      'പാർക്കിംഗ് വിവരങ്ങൾ ലഭ്യമാക്കാൻ കഴിഞ്ഞില്ല.\nഇന്റർനെറ്റ് കണക്ഷൻ പരിശോധിക്കുക.';

  @override
  String get parkingDetails => 'പാർക്കിംഗ് വിശദാംശങ്ങൾ';

  @override
  String get parkingLocation => 'പാർക്കിംഗ് സ്ഥലം';

  @override
  String get distance => 'ദൂരം';

  @override
  String get walkingTime => 'നടക്കാനുള്ള സമയം';

  @override
  String get availableSlots => 'ലഭ്യമായ സ്ലോട്ടുകൾ';

  @override
  String get occupiedSlots => 'ഉപയോഗത്തിലുള്ള സ്ലോട്ടുകൾ';

  @override
  String get totalSlots => 'ആകെ സ്ലോട്ടുകൾ';

  @override
  String get price => 'വില';

  @override
  String get perHour => 'മണിക്കൂറിന്';

  @override
  String ratePerHour(num rate) {
    return '₹$rate/മണിക്കൂർ';
  }

  @override
  String slotsFree(int count) {
    return '$count സ്ലോട്ടുകൾ ലഭ്യമാണ്';
  }

  @override
  String minsWalk(num count) {
    return '$count മിനിറ്റ് നടപ്പ്';
  }

  @override
  String kmAway(num count) {
    return '$count കി.മീ';
  }

  @override
  String aiScore(num score) {
    return '$score% AI സ്കോർ';
  }

  @override
  String get rating => 'റേറ്റിംഗ്';

  @override
  String get totalCapacity => 'ആകെ ശേഷി';

  @override
  String get hourlyRate => 'മണിക്കൂർ നിരക്ക്';

  @override
  String get reserveSpot => 'പാർക്കിംഗ് സ്ലോട്ട് ബുക്ക് ചെയ്യുക';

  @override
  String get reserveNow => 'ഇപ്പോൾ ബുക്ക് ചെയ്യുക';

  @override
  String get booking => 'ബുക്കിംഗ്';

  @override
  String get reservation => 'റിസർവേഷൻ';

  @override
  String get activeBooking => 'സജീവ പാർക്കിംഗ് റിസർവേഷൻ';

  @override
  String get selectDuration => 'സമയം തിരഞ്ഞെടുക്കുക';

  @override
  String get selectVehicle => 'വാഹനം തിരഞ്ഞെടുക്കുക';

  @override
  String durationHours(int count) {
    return '$count മണിക്കൂർ';
  }

  @override
  String get startTime => 'ആരംഭ സമയം';

  @override
  String get endTime => 'അവസാന സമയം';

  @override
  String get totalAmount => 'ആകെ തുക';

  @override
  String get proceedToPay => 'പണമടയ്ക്കാൻ തുടരുക';

  @override
  String get bookingSuccessful => 'ബുക്കിംഗ് വിജയിച്ചു!';

  @override
  String get bookingFailed => 'ബുക്കിംഗ് പരാജയപ്പെട്ടു. വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get reservationConfirmed => 'റിസർവേഷൻ സ്ഥിരീകരിച്ചു';

  @override
  String get spotReservedSuccessfully =>
      'നിങ്ങളുടെ പാർക്കിംഗ് സ്ലോട്ട് വിജയകരമായി റിസർവ് ചെയ്തു.';

  @override
  String get payment => 'പണമടയ്ക്കൽ';

  @override
  String get payNow => 'ഇപ്പോൾ പണമടയ്ക്കുക';

  @override
  String get payWithRazorpay => 'Razorpay വഴി പണമടയ്ക്കുക';

  @override
  String get amount => 'തുക';

  @override
  String get paymentSuccessful => 'പണമടയ്ക്കൽ വിജയിച്ചു!';

  @override
  String get paymentFailed => 'പണമടയ്ക്കൽ പരാജയപ്പെട്ടു. വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get transaction => 'ഇടപാട്';

  @override
  String get transactionId => 'ഇടപാട് ഐഡി';

  @override
  String get paymentMethod => 'പണമടയ്ക്കുന്ന രീതി';

  @override
  String get upi => 'UPI';

  @override
  String get card => 'ക്രഡിറ്റ് / ഡെബിറ്റ് കാർഡ്';

  @override
  String get netBanking => 'നെറ്റ് ബാങ്കിംഗ്';

  @override
  String get wallet => 'മൊബൈൽ വാലറ്റ്';

  @override
  String get retryPayment => 'വീണ്ടും പണമടയ്ക്കുക';

  @override
  String get qrPassTitle => 'എൻട്രി / എക്സിറ്റ് QR പാസ്';

  @override
  String get qrPass => 'QR പാസ്';

  @override
  String get showQr => 'QR കാണിക്കുക';

  @override
  String get scanQr => 'QR സ്കാൻ ചെയ്യുക';

  @override
  String get scanQrAtGate => 'പാർക്കിംഗ് ഗേറ്റിൽ ഈ QR കോഡ് സ്കാൻ ചെയ്യുക';

  @override
  String get bookingId => 'ബുക്കിംഗ് ഐഡി';

  @override
  String get validUntil => 'കാലാവധി';

  @override
  String get download => 'ഡൗൺലോഡ്';

  @override
  String get share => 'പങ്കുവെക്കുക';

  @override
  String get passActive => 'ആക്റ്റീവ് പാസ്';

  @override
  String get profileTitle => 'പ്രൊഫൈൽ';

  @override
  String get settingsTitle => 'ആപ്പ് ക്രമീകരണങ്ങൾ';

  @override
  String get settings => 'ക്രമീകരണങ്ങൾ';

  @override
  String get language => 'ഭാഷ';

  @override
  String get selectLanguage => 'ഭാഷ തിരഞ്ഞെടുക്കുക';

  @override
  String get english => 'ഇംഗ്ലീഷ്';

  @override
  String get tamil => 'തമിഴ്';

  @override
  String get hindi => 'ഹിന്ദി';

  @override
  String get malayalam => 'മലയാളം';

  @override
  String get kannada => 'കന്നഡ';

  @override
  String get darkMode => 'ഡാർക്ക് മോഡ്';

  @override
  String get themeLight => 'ലൈറ്റ് മോഡ്';

  @override
  String get themeDark => 'ഡാർക്ക് മോഡ്';

  @override
  String get switchToLightMode => 'ലൈറ്റ് മോഡിലേക്ക് മാറുക';

  @override
  String get switchToDarkMode => 'ഡാർക്ക് മോഡിലേക്ക് മാറുക';

  @override
  String get notifications => 'അറിയിപ്പുകൾ';

  @override
  String get notificationsTitle => 'സ്മാർട്ട് അറിയിപ്പുകൾ';

  @override
  String get helpSupport => 'സഹായം & പിന്തുണ';

  @override
  String get logout => 'ലോഗ് ഔട്ട്';

  @override
  String get myBookings => 'എന്റെ ബുക്കിംഗുകൾ';

  @override
  String get myVehicles => 'എന്റെ വാഹനങ്ങൾ';

  @override
  String get editProfile => 'പ്രൊഫൈൽ തിരുത്തുക';

  @override
  String get navigate => 'വഴികാട്ടുക';

  @override
  String get startNavigation => 'നാവിഗേഷൻ ആരംഭിക്കുക';

  @override
  String get destination => 'ലക്ഷ്യസ്ഥാനം';

  @override
  String get home => 'ഹോം';

  @override
  String get liveMap => 'ലൈവ് മാപ്പ്';

  @override
  String get bookingHistory => 'ബുക്കിംഗ് ചരിത്രം';

  @override
  String get locationPermissionRequired =>
      'സമീപത്തുള്ള പാർക്കിംഗ് കണ്ടെത്താൻ ലൊക്കേഷൻ അനുമതി ആവശ്യമാണ്.';

  @override
  String get locationPermissionDenied => 'ലൊക്കേഷൻ അനുമതി നിരസിച്ചു.';

  @override
  String get internetConnectionRequired => 'ഇന്റർനെറ്റ് കണക്ഷൻ ആവശ്യമാണ്.';

  @override
  String get somethingWentWrong => 'എന്തോ തകരാർ സംഭവിച്ചു. വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get pleaseTryAgain => 'ദയവായി വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get adminDashboard => 'AI അഡ്മിൻ ഡാഷ്‌ബോർഡ്';

  @override
  String get platformExecutiveSummary => 'പ്ലാറ്റ്‌ഫോം സംഗ്രഹം';

  @override
  String get exportReports => 'റിപ്പോർട്ടുകൾ എക്സ്പോർട്ട് ചെയ്യുക';

  @override
  String get exportPdfReport => 'PDF റിപ്പോർട്ട് എക്സ്പോർട്ട് ചെയ്യുക';

  @override
  String get exportCsvData => 'CSV ഡാറ്റ എക്സ്പോർട്ട് ചെയ്യുക';

  @override
  String get exportExcelSheet => 'Excel ഷീറ്റ് എക്സ്പോർട്ട് ചെയ്യുക';

  @override
  String exportingReport(String timeframe, String format) {
    return '$timeframe റിപ്പോർട്ട് $format ആയി എക്സ്പോർട്ട് ചെയ്യുന്നു...';
  }

  @override
  String get today => 'ഇന്ന്';

  @override
  String get thisWeek => 'ഈ ആഴ്ച';

  @override
  String get thisMonth => 'ഈ മാസം';

  @override
  String get daily => 'ദിവസേന';

  @override
  String get weekly => 'ആഴ്ചതോറും';

  @override
  String get monthly => 'മാസംതോറും';

  @override
  String get activeSensors => 'സജീവ സെൻസറുകൾ';

  @override
  String get systemHealth => 'സിസ്റ്റം അവസ്ഥ';

  @override
  String get occupancyRate => 'ഒക്യുപെൻസി നിരക്ക്';

  @override
  String get totalRevenue => 'ആകെ വരുമാനം';

  @override
  String get recentIncidents => 'സമീപകാല സംഭവങ്ങൾ';

  @override
  String get noIncidentsFound => 'സംഭവങ്ങളൊന്നും റിപ്പോർട്ട് ചെയ്തിട്ടില്ല.';

  @override
  String get paymentHistoryTitle => 'ഇടപാട് ചരിത്രം';

  @override
  String get transactionHistory => 'ഇടപാട് ചരിത്രം';

  @override
  String get noTransactionsFound => 'ഇടപാടുകളൊന്നും കണ്ടെത്തിയില്ല.';

  @override
  String get downloadInvoice => 'ഇൻവോയ്സ് ഡൗൺലോഡ് ചെയ്യുക';

  @override
  String downloadingInvoice(String id) {
    return '#$id നുള്ള ഇൻവോയ്സ് ഡൗൺലോഡ് ചെയ്യുന്നു...';
  }

  @override
  String passNumber(String id) {
    return 'പാസ് നമ്പർ #$id';
  }

  @override
  String methodLabel(String method) {
    return 'രീതി: $method';
  }

  @override
  String dateLabel(String date) {
    return 'തീയതി: $date';
  }

  @override
  String get statusSuccess => 'വിജയിച്ചു';

  @override
  String get statusFailed => 'പരാജയപ്പെട്ടു';

  @override
  String get statusPending => 'പെൻഡിംഗ്';

  @override
  String get markAllAsRead => 'എല്ലാം വായിച്ചതായി അടയാളപ്പെടുത്തുക';

  @override
  String get allNotificationsMarkedRead =>
      'എല്ലാ അറിയിപ്പുകളും വായിച്ചതായി അടയാളപ്പെടുത്തി.';

  @override
  String get noNotificationsAvailable => 'അറിയിപ്പുകളൊന്നും ലഭ്യമല്ല.';

  @override
  String get unableToLoadNotifications =>
      'അറിയിപ്പുകൾ ലോഡ് ചെയ്യാൻ കഴിഞ്ഞില്ല.';

  @override
  String get categoryAll => 'എല്ലാം';

  @override
  String get categoryReservation => 'റിസർവേഷൻ';

  @override
  String get categoryAi => 'AI';

  @override
  String get categoryAdaptive => 'അഡാപ്റ്റീവ്';

  @override
  String get categoryExpiry => 'കാലാവധി';

  @override
  String get categorySurge => 'സർജ് നിരക്ക്';

  @override
  String get aiSmartPickAvailable => 'AI സ്മാർട്ട് ചോയ്സ് ലഭ്യമാണ്';

  @override
  String get lowTrafficRouteDetected => 'കുറഞ്ഞ ട്രാഫിക്കുള്ള വഴി കണ്ടെത്തി...';

  @override
  String get parkingExpiryWarning => 'പാർക്കിംഗ് കാലാവധി മുന്നറിയിപ്പ്';

  @override
  String get peakSurgeAlert => 'പീക്ക് സർജ് മുന്നറിയിപ്പ്';

  @override
  String minsAgo(int count) {
    return '$count മിനിറ്റ് മുമ്പ്';
  }

  @override
  String hoursAgo(int count) {
    return '$count മണിക്കൂർ മുമ്പ്';
  }

  @override
  String get lowestTraffic => 'കുറഞ്ഞ ട്രാഫിക്';

  @override
  String get openNow => 'ഇപ്പോൾ തുറന്നിരിക്കുന്നു';

  @override
  String get locationServicesDisabled =>
      'ലൊക്കേഷൻ സേവനം നിർത്തിവെച്ചിരിക്കുന്നു. GPS ഓൺ ചെയ്യുക.';

  @override
  String get locationPermissionRequiredMsg =>
      'മാപ്പിൽ സ്ഥാനം കാണിക്കാൻ ലൊക്കേഷൻ അനുമതി ആവശ്യമാണ്.';

  @override
  String get locationPermissionPermanentDeniedMsg =>
      'ലൊക്കേഷൻ അനുമതി സ്ഥിരമായി നിരസിച്ചു.';

  @override
  String get aiAdaptiveRerouting => 'AI ഓട്ടോ മാപ്പ് മാറ്റം';

  @override
  String get betterParkingFound => 'മെച്ചപ്പെട്ട പാർക്കിംഗ് കണ്ടെത്തി:';

  @override
  String get priceDifference => 'നിരക്കിലെ വ്യത്യാസം:';

  @override
  String get acceptReroute => 'പുതിയ വഴി സ്വീകരിക്കുക';

  @override
  String get decline => 'നിരസിക്കുക';

  @override
  String get openingGoogleMaps => 'Google Maps തുറക്കുന്നു...';

  @override
  String get parkingLotNotFound => 'പാർക്കിംഗ് സ്ഥലം കണ്ടെത്താനായില്ല';

  @override
  String get unableToShareParking => 'പാർക്കിംഗ് ലിങ്ക് പങ്കിടാൻ കഴിഞ്ഞില്ല';

  @override
  String get googleMapsNotOpened => 'Google Maps തുറക്കാൻ കഴിഞ്ഞില്ല.';

  @override
  String get lowestRouteTraffic => 'ഏറ്റവും കുറഞ്ഞ ട്രാഫിക്കുള്ള വഴി';

  @override
  String walkingDistanceMeters(int meters) {
    return '$meters മീറ്റർ നടപ്പ് ദൂരം മാത്രം';
  }

  @override
  String get competitivePrice => 'മിതമായ പാർക്കിംഗ് നിരക്ക്';

  @override
  String peakSurgePlus(int percent) {
    return '⚡ പീക്ക് സർജ് +$percent%';
  }

  @override
  String get highlySuitableLocation => 'വളരെ സൗകര്യപ്രദമായ പാർക്കിംഗ് സ്ഥലം.';

  @override
  String stepProgress(int step) {
    return 'ഘട്ടം $step / 5';
  }

  @override
  String get smartReservationWizard => 'സ്മാർട്ട് ബുക്കിംഗ് സഹായി';

  @override
  String get selectArrivalTime => '1. എത്തുന്ന സമയം തിരഞ്ഞെടുക്കുക';

  @override
  String get selectParkingDuration => '2. പാർക്കിംഗ് സമയം തിരഞ്ഞെടുക്കുക';

  @override
  String get selectVehicleStep => '3. വാഹനം തിരഞ്ഞെടുക്കുക';

  @override
  String get reviewBookingSummary => '4. ബുക്കിംഗ് വിവരങ്ങൾ പരിശോധിക്കുക';

  @override
  String get instantEntryNow => 'ഇപ്പോൾ (ഉടനടി പ്രവേശനം)';

  @override
  String get vehicleTypeFilter => 'വാഹന തരം ഫിൽട്ടർ';

  @override
  String get copiedToClipboard => 'ബുക്കിംഗ് ഐഡി കോപ്പി ചെയ്തു!';

  @override
  String get viewFullPass => 'പൂർണ്ണ പാസ് കാണുക';

  @override
  String passIdLabel(String id) {
    return 'പാസ് ഐഡി: #$id';
  }

  @override
  String slotAllocatedLabel(String slot) {
    return 'ലഭിച്ച സ്ലോട്ട്: $slot';
  }

  @override
  String get parkingAndReasoning => 'പാർക്കിംഗ് വിശദാംശങ്ങൾ';

  @override
  String get userAndAccount => 'ഉപയോക്താവും അക്കൗണ്ടും';

  @override
  String get systemAndSupport => 'സിസ്റ്റം & പിന്തുണ';

  @override
  String get aboutSmartPark => 'സ്മാർട്ട്പാർക്ക് AI-യെക്കുറിച്ച്';

  @override
  String get returnToHome => 'ഹോമിലേക്ക് മടങ്ങുക';
}
