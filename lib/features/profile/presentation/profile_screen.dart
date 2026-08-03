import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/custom_bottom_nav_bar.dart';

/// User Profile Management Screen
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentNavIndex = 4; // Profile tab index

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

  @override
  Widget build(BuildContext context) {
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
                  borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
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
                            backgroundColor: AppColors.primary.withOpacity(0.1),
                            child: const Icon(Icons.person, size: 54, color: AppColors.primary),
                          ),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.edit, size: 14, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text('Alex Morgan', style: AppTextStyles.headingMedium),
                      const SizedBox(height: 4),
                      Text('alex.morgan@smartpark.ai • +91 9876543210', style: AppTextStyles.bodyMedium),
                      const SizedBox(height: 14),

                      // Badges Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.directions_car, size: 16, color: AppColors.primary),
                                const SizedBox(width: 6),
                                Text('2 Vehicles', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.stars, size: 16, color: Colors.amber),
                                const SizedBox(width: 6),
                                Text('Gold SmartPass', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, color: Colors.amber[800])),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Menu Options List
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
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(title, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: AppTextStyles.bodySmall),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textLight),
      ),
    );
  }
}
