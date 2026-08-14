import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/widgets/custom_search_bar.dart';
import '../../../core/widgets/parking_card.dart';
import '../../../core/widgets/ai_recommendation_card.dart';
import '../../../core/widgets/app_navigation_drawer.dart';
import '../../../providers/app_state_providers.dart';

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
  String _selectedCategoryKey = 'all';

  void _openReservationFlow(ParkingLotModel spot) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ReservationFlowModal(parkingLot: spot),
    );
  }

  String _getCategoryLabel(BuildContext context, String key) {
    final l10n = context.l10n;
    switch (key) {
      case 'all':
        return l10n.all;
      case 'aiSmartPick':
        return l10n.aiSmartPick;
      case 'evCharging':
        return l10n.evCharging;
      case 'covered':
        return l10n.covered;
      case 'cheapest':
        return l10n.cheapest;
      case 'nearest':
        return l10n.nearest;
      default:
        return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    final lotsAsync = ref.watch(parkingLotsProvider);
    final isDarkMode = ref.watch(isDarkModeProvider);
    final l10n = context.l10n;
    final theme = Theme.of(context);

    const categories = [
      'all',
      'aiSmartPick',
      'evCharging',
      'covered',
      'cheapest',
      'nearest',
    ];

    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppNavigationDrawer(currentRoute: '/home'),
      floatingActionButton: const FloatingAIAssistant(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => ref.invalidate(parkingLotsProvider),
          child: CustomScrollView(
            slivers: [
              // Top Bar Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.menu, color: AppColors.primary, size: 28),
                              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.appName,
                                    style: AppTextStyles.headingSmall.copyWith(color: AppColors.primary),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.location_on, size: 14, color: theme.colorScheme.onSurfaceVariant),
                                      const SizedBox(width: 2),
                                      Expanded(
                                        child: Text(
                                          'Chennai, TN',
                                          style: AppTextStyles.caption.copyWith(color: theme.colorScheme.onSurfaceVariant),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              isDarkMode ? Icons.wb_sunny_rounded : Icons.nightlight_round,
                              color: isDarkMode ? Colors.amber : AppColors.primary,
                            ),
                            tooltip: isDarkMode ? l10n.switchToLightMode : l10n.switchToDarkMode,
                            onPressed: () {
                              ref.read(isDarkModeProvider.notifier).toggleTheme();
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.map_outlined, color: AppColors.primary),
                            tooltip: l10n.liveParkingMap,
                            onPressed: () => context.go('/live-map'),
                          ),
                          IconButton(
                            icon: Icon(Icons.notifications_outlined, color: theme.colorScheme.onSurface),
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
                    hintText: l10n.searchPlaceholder,
                    onChanged: (val) => setState(() => _searchQuery = val),
                    onFilterTap: () => context.go('/search'),
                  ),
                ),
              ),

              // AI Recommended Parking Card Hero Section
              SliverToBoxAdapter(
                child: lotsAsync.when(
                  loading: () => const SizedBox.shrink(),
                  error: (e, stack) {
                    debugPrint('HOME PARKING ERROR: $e');
                    debugPrintStack(stackTrace: stack);
                    return const SizedBox.shrink();
                  },
                  data: (lots) {
                    if (lots.isEmpty) return const SizedBox.shrink();
                    final topSpot = lots.reduce(
                      (a, b) => a.aiMatchScore >= b.aiMatchScore ? a : b,
                    );
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.defaultPadding),
                      child: AiRecommendationCard(
                        parkingName: topSpot.name,
                        reasoningText:
                            '${topSpot.aiReasoningSummary} • ${l10n.slotsFree(topSpot.availableSlots)}',
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
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final catKey = categories[index];
                      final catLabel = _getCategoryLabel(context, catKey);
                      final isSelected = catKey == _selectedCategoryKey;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(catLabel),
                          selected: isSelected,
                          selectedColor: AppColors.primary,
                          backgroundColor: theme.colorScheme.surfaceContainer,
                          labelStyle: AppTextStyles.bodyMedium.copyWith(
                            color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          onSelected: (selected) {
                            if (selected) setState(() => _selectedCategoryKey = catKey);
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
                      Expanded(
                        child: Text(
                          l10n.nearbyFacilities,
                          style: AppTextStyles.headingSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.go('/search'),
                        child: Text(l10n.viewAll),
                      ),
                    ],
                  ),
                ),
              ),

              // Parking Lots List
              lotsAsync.when(
                loading: () => const SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
                error: (error, _) => SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.cloud_off_outlined,
                            size: 56, color: AppColors.textLight),
                        const SizedBox(height: 16),
                        Text(
                          l10n.unableToLoadParking,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        TextButton.icon(
                          onPressed: () => ref.invalidate(parkingLotsProvider),
                          icon: const Icon(Icons.refresh),
                          label: Text(l10n.retry),
                        ),
                      ],
                    ),
                  ),
                ),
                data: (allLots) {
                  final filtered = allLots.where((lot) {
                    final matchesQuery = _searchQuery.isEmpty ||
                        lot.name
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase()) ||
                        lot.address
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase());

                    if (!matchesQuery) return false;

                    if (_selectedCategoryKey == 'evCharging') {
                      return lot.isEVChargingAvailable;
                    }
                    if (_selectedCategoryKey == 'covered') {
                      return lot.isCovered;
                    }
                    if (_selectedCategoryKey == 'aiSmartPick') {
                      return lot.aiMatchScore >= 90;
                    }
                    return true;
                  }).toList();

                  if (filtered.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Center(
                          child: Text(
                            l10n.noParkingAvailable,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  }

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
                            onTap: () =>
                                context.go('/parking-details/${spot.id}'),
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
