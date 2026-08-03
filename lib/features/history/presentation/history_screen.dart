import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/custom_search_bar.dart';
import '../../../core/widgets/booking_card.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/custom_bottom_nav_bar.dart';

/// Booking History & Active Reservations Screen
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentNavIndex = 2; // Bookings tab in bottom nav

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
        break; // Already on History
      case 3:
        context.go('/notifications');
        break;
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
        title: 'Booking History',
        showBackButton: false,
        onBackPressed: () => context.go('/home'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
              child: CustomSearchBar(hintText: 'Search bookings by spot or ID...'),
            ),
            const SizedBox(height: 14),

            // Tab Bar
            TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primary,
              indicatorWeight: 3,
              labelStyle: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
              tabs: const [
                Tab(text: 'Upcoming'),
                Tab(text: 'Completed'),
                Tab(text: 'Cancelled'),
              ],
            ),
            const SizedBox(height: 10),

            // Tab View List Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Upcoming / Active Bookings Tab
                  ListView(
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    children: [
                      BookingCard(
                        parkingSpotName: 'Metro Cyber Park',
                        slotNumber: 'Slot A-14',
                        dateText: 'Oct 24, 2026',
                        timeRangeText: '10:00 AM - 02:00 PM',
                        status: 'Active',
                        onViewQrPass: () => context.go('/qr-pass'),
                      ),
                    ],
                  ),

                  // Completed Bookings Tab
                  ListView(
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    children: [
                      BookingCard(
                        parkingSpotName: 'Phoenix Marketcity Deck',
                        slotNumber: 'Slot B-08',
                        dateText: 'Oct 18, 2026',
                        timeRangeText: '04:00 PM - 07:00 PM',
                        status: 'Completed',
                        onViewQrPass: () => context.go('/qr-pass'),
                      ),
                      BookingCard(
                        parkingSpotName: 'Express Avenue Plaza',
                        slotNumber: 'Slot C-22',
                        dateText: 'Oct 12, 2026',
                        timeRangeText: '01:00 PM - 03:00 PM',
                        status: 'Completed',
                        onViewQrPass: () => context.go('/qr-pass'),
                      ),
                    ],
                  ),

                  // Cancelled Bookings Tab
                  ListView(
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    children: [
                      BookingCard(
                        parkingSpotName: 'Forum Mall Parking',
                        slotNumber: 'Slot D-05',
                        dateText: 'Sep 29, 2026',
                        timeRangeText: '11:00 AM - 01:00 PM',
                        status: 'Cancelled',
                        onViewQrPass: () => context.go('/qr-pass'),
                      ),
                    ],
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
