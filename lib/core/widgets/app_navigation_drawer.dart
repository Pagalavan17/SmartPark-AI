import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../../features/authentication/presentation/auth_controller.dart';

/// Production Navigation Drawer with real authenticated user info
class AppNavigationDrawer extends ConsumerWidget {
  final String currentRoute;

  const AppNavigationDrawer({
    super.key,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final user = authState.user;
    final firebaseUser = ref.read(authRepositoryProvider).currentUser;

    final displayName = user?.name ??
        firebaseUser?.displayName ??
        'SmartPark User';
    final displayEmail = user?.email ?? firebaseUser?.email ?? '';
    final avatarUrl = user?.avatarUrl ?? firebaseUser?.photoURL ?? '';

    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // ─── Drawer Header ───
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            accountName: Text(
              displayName,
              style: AppTextStyles.bodyLarge.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            accountEmail: Text(
              displayEmail,
              style: AppTextStyles.caption.copyWith(color: Colors.white70),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage:
                  avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
              child: avatarUrl.isEmpty
                  ? const Icon(Icons.person, size: 40, color: AppColors.primary)
                  : null,
            ),
          ),

          // SECTION 1: DASHBOARD
          _buildSectionHeader('DASHBOARD'),
          _buildDrawerItem(
            context: context,
            icon: Icons.home_outlined,
            selectedIcon: Icons.home,
            title: 'Home',
            route: '/home',
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.dashboard_outlined,
            selectedIcon: Icons.dashboard,
            title: 'AI Admin Dashboard',
            route: '/admin',
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.map_outlined,
            selectedIcon: Icons.map,
            title: 'Live Parking Map',
            route: '/live-map',
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.search_outlined,
            selectedIcon: Icons.search,
            title: 'Search Parking',
            route: '/search',
          ),
          const Divider(),

          // SECTION 2: PARKING & BOOKING
          _buildSectionHeader('PARKING & REASONING'),
          _buildDrawerItem(
            context: context,
            icon: Icons.local_parking_outlined,
            selectedIcon: Icons.local_parking,
            title: 'Parking Details',
            route: '/parking-details',
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.confirmation_number_outlined,
            selectedIcon: Icons.confirmation_number,
            title: 'My Reservations',
            route: '/booking',
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.qr_code_2_outlined,
            selectedIcon: Icons.qr_code_2,
            title: 'Digital QR Pass',
            route: '/qr-pass',
          ),
          const Divider(),

          // SECTION 3: USER & ACCOUNT
          _buildSectionHeader('USER & ACCOUNT'),
          _buildDrawerItem(
            context: context,
            icon: Icons.person_outline,
            selectedIcon: Icons.person,
            title: 'My Profile',
            route: '/profile',
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.directions_car_outlined,
            selectedIcon: Icons.directions_car,
            title: 'My Vehicles',
            route: '/vehicles',
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.history_outlined,
            selectedIcon: Icons.history,
            title: 'Payment History',
            route: '/history',
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.notifications_outlined,
            selectedIcon: Icons.notifications,
            title: 'Notification Center',
            route: '/notifications',
          ),
          const Divider(),

          // SECTION 4: SYSTEM & SUPPORT
          _buildSectionHeader('SYSTEM & SUPPORT'),
          _buildDrawerItem(
            context: context,
            icon: Icons.settings_outlined,
            selectedIcon: Icons.settings,
            title: 'Settings',
            route: '/settings',
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.language_outlined,
            selectedIcon: Icons.language,
            title: 'Language',
            route: '/language',
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.help_outline,
            selectedIcon: Icons.help,
            title: 'Help & Support',
            route: '/help',
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.info_outline,
            selectedIcon: Icons.info,
            title: 'About SmartPark AI',
            route: '/about',
          ),
          const Divider(),

          // ─── Logout ───
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.error),
            title: Text(
              'Logout',
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.error, fontWeight: FontWeight.w600),
            ),
            onTap: () async {
              Navigator.pop(context);
              await ref.read(authControllerProvider.notifier).logout();
              if (context.mounted) context.go('/login');
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 12, bottom: 4),
      child: Text(
        title,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required IconData selectedIcon,
    required String title,
    required String route,
  }) {
    final isSelected = currentRoute == route;

    return ListTile(
      leading: Icon(
        isSelected ? selectedIcon : icon,
        color: isSelected ? AppColors.primary : AppColors.textSecondary,
      ),
      title: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(
          color: isSelected ? AppColors.primary : AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedTileColor: AppColors.primary.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onTap: () {
        Navigator.pop(context); // Close Drawer
        if (!isSelected) {
          context.go(route);
        }
      },
    );
  }
}
