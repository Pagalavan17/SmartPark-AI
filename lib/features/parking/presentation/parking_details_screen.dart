import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/secondary_button.dart';
import '../../../core/widgets/ai_recommendation_card.dart';
import '../../../core/widgets/traffic_card.dart';

/// Detailed view of selected parking spot with amenities, AI insights, and reviews
class ParkingDetailsScreen extends StatelessWidget {
  final String parkingId;

  const ParkingDetailsScreen({
    super.key,
    required this.parkingId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Hero Banner & App Bar
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 18),
                onPressed: () => context.pop(),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppColors.primary,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(Icons.local_parking_rounded, size: 90, color: Colors.white24),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text('4.8 (124 reviews)', style: AppTextStyles.caption.copyWith(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Detailed Info Content Body
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.largePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name & Hourly Rate
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Metro Cyber Park Garage', style: AppTextStyles.headingLarge.copyWith(fontSize: 24)),
                            const SizedBox(height: 4),
                            Text('120 Mount Road, Guindy, Chennai', style: AppTextStyles.bodyMedium),
                          ],
                        ),
                      ),
                      Text('₹50/hr', style: AppTextStyles.headingLarge.copyWith(color: AppColors.primary)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Distance & Slots Availability Pill Bar
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem(Icons.near_me, '0.8 km', 'Distance'),
                        const SizedBox(height: 24, child: VerticalDivider()),
                        _buildStatItem(Icons.check_circle, '24 / 100', 'Slots Left'),
                        const SizedBox(height: 24, child: VerticalDivider()),
                        _buildStatItem(Icons.timer, '4 mins', 'Est. Drive'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Amenities Section
                  Text('Amenities & Facility Features', style: AppTextStyles.headingSmall),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: const [
                      _AmenityChip(icon: Icons.videocam, label: 'CCTV Monitored'),
                      _AmenityChip(icon: Icons.shield, label: '24/7 Security'),
                      _AmenityChip(icon: Icons.ev_station, label: 'EV Charging'),
                      _AmenityChip(icon: Icons.roofing, label: 'Covered Parking'),
                      _AmenityChip(icon: Icons.wc, label: 'Clean Washrooms'),
                      _AmenityChip(icon: Icons.accessible, label: 'Disabled Access'),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // AI Recommendation Section
                  Text('AI Smart Match Insights', style: AppTextStyles.headingSmall),
                  const SizedBox(height: 10),
                  AiRecommendationCard(
                    parkingName: 'Highest Recommended Spot',
                    reasoningText: 'AI predicts low traffic delay & 96% chance of instant slot arrival.',
                    timeSavedInMinutes: 15.0,
                    onReserve: () => context.go('/booking'),
                  ),
                  const SizedBox(height: 24),

                  // Traffic Prediction Section
                  Text('Real-Time Route Forecast', style: AppTextStyles.headingSmall),
                  const SizedBox(height: 10),
                  const TrafficCard(
                    routeName: 'Route via Mount Road Flyover',
                    statusText: 'Smooth Flow (15% Congestion)',
                    delayInMins: 0.0,
                    congestionLevel: 0.15,
                  ),
                  const SizedBox(height: 24),

                  // User Reviews Briefing
                  Text('Customer Feedback', style: AppTextStyles.headingSmall),
                  const SizedBox(height: 10),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(radius: 16, child: Icon(Icons.person, size: 18)),
                              const SizedBox(width: 10),
                              Text('Ramesh Kumar', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                              const Spacer(),
                              const Icon(Icons.star, color: Colors.amber, size: 16),
                              Text('5.0', style: AppTextStyles.bodyMedium),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '"Very clean, well-lit parking deck with quick QR scanner entry. Highly recommended!"',
                            style: AppTextStyles.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 100), // Spacing for bottom floating bar
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom Sticky Action Bar (Navigate + Book Now)
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 16, offset: Offset(0, -4))],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: SecondaryButton(
                  text: 'Navigate',
                  icon: Icons.navigation_outlined,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Starting turn-by-turn navigation.')),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: PrimaryButton(
                  text: 'Book Slot Now',
                  onPressed: () => context.go('/booking'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}

class _AmenityChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _AmenityChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}
