import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'route_names.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/authentication/presentation/login_screen.dart';
import '../../features/authentication/presentation/register_screen.dart';
import '../../features/authentication/presentation/verify_email_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/search/presentation/search_screen.dart';
import '../../features/search/presentation/live_parking_map_screen.dart';
import '../../features/parking/presentation/parking_details_screen.dart';
import '../../features/booking/presentation/booking_screen.dart';
import '../../features/payment/presentation/payment_screen.dart';
import '../../features/payment/presentation/payment_success_screen.dart';
import '../../features/qr_pass/presentation/qr_pass_screen.dart';
import '../../features/history/presentation/history_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/profile/presentation/my_vehicles_screen.dart';
import '../../features/profile/presentation/saved_payments_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/language/presentation/language_screen.dart';
import '../../features/support/presentation/help_support_screen.dart';
import '../../features/support/presentation/about_screen.dart';
import '../../features/admin/presentation/admin_dashboard_screen.dart';

// Routes accessible to unauthenticated users
const _publicRoutes = {
  '/',
  '/onboarding',
  '/login',
  '/register',
};

// Routes only for unverified email users
const _verifyRoute = '/verify-email';

/// App Router Provider powered by Riverpod & GoRouter with Authentication Guard
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final location = state.uri.path;
      final firebaseUser = FirebaseAuth.instance.currentUser;
      final isLoggedIn = firebaseUser != null;

      // ── Public routes — allow always ──
      if (_publicRoutes.contains(location) || location == '/') {
        // If already authenticated and visiting login/register, redirect to home
        if (isLoggedIn &&
            (location == '/login' || location == '/register')) {
          final isGoogle = firebaseUser.providerData
              .any((p) => p.providerId == 'google.com');
          if (isGoogle || firebaseUser.emailVerified) {
            return '/home';
          } else {
            return '/verify-email';
          }
        }
        return null; // Allow
      }

      // ── Verify-email route ──
      if (location == _verifyRoute) {
        if (!isLoggedIn) return '/login';
        // Already verified? Redirect to home
        final isGoogle = firebaseUser.providerData
            .any((p) => p.providerId == 'google.com');
        if (isGoogle || firebaseUser.emailVerified) return '/home';
        return null; // Allow
      }

      // ── Protected routes ──
      if (!isLoggedIn) return '/login';

      final isGoogle = firebaseUser.providerData
          .any((p) => p.providerId == 'google.com');
      final isVerified = firebaseUser.emailVerified;

      if (!isGoogle && !isVerified) {
        // Email user not yet verified
        return '/verify-email';
      }

      return null; // Allow access
    },
    routes: [
      GoRoute(
        path: '/',
        name: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: RouteNames.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        name: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: RouteNames.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/verify-email',
        builder: (context, state) => const VerifyEmailScreen(),
      ),
      GoRoute(
        path: '/home',
        name: RouteNames.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/search',
        name: RouteNames.search,
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: '/live-map',
        builder: (context, state) => const LiveParkingMapScreen(),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: '/parking-details',
        builder: (context, state) =>
            const ParkingDetailsScreen(parkingId: 'spot_metro'),
      ),
      GoRoute(
        path: '/parking-details/:id',
        name: RouteNames.parkingDetails,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? 'spot_metro';
          return ParkingDetailsScreen(parkingId: id);
        },
      ),
      GoRoute(
        path: '/booking',
        name: RouteNames.booking,
        builder: (context, state) => const BookingScreen(),
      ),
      GoRoute(
        path: '/payment',
        name: RouteNames.payment,
        builder: (context, state) => const PaymentScreen(),
      ),
      GoRoute(
        path: '/payment-success',
        name: RouteNames.paymentSuccess,
        builder: (context, state) => const PaymentSuccessScreen(),
      ),
      GoRoute(
        path: '/qr-pass',
        name: RouteNames.qrPass,
        builder: (context, state) => const QrPassScreen(),
      ),
      GoRoute(
        path: '/history',
        name: RouteNames.history,
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: '/notifications',
        name: RouteNames.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: RouteNames.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/vehicles',
        name: RouteNames.vehicles,
        builder: (context, state) => const MyVehiclesScreen(),
      ),
      GoRoute(
        path: '/saved-payments',
        name: RouteNames.savedPayments,
        builder: (context, state) => const SavedPaymentsScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: RouteNames.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/language',
        name: RouteNames.language,
        builder: (context, state) => const LanguageScreen(),
      ),
      GoRoute(
        path: '/help',
        name: RouteNames.help,
        builder: (context, state) => const HelpSupportScreen(),
      ),
      GoRoute(
        path: '/about',
        name: RouteNames.about,
        builder: (context, state) => const AboutScreen(),
      ),
    ],
  );
});
