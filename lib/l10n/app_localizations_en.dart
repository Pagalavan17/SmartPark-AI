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
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get retry => 'Retry';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get save => 'Save';

  @override
  String get done => 'Done';

  @override
  String get back => 'Back';

  @override
  String get ok => 'OK';

  @override
  String get viewAll => 'View All';

  @override
  String get search => 'Search';

  @override
  String get searchPlaceholder => 'Search destination or parking...';

  @override
  String get searchDestination => 'Search destination or landmark...';

  @override
  String get aiRecommendation => 'AI Parking Recommendation';

  @override
  String get aiRecommended => 'AI Recommended';

  @override
  String get trafficPrediction => 'Traffic & Congestion Alert';

  @override
  String get nearest => 'Nearest';

  @override
  String get cheapest => 'Cheapest';

  @override
  String get evCharging => 'EV Charging';

  @override
  String get covered => 'Covered';

  @override
  String get aiSmartPick => 'AI Smart Pick';

  @override
  String get all => 'All';

  @override
  String get currentLocation => 'Current location';

  @override
  String get parking => 'Parking';

  @override
  String get nearbyFacilities => 'Nearby Facilities';

  @override
  String get liveParkingMap => 'Live Parking Map';

  @override
  String get parkingAvailable => 'Parking Available';

  @override
  String get noParkingAvailable => 'No parking locations available.';

  @override
  String get unableToLoadParking =>
      'Unable to load parking locations.\nCheck your internet connection and try again.';

  @override
  String get parkingDetails => 'Parking Details';

  @override
  String get parkingLocation => 'Parking Location';

  @override
  String get distance => 'Distance';

  @override
  String get walkingTime => 'Walking time';

  @override
  String get availableSlots => 'Available slots';

  @override
  String get occupiedSlots => 'Occupied slots';

  @override
  String get totalSlots => 'Total slots';

  @override
  String get price => 'Price';

  @override
  String get perHour => 'per hour';

  @override
  String ratePerHour(num rate) {
    return '₹$rate/hr';
  }

  @override
  String slotsFree(int count) {
    return '$count slots free';
  }

  @override
  String minsWalk(num count) {
    return '$count mins walk';
  }

  @override
  String kmAway(num count) {
    return '$count km';
  }

  @override
  String aiScore(num score) {
    return '$score% AI Score';
  }

  @override
  String get rating => 'Rating';

  @override
  String get totalCapacity => 'Total Capacity';

  @override
  String get hourlyRate => 'Hourly Rate';

  @override
  String get reserveSpot => 'Reserve Parking Slot';

  @override
  String get reserveNow => 'Reserve Now';

  @override
  String get booking => 'Booking';

  @override
  String get reservation => 'Reservation';

  @override
  String get activeBooking => 'Active Parking Reservation';

  @override
  String get selectDuration => 'Select Duration';

  @override
  String get selectVehicle => 'Select Vehicle';

  @override
  String durationHours(int count) {
    return '$count Hours';
  }

  @override
  String get startTime => 'Start Time';

  @override
  String get endTime => 'End Time';

  @override
  String get totalAmount => 'Total Amount';

  @override
  String get proceedToPay => 'Proceed to Pay';

  @override
  String get bookingSuccessful => 'Booking successful!';

  @override
  String get bookingFailed => 'Booking failed. Please try again.';

  @override
  String get reservationConfirmed => 'Reservation Confirmed';

  @override
  String get spotReservedSuccessfully =>
      'Your parking spot has been reserved successfully.';

  @override
  String get payment => 'Payment';

  @override
  String get payNow => 'Pay Now';

  @override
  String get payWithRazorpay => 'Pay with Razorpay';

  @override
  String get amount => 'Amount';

  @override
  String get paymentSuccessful => 'Payment Successful!';

  @override
  String get paymentFailed => 'Payment failed. Please try again.';

  @override
  String get transaction => 'Transaction';

  @override
  String get transactionId => 'Transaction ID';

  @override
  String get paymentMethod => 'Payment Method';

  @override
  String get upi => 'UPI';

  @override
  String get card => 'Credit / Debit Card';

  @override
  String get netBanking => 'Net Banking';

  @override
  String get wallet => 'Mobile Wallet';

  @override
  String get retryPayment => 'Retry Payment';

  @override
  String get qrPassTitle => 'Digital QR Pass';

  @override
  String get qrPass => 'QR Pass';

  @override
  String get showQr => 'Show QR';

  @override
  String get scanQr => 'Scan QR';

  @override
  String get scanQrAtGate => 'Scan this QR code at the parking gate';

  @override
  String get bookingId => 'Booking ID';

  @override
  String get validUntil => 'Valid Until';

  @override
  String get download => 'Download';

  @override
  String get share => 'Share';

  @override
  String get passActive => 'Active Pass';

  @override
  String get profileTitle => 'User Profile';

  @override
  String get settingsTitle => 'App Settings';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get english => 'English';

  @override
  String get tamil => 'Tamil';

  @override
  String get hindi => 'Hindi';

  @override
  String get malayalam => 'Malayalam';

  @override
  String get kannada => 'Kannada';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get themeLight => 'Light Mode';

  @override
  String get themeDark => 'Dark Mode';

  @override
  String get switchToLightMode => 'Switch to Light Mode';

  @override
  String get switchToDarkMode => 'Switch to Dark Mode';

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationsTitle => 'Smart Notifications';

  @override
  String get helpSupport => 'Help & Support';

  @override
  String get logout => 'Logout';

  @override
  String get myBookings => 'My Bookings';

  @override
  String get myVehicles => 'My Vehicles';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get navigate => 'Navigate';

  @override
  String get startNavigation => 'Start Navigation';

  @override
  String get destination => 'Destination';

  @override
  String get home => 'Home';

  @override
  String get liveMap => 'Live Map';

  @override
  String get bookingHistory => 'Booking History';

  @override
  String get locationPermissionRequired =>
      'Location permission is required to find nearby parking.';

  @override
  String get locationPermissionDenied => 'Location permission denied.';

  @override
  String get internetConnectionRequired => 'Internet connection required.';

  @override
  String get somethingWentWrong => 'Something went wrong. Please try again.';

  @override
  String get pleaseTryAgain => 'Please try again.';

  @override
  String get adminDashboard => 'Enterprise AI Admin Dashboard';

  @override
  String get platformExecutiveSummary => 'Platform Executive Summary';

  @override
  String get exportReports => 'Export Reports';

  @override
  String get exportPdfReport => 'Export PDF Report';

  @override
  String get exportCsvData => 'Export CSV Data';

  @override
  String get exportExcelSheet => 'Export Excel Sheet';

  @override
  String exportingReport(String timeframe, String format) {
    return 'Exporting $timeframe Report as $format...';
  }

  @override
  String get today => 'Today';

  @override
  String get thisWeek => 'This Week';

  @override
  String get thisMonth => 'This Month';

  @override
  String get daily => 'Daily';

  @override
  String get weekly => 'Weekly';

  @override
  String get monthly => 'Monthly';

  @override
  String get activeSensors => 'Active Sensors';

  @override
  String get systemHealth => 'System Health';

  @override
  String get occupancyRate => 'Occupancy Rate';

  @override
  String get totalRevenue => 'Total Revenue';

  @override
  String get recentIncidents => 'Recent Incidents';

  @override
  String get noIncidentsFound => 'No incidents reported.';

  @override
  String get paymentHistoryTitle => 'Payment & Transaction History';

  @override
  String get transactionHistory => 'Transaction History';

  @override
  String get noTransactionsFound => 'No payment transactions found.';

  @override
  String get downloadInvoice => 'Download Invoice';

  @override
  String downloadingInvoice(String id) {
    return 'Downloading invoice for #$id...';
  }

  @override
  String passNumber(String id) {
    return 'Pass #$id';
  }

  @override
  String methodLabel(String method) {
    return 'Method: $method';
  }

  @override
  String dateLabel(String date) {
    return 'Date: $date';
  }

  @override
  String get statusSuccess => 'Success';

  @override
  String get statusFailed => 'Failed';

  @override
  String get statusPending => 'Pending';

  @override
  String get markAllAsRead => 'Mark all as read';

  @override
  String get allNotificationsMarkedRead => 'All notifications marked as read.';

  @override
  String get noNotificationsAvailable => 'No notifications available.';

  @override
  String get unableToLoadNotifications => 'Unable to load notifications.';

  @override
  String get categoryAll => 'All';

  @override
  String get categoryReservation => 'Reservation';

  @override
  String get categoryAi => 'AI';

  @override
  String get categoryAdaptive => 'Adaptive';

  @override
  String get categoryExpiry => 'Expiry';

  @override
  String get categorySurge => 'Surge';

  @override
  String get aiSmartPickAvailable => 'AI Smart Pick Available';

  @override
  String get lowTrafficRouteDetected => 'Low traffic route detected...';

  @override
  String get parkingExpiryWarning => 'Parking Expiry Warning';

  @override
  String get peakSurgeAlert => 'Peak Surge Alert';

  @override
  String minsAgo(int count) {
    return '$count mins ago';
  }

  @override
  String hoursAgo(int count) {
    return '$count hours ago';
  }

  @override
  String get lowestTraffic => 'Lowest Traffic';

  @override
  String get openNow => 'Open Now';

  @override
  String get locationServicesDisabled =>
      'Location services are disabled. Please enable GPS in device settings.';

  @override
  String get locationPermissionRequiredMsg =>
      'Location permission is required to center the map on your position.';

  @override
  String get locationPermissionPermanentDeniedMsg =>
      'Location permission is permanently denied.';

  @override
  String get aiAdaptiveRerouting => 'AI Adaptive Re-routing';

  @override
  String get betterParkingFound => 'Better Parking Found:';

  @override
  String get priceDifference => 'Price difference:';

  @override
  String get acceptReroute => 'Accept Reroute';

  @override
  String get decline => 'Decline';

  @override
  String get openingGoogleMaps => 'Opening Google Maps navigation...';

  @override
  String get parkingLotNotFound => 'Parking Lot Not Found';

  @override
  String get unableToShareParking => 'Unable to share parking link';

  @override
  String get googleMapsNotOpened =>
      'Google Maps could not be opened. Please make sure Google Maps is installed.';

  @override
  String get lowestRouteTraffic => 'Lowest predicted route traffic';

  @override
  String walkingDistanceMeters(int meters) {
    return 'Walking distance only $meters meters';
  }

  @override
  String get competitivePrice => 'Competitive parking price';

  @override
  String peakSurgePlus(int percent) {
    return '⚡ Peak Surge +$percent%';
  }

  @override
  String get highlySuitableLocation =>
      'Highly suitable parking location with good availability.';

  @override
  String stepProgress(int step) {
    return 'Step $step of 5';
  }

  @override
  String get smartReservationWizard => 'Smart Reservation Wizard';

  @override
  String get selectArrivalTime => '1. Select Arrival Time';

  @override
  String get selectParkingDuration => '2. Select Parking Duration';

  @override
  String get selectVehicleStep => '3. Select Vehicle';

  @override
  String get reviewBookingSummary => '4. Review Booking Summary';

  @override
  String get instantEntryNow => 'Now (Instant Entry)';

  @override
  String get vehicleTypeFilter => 'Vehicle Type Filter';

  @override
  String get copiedToClipboard => 'Reservation ID copied to clipboard!';

  @override
  String get viewFullPass => 'View Full Pass';

  @override
  String passIdLabel(String id) {
    return 'Pass ID: #$id';
  }

  @override
  String slotAllocatedLabel(String slot) {
    return 'Slot Allocated: $slot';
  }

  @override
  String get parkingAndReasoning => 'PARKING & REASONING';

  @override
  String get userAndAccount => 'USER & ACCOUNT';

  @override
  String get systemAndSupport => 'SYSTEM & SUPPORT';

  @override
  String get aboutSmartPark => 'About SmartPark AI';

  @override
  String get returnToHome => 'Return To Home';
}
