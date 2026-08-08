import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/custom_bottom_nav_bar.dart';
import '../../authentication/presentation/auth_controller.dart';

/// User Profile Management Screen with real Firebase/Firestore data
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  int _currentNavIndex = 4; // Profile tab index

  @override
  void initState() {
    super.initState();
    // Load latest user profile from Firestore
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authControllerProvider.notifier).loadCurrentUserProfile();
    });
  }

  void _onNavTapped(int index) {
    setState(() => _currentNavIndex = index);
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/search');
        break;
      case 2:
        context.go('/history');
        break;
      case 3:
        context.go('/notifications');
        break;
      case 4:
        break; // Already on Profile
    }
  }

  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await ref.read(authControllerProvider.notifier).logout();
      if (mounted) context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final user = authState.user;
    final firebaseUser = ref.read(authRepositoryProvider).currentUser;

    final displayName = user?.name ?? firebaseUser?.displayName ?? 'SmartPark User';
    final displayEmail = user?.email ?? firebaseUser?.email ?? '';
    final displayPhone = user?.phoneNumber ?? '';
    final avatarUrl = user?.avatarUrl ?? firebaseUser?.photoURL ?? '';
    final rewardPoints = user?.rewardPoints ?? 0;
    final walletBalance = user?.walletBalance ?? 0.0;
    final isGoogleUser = user?.isGoogleUser ?? false;
    final isVerified = user?.isVerified ?? firebaseUser?.emailVerified ?? false;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'User Profile',
        showBackButton: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppColors.textPrimary),
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.largePadding),
          child: Column(
            children: [
              // Profile Header Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppConstants.cardBorderRadius),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 44,
                            backgroundColor:
                                AppColors.primary.withValues(alpha: 0.1),
                            backgroundImage: avatarUrl.isNotEmpty
                                ? NetworkImage(avatarUrl)
                                : null,
                            child: avatarUrl.isEmpty
                                ? const Icon(Icons.person,
                                    size: 54, color: AppColors.primary)
                                : null,
                          ),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.edit,
                                size: 14, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(displayName, style: AppTextStyles.headingMedium),
                      const SizedBox(height: 4),
                      Text(
                        displayEmail +
                            (displayPhone.isNotEmpty
                                ? ' • $displayPhone'
                                : ''),
                        style: AppTextStyles.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),

                      // Verification badge
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (isGoogleUser)
                            _buildBadge(
                              icon: Icons.g_mobiledata_rounded,
                              label: 'Google',
                              color: Colors.blue,
                            )
                          else
                            _buildBadge(
                              icon: isVerified
                                  ? Icons.verified
                                  : Icons.email_outlined,
                              label:
                                  isVerified ? 'Verified' : 'Unverified',
                              color:
                                  isVerified ? AppColors.success : AppColors.warning,
                            ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Stats Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildStatBadge(
                            icon: Icons.stars,
                            label: '$rewardPoints pts',
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 10),
                          _buildStatBadge(
                            icon: Icons.account_balance_wallet,
                            label: '₹${walletBalance.toStringAsFixed(0)}',
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Menu Options
              _buildMenuTile(
                icon: Icons.directions_car_outlined,
                title: 'My Vehicles',
                subtitle: 'Manage registered vehicles & license plates',
                onTap: () => context.go('/vehicles'),
              ),
              _buildMenuTile(
                icon: Icons.payment_outlined,
                title: 'Saved Payment Methods',
                subtitle: 'UPI IDs, Cards & Wallets',
                onTap: () => context.go('/saved-payments'),
              ),
              _buildMenuTile(
                icon: Icons.history,
                title: 'Booking History',
                subtitle: 'Past reservations & receipts',
                onTap: () => context.go('/history'),
              ),
              _buildMenuTile(
                icon: Icons.language_outlined,
                title: 'App Language',
                subtitle: 'English, Tamil, Hindi, Malayalam, Kannada',
                onTap: () => context.go('/language'),
              ),
              _buildMenuTile(
                icon: Icons.settings_outlined,
                title: 'Settings',
                subtitle: 'Notifications, Security & Theme',
                onTap: () => context.go('/settings'),
              ),
              const SizedBox(height: 8),

              // Logout button
              Card(
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  onTap: _handleLogout,
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFFFEBEE),
                    child: Icon(Icons.logout, color: AppColors.error),
                  ),
                  title: Text(
                    'Logout',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.error,
                    ),
                  ),
                  subtitle: Text('Sign out of your account',
                      style: AppTextStyles.bodySmall),
                  trailing: const Icon(Icons.arrow_forward_ios,
                      size: 14, color: AppColors.textLight),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: _onNavTapped,
      ),
    );
  }

  Widget _buildBadge({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBadge({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(title,
            style: AppTextStyles.bodyLarge
                .copyWith(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: AppTextStyles.bodySmall),
        trailing: const Icon(Icons.arrow_forward_ios,
            size: 14, color: AppColors.textLight),
      ),
    );
  }
}
