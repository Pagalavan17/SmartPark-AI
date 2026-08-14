import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_ml.dart';
import 'app_localizations_ta.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('kn'),
    Locale('ml'),
    Locale('ta'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'SmartPark AI'**
  String get appName;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Find Parking Effortlessly with AI'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Real-time parking, smart routes, and instant booking at your fingertips.'**
  String get welcomeSubtitle;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search destination or parking...'**
  String get searchPlaceholder;

  /// No description provided for @searchDestination.
  ///
  /// In en, this message translates to:
  /// **'Search destination or landmark...'**
  String get searchDestination;

  /// No description provided for @aiRecommendation.
  ///
  /// In en, this message translates to:
  /// **'AI Parking Recommendation'**
  String get aiRecommendation;

  /// No description provided for @aiRecommended.
  ///
  /// In en, this message translates to:
  /// **'AI Recommended'**
  String get aiRecommended;

  /// No description provided for @trafficPrediction.
  ///
  /// In en, this message translates to:
  /// **'Traffic & Congestion Alert'**
  String get trafficPrediction;

  /// No description provided for @nearest.
  ///
  /// In en, this message translates to:
  /// **'Nearest'**
  String get nearest;

  /// No description provided for @cheapest.
  ///
  /// In en, this message translates to:
  /// **'Cheapest'**
  String get cheapest;

  /// No description provided for @evCharging.
  ///
  /// In en, this message translates to:
  /// **'EV Charging'**
  String get evCharging;

  /// No description provided for @covered.
  ///
  /// In en, this message translates to:
  /// **'Covered'**
  String get covered;

  /// No description provided for @aiSmartPick.
  ///
  /// In en, this message translates to:
  /// **'AI Smart Pick'**
  String get aiSmartPick;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @currentLocation.
  ///
  /// In en, this message translates to:
  /// **'Current location'**
  String get currentLocation;

  /// No description provided for @parking.
  ///
  /// In en, this message translates to:
  /// **'Parking'**
  String get parking;

  /// No description provided for @nearbyFacilities.
  ///
  /// In en, this message translates to:
  /// **'Nearby Facilities'**
  String get nearbyFacilities;

  /// No description provided for @liveParkingMap.
  ///
  /// In en, this message translates to:
  /// **'Live Parking Map'**
  String get liveParkingMap;

  /// No description provided for @parkingAvailable.
  ///
  /// In en, this message translates to:
  /// **'Parking Available'**
  String get parkingAvailable;

  /// No description provided for @noParkingAvailable.
  ///
  /// In en, this message translates to:
  /// **'No parking locations available.'**
  String get noParkingAvailable;

  /// No description provided for @unableToLoadParking.
  ///
  /// In en, this message translates to:
  /// **'Unable to load parking locations.\nCheck your internet connection and try again.'**
  String get unableToLoadParking;

  /// No description provided for @parkingDetails.
  ///
  /// In en, this message translates to:
  /// **'Parking Details'**
  String get parkingDetails;

  /// No description provided for @parkingLocation.
  ///
  /// In en, this message translates to:
  /// **'Parking Location'**
  String get parkingLocation;

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @walkingTime.
  ///
  /// In en, this message translates to:
  /// **'Walking time'**
  String get walkingTime;

  /// No description provided for @availableSlots.
  ///
  /// In en, this message translates to:
  /// **'Available slots'**
  String get availableSlots;

  /// No description provided for @occupiedSlots.
  ///
  /// In en, this message translates to:
  /// **'Occupied slots'**
  String get occupiedSlots;

  /// No description provided for @totalSlots.
  ///
  /// In en, this message translates to:
  /// **'Total slots'**
  String get totalSlots;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @perHour.
  ///
  /// In en, this message translates to:
  /// **'per hour'**
  String get perHour;

  /// No description provided for @ratePerHour.
  ///
  /// In en, this message translates to:
  /// **'₹{rate}/hr'**
  String ratePerHour(num rate);

  /// No description provided for @slotsFree.
  ///
  /// In en, this message translates to:
  /// **'{count} slots free'**
  String slotsFree(int count);

  /// No description provided for @minsWalk.
  ///
  /// In en, this message translates to:
  /// **'{count} mins walk'**
  String minsWalk(num count);

  /// No description provided for @kmAway.
  ///
  /// In en, this message translates to:
  /// **'{count} km'**
  String kmAway(num count);

  /// No description provided for @aiScore.
  ///
  /// In en, this message translates to:
  /// **'{score}% AI Score'**
  String aiScore(num score);

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @totalCapacity.
  ///
  /// In en, this message translates to:
  /// **'Total Capacity'**
  String get totalCapacity;

  /// No description provided for @hourlyRate.
  ///
  /// In en, this message translates to:
  /// **'Hourly Rate'**
  String get hourlyRate;

  /// No description provided for @reserveSpot.
  ///
  /// In en, this message translates to:
  /// **'Reserve Parking Slot'**
  String get reserveSpot;

  /// No description provided for @reserveNow.
  ///
  /// In en, this message translates to:
  /// **'Reserve Now'**
  String get reserveNow;

  /// No description provided for @booking.
  ///
  /// In en, this message translates to:
  /// **'Booking'**
  String get booking;

  /// No description provided for @reservation.
  ///
  /// In en, this message translates to:
  /// **'Reservation'**
  String get reservation;

  /// No description provided for @activeBooking.
  ///
  /// In en, this message translates to:
  /// **'Active Parking Reservation'**
  String get activeBooking;

  /// No description provided for @selectDuration.
  ///
  /// In en, this message translates to:
  /// **'Select Duration'**
  String get selectDuration;

  /// No description provided for @selectVehicle.
  ///
  /// In en, this message translates to:
  /// **'Select Vehicle'**
  String get selectVehicle;

  /// No description provided for @durationHours.
  ///
  /// In en, this message translates to:
  /// **'{count} Hours'**
  String durationHours(int count);

  /// No description provided for @startTime.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get startTime;

  /// No description provided for @endTime.
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get endTime;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalAmount;

  /// No description provided for @proceedToPay.
  ///
  /// In en, this message translates to:
  /// **'Proceed to Pay'**
  String get proceedToPay;

  /// No description provided for @bookingSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Booking successful!'**
  String get bookingSuccessful;

  /// No description provided for @bookingFailed.
  ///
  /// In en, this message translates to:
  /// **'Booking failed. Please try again.'**
  String get bookingFailed;

  /// No description provided for @reservationConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Reservation Confirmed'**
  String get reservationConfirmed;

  /// No description provided for @spotReservedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Your parking spot has been reserved successfully.'**
  String get spotReservedSuccessfully;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @payNow.
  ///
  /// In en, this message translates to:
  /// **'Pay Now'**
  String get payNow;

  /// No description provided for @payWithRazorpay.
  ///
  /// In en, this message translates to:
  /// **'Pay with Razorpay'**
  String get payWithRazorpay;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @paymentSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Payment Successful!'**
  String get paymentSuccessful;

  /// No description provided for @paymentFailed.
  ///
  /// In en, this message translates to:
  /// **'Payment failed. Please try again.'**
  String get paymentFailed;

  /// No description provided for @transaction.
  ///
  /// In en, this message translates to:
  /// **'Transaction'**
  String get transaction;

  /// No description provided for @transactionId.
  ///
  /// In en, this message translates to:
  /// **'Transaction ID'**
  String get transactionId;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @upi.
  ///
  /// In en, this message translates to:
  /// **'UPI'**
  String get upi;

  /// No description provided for @card.
  ///
  /// In en, this message translates to:
  /// **'Credit / Debit Card'**
  String get card;

  /// No description provided for @netBanking.
  ///
  /// In en, this message translates to:
  /// **'Net Banking'**
  String get netBanking;

  /// No description provided for @wallet.
  ///
  /// In en, this message translates to:
  /// **'Mobile Wallet'**
  String get wallet;

  /// No description provided for @retryPayment.
  ///
  /// In en, this message translates to:
  /// **'Retry Payment'**
  String get retryPayment;

  /// No description provided for @qrPassTitle.
  ///
  /// In en, this message translates to:
  /// **'Digital QR Pass'**
  String get qrPassTitle;

  /// No description provided for @qrPass.
  ///
  /// In en, this message translates to:
  /// **'QR Pass'**
  String get qrPass;

  /// No description provided for @showQr.
  ///
  /// In en, this message translates to:
  /// **'Show QR'**
  String get showQr;

  /// No description provided for @scanQr.
  ///
  /// In en, this message translates to:
  /// **'Scan QR'**
  String get scanQr;

  /// No description provided for @scanQrAtGate.
  ///
  /// In en, this message translates to:
  /// **'Scan this QR code at the parking gate'**
  String get scanQrAtGate;

  /// No description provided for @bookingId.
  ///
  /// In en, this message translates to:
  /// **'Booking ID'**
  String get bookingId;

  /// No description provided for @validUntil.
  ///
  /// In en, this message translates to:
  /// **'Valid Until'**
  String get validUntil;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @passActive.
  ///
  /// In en, this message translates to:
  /// **'Active Pass'**
  String get passActive;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'User Profile'**
  String get profileTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get settingsTitle;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @tamil.
  ///
  /// In en, this message translates to:
  /// **'Tamil'**
  String get tamil;

  /// No description provided for @hindi.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get hindi;

  /// No description provided for @malayalam.
  ///
  /// In en, this message translates to:
  /// **'Malayalam'**
  String get malayalam;

  /// No description provided for @kannada.
  ///
  /// In en, this message translates to:
  /// **'Kannada'**
  String get kannada;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get themeDark;

  /// No description provided for @switchToLightMode.
  ///
  /// In en, this message translates to:
  /// **'Switch to Light Mode'**
  String get switchToLightMode;

  /// No description provided for @switchToDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Switch to Dark Mode'**
  String get switchToDarkMode;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Smart Notifications'**
  String get notificationsTitle;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @myBookings.
  ///
  /// In en, this message translates to:
  /// **'My Bookings'**
  String get myBookings;

  /// No description provided for @myVehicles.
  ///
  /// In en, this message translates to:
  /// **'My Vehicles'**
  String get myVehicles;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @navigate.
  ///
  /// In en, this message translates to:
  /// **'Navigate'**
  String get navigate;

  /// No description provided for @startNavigation.
  ///
  /// In en, this message translates to:
  /// **'Start Navigation'**
  String get startNavigation;

  /// No description provided for @destination.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get destination;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @liveMap.
  ///
  /// In en, this message translates to:
  /// **'Live Map'**
  String get liveMap;

  /// No description provided for @bookingHistory.
  ///
  /// In en, this message translates to:
  /// **'Booking History'**
  String get bookingHistory;

  /// No description provided for @locationPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Location permission is required to find nearby parking.'**
  String get locationPermissionRequired;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied.'**
  String get locationPermissionDenied;

  /// No description provided for @internetConnectionRequired.
  ///
  /// In en, this message translates to:
  /// **'Internet connection required.'**
  String get internetConnectionRequired;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get somethingWentWrong;

  /// No description provided for @pleaseTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Please try again.'**
  String get pleaseTryAgain;

  /// No description provided for @adminDashboard.
  ///
  /// In en, this message translates to:
  /// **'Enterprise AI Admin Dashboard'**
  String get adminDashboard;

  /// No description provided for @platformExecutiveSummary.
  ///
  /// In en, this message translates to:
  /// **'Platform Executive Summary'**
  String get platformExecutiveSummary;

  /// No description provided for @exportReports.
  ///
  /// In en, this message translates to:
  /// **'Export Reports'**
  String get exportReports;

  /// No description provided for @exportPdfReport.
  ///
  /// In en, this message translates to:
  /// **'Export PDF Report'**
  String get exportPdfReport;

  /// No description provided for @exportCsvData.
  ///
  /// In en, this message translates to:
  /// **'Export CSV Data'**
  String get exportCsvData;

  /// No description provided for @exportExcelSheet.
  ///
  /// In en, this message translates to:
  /// **'Export Excel Sheet'**
  String get exportExcelSheet;

  /// No description provided for @exportingReport.
  ///
  /// In en, this message translates to:
  /// **'Exporting {timeframe} Report as {format}...'**
  String exportingReport(String timeframe, String format);

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @activeSensors.
  ///
  /// In en, this message translates to:
  /// **'Active Sensors'**
  String get activeSensors;

  /// No description provided for @systemHealth.
  ///
  /// In en, this message translates to:
  /// **'System Health'**
  String get systemHealth;

  /// No description provided for @occupancyRate.
  ///
  /// In en, this message translates to:
  /// **'Occupancy Rate'**
  String get occupancyRate;

  /// No description provided for @totalRevenue.
  ///
  /// In en, this message translates to:
  /// **'Total Revenue'**
  String get totalRevenue;

  /// No description provided for @recentIncidents.
  ///
  /// In en, this message translates to:
  /// **'Recent Incidents'**
  String get recentIncidents;

  /// No description provided for @noIncidentsFound.
  ///
  /// In en, this message translates to:
  /// **'No incidents reported.'**
  String get noIncidentsFound;

  /// No description provided for @paymentHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment & Transaction History'**
  String get paymentHistoryTitle;

  /// No description provided for @transactionHistory.
  ///
  /// In en, this message translates to:
  /// **'Transaction History'**
  String get transactionHistory;

  /// No description provided for @noTransactionsFound.
  ///
  /// In en, this message translates to:
  /// **'No payment transactions found.'**
  String get noTransactionsFound;

  /// No description provided for @downloadInvoice.
  ///
  /// In en, this message translates to:
  /// **'Download Invoice'**
  String get downloadInvoice;

  /// No description provided for @downloadingInvoice.
  ///
  /// In en, this message translates to:
  /// **'Downloading invoice for #{id}...'**
  String downloadingInvoice(String id);

  /// No description provided for @passNumber.
  ///
  /// In en, this message translates to:
  /// **'Pass #{id}'**
  String passNumber(String id);

  /// No description provided for @methodLabel.
  ///
  /// In en, this message translates to:
  /// **'Method: {method}'**
  String methodLabel(String method);

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date: {date}'**
  String dateLabel(String date);

  /// No description provided for @statusSuccess.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get statusSuccess;

  /// No description provided for @statusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get statusFailed;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @markAllAsRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get markAllAsRead;

  /// No description provided for @allNotificationsMarkedRead.
  ///
  /// In en, this message translates to:
  /// **'All notifications marked as read.'**
  String get allNotificationsMarkedRead;

  /// No description provided for @noNotificationsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No notifications available.'**
  String get noNotificationsAvailable;

  /// No description provided for @unableToLoadNotifications.
  ///
  /// In en, this message translates to:
  /// **'Unable to load notifications.'**
  String get unableToLoadNotifications;

  /// No description provided for @categoryAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get categoryAll;

  /// No description provided for @categoryReservation.
  ///
  /// In en, this message translates to:
  /// **'Reservation'**
  String get categoryReservation;

  /// No description provided for @categoryAi.
  ///
  /// In en, this message translates to:
  /// **'AI'**
  String get categoryAi;

  /// No description provided for @categoryAdaptive.
  ///
  /// In en, this message translates to:
  /// **'Adaptive'**
  String get categoryAdaptive;

  /// No description provided for @categoryExpiry.
  ///
  /// In en, this message translates to:
  /// **'Expiry'**
  String get categoryExpiry;

  /// No description provided for @categorySurge.
  ///
  /// In en, this message translates to:
  /// **'Surge'**
  String get categorySurge;

  /// No description provided for @aiSmartPickAvailable.
  ///
  /// In en, this message translates to:
  /// **'AI Smart Pick Available'**
  String get aiSmartPickAvailable;

  /// No description provided for @lowTrafficRouteDetected.
  ///
  /// In en, this message translates to:
  /// **'Low traffic route detected...'**
  String get lowTrafficRouteDetected;

  /// No description provided for @parkingExpiryWarning.
  ///
  /// In en, this message translates to:
  /// **'Parking Expiry Warning'**
  String get parkingExpiryWarning;

  /// No description provided for @peakSurgeAlert.
  ///
  /// In en, this message translates to:
  /// **'Peak Surge Alert'**
  String get peakSurgeAlert;

  /// No description provided for @minsAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} mins ago'**
  String minsAgo(int count);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} hours ago'**
  String hoursAgo(int count);

  /// No description provided for @lowestTraffic.
  ///
  /// In en, this message translates to:
  /// **'Lowest Traffic'**
  String get lowestTraffic;

  /// No description provided for @openNow.
  ///
  /// In en, this message translates to:
  /// **'Open Now'**
  String get openNow;

  /// No description provided for @locationServicesDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled. Please enable GPS in device settings.'**
  String get locationServicesDisabled;

  /// No description provided for @locationPermissionRequiredMsg.
  ///
  /// In en, this message translates to:
  /// **'Location permission is required to center the map on your position.'**
  String get locationPermissionRequiredMsg;

  /// No description provided for @locationPermissionPermanentDeniedMsg.
  ///
  /// In en, this message translates to:
  /// **'Location permission is permanently denied.'**
  String get locationPermissionPermanentDeniedMsg;

  /// No description provided for @aiAdaptiveRerouting.
  ///
  /// In en, this message translates to:
  /// **'AI Adaptive Re-routing'**
  String get aiAdaptiveRerouting;

  /// No description provided for @betterParkingFound.
  ///
  /// In en, this message translates to:
  /// **'Better Parking Found:'**
  String get betterParkingFound;

  /// No description provided for @priceDifference.
  ///
  /// In en, this message translates to:
  /// **'Price difference:'**
  String get priceDifference;

  /// No description provided for @acceptReroute.
  ///
  /// In en, this message translates to:
  /// **'Accept Reroute'**
  String get acceptReroute;

  /// No description provided for @decline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// No description provided for @openingGoogleMaps.
  ///
  /// In en, this message translates to:
  /// **'Opening Google Maps navigation...'**
  String get openingGoogleMaps;

  /// No description provided for @parkingLotNotFound.
  ///
  /// In en, this message translates to:
  /// **'Parking Lot Not Found'**
  String get parkingLotNotFound;

  /// No description provided for @unableToShareParking.
  ///
  /// In en, this message translates to:
  /// **'Unable to share parking link'**
  String get unableToShareParking;

  /// No description provided for @googleMapsNotOpened.
  ///
  /// In en, this message translates to:
  /// **'Google Maps could not be opened. Please make sure Google Maps is installed.'**
  String get googleMapsNotOpened;

  /// No description provided for @lowestRouteTraffic.
  ///
  /// In en, this message translates to:
  /// **'Lowest predicted route traffic'**
  String get lowestRouteTraffic;

  /// No description provided for @walkingDistanceMeters.
  ///
  /// In en, this message translates to:
  /// **'Walking distance only {meters} meters'**
  String walkingDistanceMeters(int meters);

  /// No description provided for @competitivePrice.
  ///
  /// In en, this message translates to:
  /// **'Competitive parking price'**
  String get competitivePrice;

  /// No description provided for @peakSurgePlus.
  ///
  /// In en, this message translates to:
  /// **'⚡ Peak Surge +{percent}%'**
  String peakSurgePlus(int percent);

  /// No description provided for @highlySuitableLocation.
  ///
  /// In en, this message translates to:
  /// **'Highly suitable parking location with good availability.'**
  String get highlySuitableLocation;

  /// No description provided for @stepProgress.
  ///
  /// In en, this message translates to:
  /// **'Step {step} of 5'**
  String stepProgress(int step);

  /// No description provided for @smartReservationWizard.
  ///
  /// In en, this message translates to:
  /// **'Smart Reservation Wizard'**
  String get smartReservationWizard;

  /// No description provided for @selectArrivalTime.
  ///
  /// In en, this message translates to:
  /// **'1. Select Arrival Time'**
  String get selectArrivalTime;

  /// No description provided for @selectParkingDuration.
  ///
  /// In en, this message translates to:
  /// **'2. Select Parking Duration'**
  String get selectParkingDuration;

  /// No description provided for @selectVehicleStep.
  ///
  /// In en, this message translates to:
  /// **'3. Select Vehicle'**
  String get selectVehicleStep;

  /// No description provided for @reviewBookingSummary.
  ///
  /// In en, this message translates to:
  /// **'4. Review Booking Summary'**
  String get reviewBookingSummary;

  /// No description provided for @instantEntryNow.
  ///
  /// In en, this message translates to:
  /// **'Now (Instant Entry)'**
  String get instantEntryNow;

  /// No description provided for @vehicleTypeFilter.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Type Filter'**
  String get vehicleTypeFilter;

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Reservation ID copied to clipboard!'**
  String get copiedToClipboard;

  /// No description provided for @viewFullPass.
  ///
  /// In en, this message translates to:
  /// **'View Full Pass'**
  String get viewFullPass;

  /// No description provided for @passIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Pass ID: #{id}'**
  String passIdLabel(String id);

  /// No description provided for @slotAllocatedLabel.
  ///
  /// In en, this message translates to:
  /// **'Slot Allocated: {slot}'**
  String slotAllocatedLabel(String slot);

  /// No description provided for @parkingAndReasoning.
  ///
  /// In en, this message translates to:
  /// **'PARKING & REASONING'**
  String get parkingAndReasoning;

  /// No description provided for @userAndAccount.
  ///
  /// In en, this message translates to:
  /// **'USER & ACCOUNT'**
  String get userAndAccount;

  /// No description provided for @systemAndSupport.
  ///
  /// In en, this message translates to:
  /// **'SYSTEM & SUPPORT'**
  String get systemAndSupport;

  /// No description provided for @aboutSmartPark.
  ///
  /// In en, this message translates to:
  /// **'About SmartPark AI'**
  String get aboutSmartPark;

  /// No description provided for @returnToHome.
  ///
  /// In en, this message translates to:
  /// **'Return To Home'**
  String get returnToHome;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi', 'kn', 'ml', 'ta'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
    case 'kn':
      return AppLocalizationsKn();
    case 'ml':
      return AppLocalizationsMl();
    case 'ta':
      return AppLocalizationsTa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
