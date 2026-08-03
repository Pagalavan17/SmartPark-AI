import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/custom_search_bar.dart';
import '../../../core/widgets/ai_recommendation_card.dart';
import '../../../core/widgets/traffic_card.dart';
import '../../../core/widgets/parking_card.dart';
import '../../../core/widgets/custom_bottom_nav_bar.dart';

/// Home Screen Component for SmartPark AI
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;

  void _onNavTapped(int index) {
    setState(() => _currentNavIndex = index);
    switch (index) {
      case 0:
        break; // Already on Home
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
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section with User Avatar & Notifications
              Padding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      child: const Icon(Icons.person, color: AppColors.primary, size: 28),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Hello, Alex 👋', style: AppTextStyles.headingSmall),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 14, color: AppColors.secondary),
                              const SizedBox(width: 4),
                              Text(
                                'T. Nagar, Chennai',
                                style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Badge(
                        label: Text('2'),
                        child: Icon(Icons.notifications_outlined, size: 26),
                      ),
                      onPressed: () => context.go('/notifications'),
                    ),
                  ],
                ),
              ),

              // Search Bar
              Padding(
                padding: const EdgeInsets.horizontal(AppConstants.defaultPadding),
                child: CustomSearchBar(
                  hintText: 'Search parking by location or venue...',
                  onFilterTap: () => context.go('/search'),
                ),
              ),
              const SizedBox(height: 20),

              // Quick Actions Grid
              Padding(
                padding: const EdgeInsets.horizontal(AppConstants.defaultPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildQuickAction(
                      icon: Icons.local_parking,
                      label: 'Find Spot',
                      color: AppColors.primary,
                      onTap: () => context.go('/search'),
                    ),
                    _buildQuickAction(
                      icon: Icons.confirmation_number_outlined,
                      label: 'Bookings',
                      color: AppColors.secondary,
                      onTap: () => context.go('/history'),
                    ),
                    _buildQuickAction(
                      icon: Icons.payment_outlined,
                      label: 'Payments',
                      color: const Color(0xFF00E676),
                      onTap: () => context.go('/history'),
                    ),
                    _buildQuickAction(
                      icon: Icons.bookmark_border,
                      label: 'Saved',
                      color: Colors.amber,
                      onTap: () => context.go('/search'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // AI Smart Recommendation Card
              Padding(
                padding: const EdgeInsets.horizontal(AppConstants.defaultPadding),
                child: AiRecommendationCard(
                  parkingName: 'Phoenix Marketcity Garage',
                  reasoningText: 'Recommended because traffic is low & EV spot is open.',
                  timeSavedInMinutes: 12.0,
                  onReserve: () => context.go('/parking-details/spot_phoenix'),
                ),
              ),
              const SizedBox(height: 20),

              // Traffic Prediction Section
              Padding(
                padding: const EdgeInsets.horizontal(AppConstants.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Traffic Forecast', style: AppTextStyles.headingSmall),
                    const SizedBox(height: 10),
                    const TrafficCard(
                      routeName: 'GST Road to Guindy Hub',
                      statusText: 'Moderate Traffic (35% Congestion)',
                      delayInMins: 4.0,
                      congestionLevel: 0.35,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Nearby Parking Header
              Padding(
                padding: const EdgeInsets.horizontal(AppConstants.defaultPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Nearby Parking', style: AppTextStyles.headingSmall),
                    TextButton(
                      onPressed: () => context.go('/search'),
                      child: Text('View All', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Horizontal Scrollable Parking Cards
              SizedBox(
                height: 190,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
                  children: [
                    _buildHorizontalParkingCard(
                      name: 'Metro Cyber Park',
                      distance: '0.8 km',
                      price: '₹50/hr',
                      rating: 4.8,
                      slots: '24 slots left',
                      onTap: () => context.go('/parking-details/spot_metro'),
                    ),
                    const SizedBox(width: 14),
                    _buildHorizontalParkingCard(
                      name: 'Express Avenue Deck',
                      distance: '1.5 km',
                      price: '₹40/hr',
                      rating: 4.6,
                      slots: '12 slots left',
                      onTap: () => context.go('/parking-details/spot_express'),
                    ),
                    const SizedBox(width: 14),
                    _buildHorizontalParkingCard(
                      name: 'Forum Mall Plaza',
                      distance: '2.1 km',
                      price: '₹60/hr',
                      rating: 4.9,
                      slots: '8 slots left',
                      onTap: () => context.go('/parking-details/spot_forum'),
                    ),
                  ],
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

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildHorizontalParkingCard({
    required String name,
    required String distance,
    required String price,
    required double rating,
    required String slots,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 10, offset: Offset(0, 4))],
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(price, style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
              ),
              Row(
                children: [
                  const Icon(Icons.star, size: 14, color: Colors.amber),
                  const SizedBox(width: 2),
                  Text(rating.toString(), style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(name, style: AppTextStyles.headingSmall.copyWith(fontSize: 15), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text(distance, style: AppTextStyles.bodySmall),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(slots, style: AppTextStyles.caption.copyWith(color: AppColors.success, fontWeight: FontWeight.w600)),
              InkWell(
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                  child: const Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
