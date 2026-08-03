import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/notification_card.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/custom_bottom_nav_bar.dart';

/// Notification Center Screen
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedCategory = 'All';
  int _currentNavIndex = 3;

  final List<String> _categories = ['All', 'Bookings', 'Payments', 'Traffic', 'AI'];

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
        break; // Already on Notifications
      case 4:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Smart Notifications',
        showBackButton: false,
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All notifications marked as read.')),
              );
            },
            child: Text(
              'Mark All Read',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Category Filter Chips
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = cat == _selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      selectedColor: AppColors.primary,
                      backgroundColor: Colors.white,
                      labelStyle: AppTextStyles.bodySmall.copyWith(
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (selected) {
                        if (selected) setState(() => _selectedCategory = cat);
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 14),

            // Notification Feed List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                children: [
                  NotificationCard(
                    title: 'Booking Confirmed 🎉',
                    body: 'Your slot A-14 at Metro Cyber Park has been reserved for today.',
                    timeAgo: '10 mins ago',
                    isRead: false,
                    onTap: () => context.go('/qr-pass'),
                  ),
                  NotificationCard(
                    title: 'Payment Successful 💳',
                    body: 'Received ₹213.00 for Booking #SP-982341 via Google Pay.',
                    timeAgo: '12 mins ago',
                    isRead: false,
                    onTap: () => context.go('/history'),
                  ),
                  NotificationCard(
                    title: 'AI Parking Recommendation 🤖',
                    body: 'Phoenix Marketcity is currently 85% free with 12 mins saved drive.',
                    timeAgo: '1 hour ago',
                    isRead: true,
                    onTap: () => context.go('/home'),
                  ),
                  NotificationCard(
                    title: 'Traffic Congestion Alert 🚦',
                    body: 'Moderate congestion detected on GST Road. Leave 5 mins earlier.',
                    timeAgo: '2 hours ago',
                    isRead: true,
                    onTap: () => context.go('/home'),
                  ),
                  NotificationCard(
                    title: 'Reservation Reminder ⏰',
                    body: 'Your parking slot reservation begins in 30 minutes.',
                    timeAgo: 'Yesterday',
                    isRead: true,
                    onTap: () => context.go('/history'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: _onNavTapped,
      ),
    );
  }
}
