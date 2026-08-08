import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/custom_search_bar.dart';
import '../../../core/widgets/parking_card.dart';
import '../../../core/widgets/ai_recommendation_card.dart';
import '../../../core/widgets/app_navigation_drawer.dart';

import '../../../models/parking_lot_model.dart';
import '../../parking/presentation/parking_controller.dart';
import '../../parking/presentation/widgets/reservation_flow_modal.dart';
import '../../assistant/presentation/widgets/floating_ai_assistant.dart';

/// Complete Production Home Screen with Material 3 Navigation Drawer & Floating AI Assistant
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _searchQuery = '';
  String _selectedCategory = 'All';

  static const List<String> _categories = [
    'All',
    'AI Smart Pick',
    'EV Charging',
    'Covered',
    'Cheapest',
    'Nearest',
  ];

  void _openReservationFlow(ParkingLotModel spot) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ReservationFlowModal(parkingLot: spot),
    );
  }

  @override
  Widget build(BuildContext context) {
    final parkingRepo = ref.watch(parkingRepositoryProvider);

    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppNavigationDrawer(currentRoute: '/home'),
      floatingActionButton: const FloatingAIAssistant(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => ref.invalidate(parkingRepositoryProvider),
          child: CustomScrollView(
            slivers: [
              // Top Bar Header
              SliverPadding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.menu, color: AppColors.primary, size: 28),
                            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                          ),
                          const SizedBox(width: 4),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('SmartPark AI', style: AppTextStyles.headingSmall.copyWith(color: AppColors.primary)),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, size: 14, color: AppColors.textSecondary),
                                  const SizedBox(width: 2),
                                  Text('Chennai, TN', style: AppTextStyles.caption),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.map_outlined, color: AppColors.primary),
                            tooltip: 'Live Parking Map',
                            onPressed: () => context.go('/live-map'),
                          ),
                          IconButton(
                            icon: const Icon(Icons.notifications_outlined, color: AppColors.textPrimary),
                            onPressed: () => context.go('/notifications'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Search Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  child: CustomSearchBar(
                    hintText: 'Search parking by location, mall or landmark...',
                    onChanged: (val) => setState(() => _searchQuery = val),
                    onFilterTap: () => context.go('/search'),
                  ),
                ),
              ),

              // AI Recommended Parking Card Hero Section
              SliverToBoxAdapter(
                child: FutureBuilder<List<ParkingLotModel>>(
                  future: parkingRepo.getAllParkingLots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    final topSpot = snapshot.data!.first;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
                      child: AiRecommendationCard(
                        parkingName: topSpot.name,
                        reasoningText: '${topSpot.aiReasoningSummary} • ${topSpot.availableSlots} slots free',
                        timeSavedInMinutes: 12.0,
                        onReserve: () => _openReservationFlow(topSpot),
                      ),
                    );
                  },
                ),
              ),

              // Category Filters Bar
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 48,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding, vertical: 6),
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
                          backgroundColor: AppColors.background,
                          labelStyle: AppTextStyles.bodyMedium.copyWith(
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
              ),

              // Nearby Parking Facilities Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Nearby Facilities', style: AppTextStyles.headingSmall),
                      TextButton(
                        onPressed: () => context.go('/search'),
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                ),
              ),

              // Parking Lots List
              FutureBuilder<List<ParkingLotModel>>(
                future: parkingRepo.getAllParkingLots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SliverToBoxAdapter(
                      child: Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator())),
                    );
                  }

                  final allLots = snapshot.data ?? [];
                  final filtered = allLots.where((lot) {
                    final matchesQuery = _searchQuery.isEmpty ||
                        lot.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                        lot.address.toLowerCase().contains(_searchQuery.toLowerCase());

                    if (!matchesQuery) return false;

                    if (_selectedCategory == 'EV Charging') return lot.isEVChargingAvailable;
                    if (_selectedCategory == 'Covered') return lot.isCovered;
                    if (_selectedCategory == 'AI Smart Pick') return lot.aiMatchScore >= 90;
                    return true;
                  }).toList();

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final spot = filtered[index];
                        return Padding(
                          padding: const EdgeInsets.only(
                            left: AppConstants.defaultPadding,
                            right: AppConstants.defaultPadding,
                            bottom: AppConstants.defaultPadding,
                          ),
                          child: ParkingCard(
                            title: spot.name,
                            address: spot.address,
                            distanceInKm: spot.distanceInKm,
                            availableSlots: spot.availableSlots,
                            totalSlots: spot.totalSlots,
                            hourlyRate: spot.baseHourlyRate,
                            rating: spot.rating,
                            aiMatchScore: spot.aiMatchScore,
                            onTap: () => context.go('/parking-details/${spot.id}'),
                          ),
                        );
                      },
                      childCount: filtered.length,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
