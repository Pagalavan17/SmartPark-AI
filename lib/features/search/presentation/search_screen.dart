import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/custom_search_bar.dart';
import '../../../core/widgets/parking_card.dart';

/// Search Screen with Map Interface & Bottom Sheet
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _selectedFilter = 'Nearby';
  final List<String> _filters = ['Nearby', 'Covered', 'EV Charging', '24 Hours', 'Lowest Price'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Simulated Interactive Map Canvas View
          Container(
            color: const Color(0xFFE5E3DF),
            child: Stack(
              children: [
                // Grid lines / Map aesthetic representation
                Positioned.fill(
                  child: CustomPaint(
                    painter: _MapGridPainter(),
                  ),
                ),
                // Simulated Map Pins
                const Positioned(
                  top: 220,
                  left: 120,
                  child: _MapPinWidget(title: 'Metro Garage', price: '₹50/hr', isSelected: true),
                ),
                const Positioned(
                  top: 180,
                  right: 90,
                  child: _MapPinWidget(title: 'Express Deck', price: '₹40/hr'),
                ),
                const Positioned(
                  top: 340,
                  left: 180,
                  child: _MapPinWidget(title: 'Phoenix Plaza', price: '₹60/hr'),
                ),
                // Current User Pulsing Location Marker
                Positioned(
                  top: 280,
                  left: MediaQuery.of(context).size.width / 2 - 20,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Floating Top Header (Search Bar + Filter Chips)
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  child: CustomSearchBar(
                    hintText: 'Search destination or parking space...',
                  ),
                ),
                // Filter Chips Horizontal Scroll
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
                    itemCount: _filters.length,
                    itemBuilder: (context, index) {
                      final filter = _filters[index];
                      final isSelected = filter == _selectedFilter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(filter),
                          selected: isSelected,
                          selectedColor: AppColors.primary,
                          backgroundColor: Colors.white,
                          labelStyle: AppTextStyles.bodyMedium.copyWith(
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          onSelected: (selected) {
                            if (selected) {
                              setState(() => _selectedFilter = filter);
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Floating Current Location FAB Button
          Positioned(
            right: 16,
            bottom: 260,
            child: FloatingActionButton.small(
              heroTag: 'loc_btn',
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Centered on current GPS location.')),
                );
              },
              child: const Icon(Icons.my_location),
            ),
          ),

          // Persistent Draggable Bottom Sheet with Parking List
          DraggableScrollableSheet(
            initialChildSize: 0.35,
            minChildSize: 0.15,
            maxChildSize: 0.85,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 16,
                      offset: Offset(0, -4),
                    ),
                  ],
                ),
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: AppColors.border,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('3 Spots Available', style: AppTextStyles.headingSmall),
                        Text('Sorted by Distance', style: AppTextStyles.caption),
                      ],
                    ),
                    const SizedBox(height: 14),
                    ParkingCard(
                      title: 'Metro Cyber Park',
                      address: '120 Mount Road, Guindy, Chennai',
                      rating: 4.8,
                      distanceInKm: 0.8,
                      hourlyRate: 50.0,
                      availableSlots: 24,
                      totalSlots: 100,
                      aiMatchScore: 0.96,
                      onTap: () => context.go('/parking-details/spot_metro'),
                    ),
                    ParkingCard(
                      title: 'Express Avenue Deck',
                      address: 'Club House Road, Royapettah, Chennai',
                      rating: 4.6,
                      distanceInKm: 1.5,
                      hourlyRate: 40.0,
                      availableSlots: 12,
                      totalSlots: 80,
                      aiMatchScore: 0.88,
                      onTap: () => context.go('/parking-details/spot_express'),
                    ),
                    ParkingCard(
                      title: 'Forum Mall Plaza',
                      address: '100 Feet Road, Vadapalani, Chennai',
                      rating: 4.9,
                      distanceInKm: 2.1,
                      hourlyRate: 60.0,
                      availableSlots: 8,
                      totalSlots: 120,
                      aiMatchScore: 0.92,
                      onTap: () => context.go('/parking-details/spot_forum'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Helper Painter for Map Grid Simulation
class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      color = const Color(0xFFD4D0C8)
      strokeWidth = 1.5;

    for (double i = 0; i < size.width; i += 60) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 60) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Simulated Map Pin Widget
class _MapPinWidget extends StatelessWidget {
  final String title;
  final String price;
  final bool isSelected;

  const _MapPinWidget({
    required this.title,
    required this.price,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3))],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_parking,
            size: 16,
            color: isSelected ? Colors.white : AppColors.primary,
          ),
          const SizedBox(width: 4),
          Text(
            price,
            style: AppTextStyles.caption.copyWith(
              color: isSelected ? Colors.white : AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
