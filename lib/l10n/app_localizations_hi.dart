// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appName => 'स्मार्टपार्क AI';

  @override
  String get welcomeTitle => 'AI के साथ आसानी से पार्किंग खोजें';

  @override
  String get welcomeSubtitle =>
      'रियल-टाइम पार्किंग, स्मार्ट रास्ते और तुरंत बुकिंग आपके हाथों में।';

  @override
  String get loading => 'लोड हो रहा है...';

  @override
  String get error => 'त्रुटि';

  @override
  String get retry => 'पुनः प्रयास करें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get confirm => 'पुष्टि करें';

  @override
  String get save => 'सहेजें';

  @override
  String get done => 'संपन्न';

  @override
  String get back => 'वापस';

  @override
  String get ok => 'ठीक है';

  @override
  String get viewAll => 'सभी देखें';

  @override
  String get search => 'खोजें';

  @override
  String get searchPlaceholder => 'स्थान या पार्किंग खोजें...';

  @override
  String get searchDestination => 'गंतव्य या लैंडमार्क खोजें...';

  @override
  String get aiRecommendation => 'AI पार्किंग सिफारिश';

  @override
  String get aiRecommended => 'AI अनुशंसित';

  @override
  String get trafficPrediction => 'यातायात चेतावनी';

  @override
  String get nearest => 'निकटतम';

  @override
  String get cheapest => 'सबसे सस्ता';

  @override
  String get evCharging => 'EV चार्जिंग';

  @override
  String get covered => 'कवर्ड पार्किंग';

  @override
  String get aiSmartPick => 'AI स्मार्ट चयन';

  @override
  String get all => 'सभी';

  @override
  String get currentLocation => 'वर्तमान स्थान';

  @override
  String get parking => 'पार्किंग';

  @override
  String get nearbyFacilities => 'आस-पास की सुविधाएं';

  @override
  String get liveParkingMap => 'लाइव पार्किंग मानचित्र';

  @override
  String get parkingAvailable => 'पार्किंग उपलब्ध है';

  @override
  String get noParkingAvailable => 'कोई पार्किंग स्थान उपलब्ध नहीं है।';

  @override
  String get unableToLoadParking =>
      'पार्किंग स्थान लोड करने में असमर्थ।\nअपना इंटरनेट कनेक्शन जांचें।';

  @override
  String get parkingDetails => 'पार्किंग विवरण';

  @override
  String get parkingLocation => 'पार्किंग स्थान';

  @override
  String get distance => 'दूरी';

  @override
  String get walkingTime => 'पैदल चलने का समय';

  @override
  String get availableSlots => 'उपलब्ध स्लॉट';

  @override
  String get occupiedSlots => 'भरे हुए स्लॉट';

  @override
  String get totalSlots => 'कुल स्लॉट';

  @override
  String get price => 'कीमत';

  @override
  String get perHour => 'प्रति घंटा';

  @override
  String ratePerHour(num rate) {
    return '₹$rate/घंटा';
  }

  @override
  String slotsFree(int count) {
    return '$count स्लॉट उपलब्ध';
  }

  @override
  String minsWalk(num count) {
    return '$count मिनट पैदल';
  }

  @override
  String kmAway(num count) {
    return '$count किमी';
  }

  @override
  String aiScore(num score) {
    return '$score% AI स्कोर';
  }

  @override
  String get rating => 'रेटिंग';

  @override
  String get totalCapacity => 'कुल क्षमता';

  @override
  String get hourlyRate => 'प्रति घंटा दर';

  @override
  String get reserveSpot => 'पार्किंग स्लॉट बुक करें';

  @override
  String get reserveNow => 'अभी बुक करें';

  @override
  String get booking => 'बुकिंग';

  @override
  String get reservation => 'आरक्षण';

  @override
  String get activeBooking => 'सक्रिय पार्किंग बुकिंग';

  @override
  String get selectDuration => 'समयावधि चुनें';

  @override
  String get selectVehicle => 'वाहन चुनें';

  @override
  String durationHours(int count) {
    return '$count घंटे';
  }

  @override
  String get startTime => 'शुरू होने का समय';

  @override
  String get endTime => 'समाप्त होने का समय';

  @override
  String get totalAmount => 'कुल राशि';

  @override
  String get proceedToPay => 'भुगतान के लिए आगे बढ़ें';

  @override
  String get bookingSuccessful => 'बुकिंग सफल रही!';

  @override
  String get bookingFailed => 'बुकिंग विफल। कृपया पुनः प्रयास करें।';

  @override
  String get reservationConfirmed => 'बुकिंग की पुष्टि हो गई';

  @override
  String get spotReservedSuccessfully =>
      'आपका पार्किंग स्थान सफलतापूर्वक आरक्षित हो गया है।';

  @override
  String get payment => 'भुगतान';

  @override
  String get payNow => 'अभी भुगतान करें';

  @override
  String get payWithRazorpay => 'Razorpay से भुगतान करें';

  @override
  String get amount => 'राशि';

  @override
  String get paymentSuccessful => 'भुगतान सफल रहा!';

  @override
  String get paymentFailed => 'भुगतान विफल रहा। पुनः प्रयास करें।';

  @override
  String get transaction => 'लेन-देन';

  @override
  String get transactionId => 'लेन-देन आईडी';

  @override
  String get paymentMethod => 'भुगतान का तरीका';

  @override
  String get upi => 'UPI';

  @override
  String get card => 'क्रेडिट / डेबिट कार्ड';

  @override
  String get netBanking => 'नेट बैंकिंग';

  @override
  String get wallet => 'मोबाइल वॉलेट';

  @override
  String get retryPayment => 'पुनः भुगतान प्रयास करें';

  @override
  String get qrPassTitle => 'प्रवेश / निकास QR पास';

  @override
  String get qrPass => 'QR पास';

  @override
  String get showQr => 'QR दिखाएं';

  @override
  String get scanQr => 'QR स्कैन करें';

  @override
  String get scanQrAtGate => 'पार्किंग गेट पर यह QR कोड स्कैन करें';

  @override
  String get bookingId => 'बुकिंग आईडी';

  @override
  String get validUntil => 'तक वैध';

  @override
  String get download => 'डाउनलोड';

  @override
  String get share => 'शेयर करें';

  @override
  String get passActive => 'सक्रिय पास';

  @override
  String get profileTitle => 'उपयोगकर्ता प्रोफ़ाइल';

  @override
  String get settingsTitle => 'ऐप सेटिंग्स';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get language => 'भाषा';

  @override
  String get selectLanguage => 'भाषा चुनें';

  @override
  String get english => 'अंग्रेज़ी';

  @override
  String get tamil => 'तमिल';

  @override
  String get hindi => 'हिंदी';

  @override
  String get malayalam => 'मलयालम';

  @override
  String get kannada => 'कन्नड़';

  @override
  String get darkMode => 'डार्क मोड';

  @override
  String get themeLight => 'लाइट मोड';

  @override
  String get themeDark => 'डार्क मोड';

  @override
  String get switchToLightMode => 'लाइट मोड पर स्विच करें';

  @override
  String get switchToDarkMode => 'डार्क मोड पर स्विच करें';

  @override
  String get notifications => 'सूचनाएं';

  @override
  String get notificationsTitle => 'स्मार्ट सूचनाएं';

  @override
  String get helpSupport => 'सहायता और समर्थन';

  @override
  String get logout => 'लॉगआउट';

  @override
  String get myBookings => 'मेरी बुकिंग';

  @override
  String get myVehicles => 'मेरे वाहन';

  @override
  String get editProfile => 'प्रोफ़ाइल संपादित करें';

  @override
  String get navigate => 'नेविगेट करें';

  @override
  String get startNavigation => 'नेविगेशन शुरू करें';

  @override
  String get destination => 'गंतव्य';

  @override
  String get home => 'होम';

  @override
  String get liveMap => 'लाइव मैप';

  @override
  String get bookingHistory => 'बुकिंग इतिहास';

  @override
  String get locationPermissionRequired =>
      'आस-पास की पार्किंग खोजने के लिए लोकेशन अनुमति आवश्यक है।';

  @override
  String get locationPermissionDenied => 'लोकेशन अनुमति अस्वीकृत।';

  @override
  String get internetConnectionRequired => 'इंटरनेट कनेक्शन आवश्यक है।';

  @override
  String get somethingWentWrong => 'कुछ गलत हो गया। पुनः प्रयास करें।';

  @override
  String get pleaseTryAgain => 'कृपया पुनः प्रयास करें।';

  @override
  String get adminDashboard => 'एआई एडमिन डैशबोर्ड';

  @override
  String get platformExecutiveSummary => 'प्लेटफ़ॉर्म सारांश';

  @override
  String get exportReports => 'रिपोर्ट निर्यात करें';

  @override
  String get exportPdfReport => 'PDF रिपोर्ट निर्यात करें';

  @override
  String get exportCsvData => 'CSV डेटा निर्यात करें';

  @override
  String get exportExcelSheet => 'Excel शीट निर्यात करें';

  @override
  String exportingReport(String timeframe, String format) {
    return '$timeframe रिपोर्ट को $format के रूप में निर्यात किया जा रहा है...';
  }

  @override
  String get today => 'आज';

  @override
  String get thisWeek => 'इस सप्ताह';

  @override
  String get thisMonth => 'इस महीने';

  @override
  String get daily => 'दैनिक';

  @override
  String get weekly => 'साप्ताहिक';

  @override
  String get monthly => 'मासिक';

  @override
  String get activeSensors => 'सक्रिय सेंसर';

  @override
  String get systemHealth => 'सिस्टम स्थिति';

  @override
  String get occupancyRate => 'उपस्थिति दर';

  @override
  String get totalRevenue => 'कुल राजस्व';

  @override
  String get recentIncidents => 'हाल की घटनाएं';

  @override
  String get noIncidentsFound => 'कोई घटना दर्ज नहीं की गई।';

  @override
  String get paymentHistoryTitle => 'भुगतान और लेन-देन का इतिहास';

  @override
  String get transactionHistory => 'लेन-देन इतिहास';

  @override
  String get noTransactionsFound => 'कोई भुगतान लेन-देन नहीं मिला।';

  @override
  String get downloadInvoice => 'रसीद डाउनलोड करें';

  @override
  String downloadingInvoice(String id) {
    return '#$id के लिए रसीद डाउनलोड हो रही है...';
  }

  @override
  String passNumber(String id) {
    return 'पास संख्या #$id';
  }

  @override
  String methodLabel(String method) {
    return 'तरीका: $method';
  }

  @override
  String dateLabel(String date) {
    return 'दिनांक: $date';
  }

  @override
  String get statusSuccess => 'सफल';

  @override
  String get statusFailed => 'विफल';

  @override
  String get statusPending => 'लंबित';

  @override
  String get markAllAsRead => 'सभी को पढ़ा हुआ चिह्नित करें';

  @override
  String get allNotificationsMarkedRead =>
      'सभी सूचनाओं को पढ़ा हुआ चिह्नित किया गया।';

  @override
  String get noNotificationsAvailable => 'कोई सूचना उपलब्ध नहीं है।';

  @override
  String get unableToLoadNotifications => 'सूचनाएं लोड करने में असमर्थ।';

  @override
  String get categoryAll => 'सभी';

  @override
  String get categoryReservation => 'बुकिंग';

  @override
  String get categoryAi => 'AI';

  @override
  String get categoryAdaptive => 'अनुकूली';

  @override
  String get categoryExpiry => 'समाप्ति';

  @override
  String get categorySurge => 'सर्ज';

  @override
  String get aiSmartPickAvailable => 'AI स्मार्ट चयन उपलब्ध है';

  @override
  String get lowTrafficRouteDetected => 'कम ट्रैफिक वाला रास्ता मिला...';

  @override
  String get parkingExpiryWarning => 'पार्किंग समाप्ति चेतावनी';

  @override
  String get peakSurgeAlert => 'पीक सर्ज चेतावनी';

  @override
  String minsAgo(int count) {
    return '$count मिनट पहले';
  }

  @override
  String hoursAgo(int count) {
    return '$count घंटे पहले';
  }

  @override
  String get lowestTraffic => 'सबसे कम ट्रैफिक';

  @override
  String get openNow => 'अभी खुला है';

  @override
  String get locationServicesDisabled =>
      'लोकेशन सेवाएं अक्षम हैं। GPS सक्षम करें।';

  @override
  String get locationPermissionRequiredMsg =>
      'मानचित्र पर स्थान दिखाने के लिए अनुमति आवश्यक है।';

  @override
  String get locationPermissionPermanentDeniedMsg =>
      'लोकेशन अनुमति स्थायी रूप से अस्वीकृत है।';

  @override
  String get aiAdaptiveRerouting => 'AI ऑटो-रीरूटिंग';

  @override
  String get betterParkingFound => 'बेहतर पार्किंग मिली:';

  @override
  String get priceDifference => 'कीमत का अंतर:';

  @override
  String get acceptReroute => 'रीरूट स्वीकार करें';

  @override
  String get decline => 'अस्वीकार करें';

  @override
  String get openingGoogleMaps => 'गूगल मैप्स नेविगेशन खुल रहा है...';

  @override
  String get parkingLotNotFound => 'पार्किंग स्थान नहीं मिला';

  @override
  String get unableToShareParking => 'पार्किंग लिंक साझा करने में असमर्थ';

  @override
  String get googleMapsNotOpened => 'गूगल मैप्स नहीं खोला जा सका।';

  @override
  String get lowestRouteTraffic => 'न्यूनतम ट्रैफिक मार्ग';

  @override
  String walkingDistanceMeters(int meters) {
    return 'केवल $meters मीटर की दूरी';
  }

  @override
  String get competitivePrice => 'किफायती पार्किंग दर';

  @override
  String peakSurgePlus(int percent) {
    return '⚡ पीक सर्ज +$percent%';
  }

  @override
  String get highlySuitableLocation =>
      'उत्कृष्ट उपलब्धता के साथ अत्यंत उपयुक्त पार्किंग स्थान।';

  @override
  String stepProgress(int step) {
    return 'चरण $step / 5';
  }

  @override
  String get smartReservationWizard => 'स्मार्ट बुकिंग सहायक';

  @override
  String get selectArrivalTime => '1. पहुंचने का समय चुनें';

  @override
  String get selectParkingDuration => '2. पार्किंग की समयावधि चुनें';

  @override
  String get selectVehicleStep => '3. वाहन चुनें';

  @override
  String get reviewBookingSummary => '4. बुकिंग विवरण जांचें';

  @override
  String get instantEntryNow => 'अभी (तुरंत प्रवेश)';

  @override
  String get vehicleTypeFilter => 'वाहन प्रकार फ़िल्टर';

  @override
  String get copiedToClipboard => 'बुकिंग आईडी कॉपी हो गई!';

  @override
  String get viewFullPass => 'पूरा पास देखें';

  @override
  String passIdLabel(String id) {
    return 'पास आईडी: #$id';
  }

  @override
  String slotAllocatedLabel(String slot) {
    return 'आवंटित स्लॉट: $slot';
  }

  @override
  String get parkingAndReasoning => 'पार्किंग एवं विवरण';

  @override
  String get userAndAccount => 'उपयोगकर्ता एवं खाता';

  @override
  String get systemAndSupport => 'सिस्टम और सहायता';

  @override
  String get aboutSmartPark => 'स्मार्टपार्क AI के बारे में';

  @override
  String get returnToHome => 'होम पर वापस जाएं';
}
