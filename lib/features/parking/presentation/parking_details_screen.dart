import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/extensions/l10n_ai_helper.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/secondary_button.dart';
import '../../../core/widgets/app_navigation_drawer.dart';

import '../../../models/parking_lot_model.dart';
import '../../../models/prediction_model.dart';
import '../../../models/digital_twin_model.dart';
import '../../../models/parking_review_model.dart';

import '../../../services/sensor/sensor_providers.dart';
import 'parking_controller.dart';
import 'widgets/reservation_flow_modal.dart';

/// Complete Production-Quality Parking Details Screen consuming master AIDecisionEngine & Digital Twin Stream
class ParkingDetailsScreen extends ConsumerStatefulWidget {
  final String parkingId;

  const ParkingDetailsScreen({
    super.key,
    required this.parkingId,
  });

  @override
  ConsumerState<ParkingDetailsScreen> createState() => _ParkingDetailsScreenState();
}

class _ParkingDetailsScreenState extends ConsumerState<ParkingDetailsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final PageController _imagePageController = PageController();
  int _currentImageIndex = 0;
  bool _isNavigating = false;

  @override
  void dispose() {
    _imagePageController.dispose();
    super.dispose();
  }

  void _openReservationFlow(ParkingLotModel spot) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ReservationFlowModal(parkingLot: spot),
    );
  }

  Future<void> _shareParkingDetails(ParkingLotModel spot) async {
    final mapsUrl =
        'https://www.google.com/maps/search/?api=1&query=${spot.latitude},${spot.longitude}';
    final shareText = '''
🚗 SmartPark AI

${spot.name}
📍 ${spot.address}

💰 ₹${spot.baseHourlyRate.toInt()}/hr
🅿️ ${spot.availableSlots}/${spot.totalSlots} slots available
⭐ ${spot.rating} rating

Navigate to parking:
$mapsUrl
'''.trim();

    try {
      await Share.share(
        shareText,
        subject: spot.name,
      );
    } catch (e) {
      debugPrint('SHARE ERROR: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to share parking link'),
          ),
        );
      }
    }
  }

  Future<void> _navigateToParking(ParkingLotModel spot) async {
    if (_isNavigating) return;

    // 1. Validate coordinates
    if (spot.latitude < -90.0 ||
        spot.latitude > 90.0 ||
        spot.longitude < -180.0 ||
        spot.longitude > 180.0 ||
        (spot.latitude == 0.0 && spot.longitude == 0.0)) {
      debugPrint('[Navigation] Invalid destination coordinates: lat=${spot.latitude}, lng=${spot.longitude}');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Parking location is unavailable.')),
        );
      }
      return;
    }

    setState(() {
      _isNavigating = true;
    });

    final Uri navigationUri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '&destination=${spot.latitude},${spot.longitude}'
      '&travelmode=driving',
    );

    final Uri geoUri = Uri.parse(
      'geo:${spot.latitude},${spot.longitude}?q=${spot.latitude},${spot.longitude}(${Uri.encodeComponent(spot.name)})',
    );

    debugPrint('[Navigation] Destination coordinates: lat=${spot.latitude}, lng=${spot.longitude}');
    debugPrint('[Navigation] Generated navigation URL: $navigationUri');

    try {
      bool launched = false;
      if (await canLaunchUrl(navigationUri)) {
        launched = await launchUrl(
          navigationUri,
          mode: LaunchMode.externalApplication,
        );
        debugPrint('[Navigation] launchUrl http result: $launched');
      }

      if (!launched && await canLaunchUrl(geoUri)) {
        launched = await launchUrl(
          geoUri,
          mode: LaunchMode.externalApplication,
        );
        debugPrint('[Navigation] launchUrl geo result: $launched');
      }

      if (!launched) {
        launched = await launchUrl(
          navigationUri,
          mode: LaunchMode.externalNonBrowserApplication,
        );
        debugPrint('[Navigation] launchUrl externalNonBrowser result: $launched');
      }

      if (!launched) {
        debugPrint('[Navigation] Failed to launch navigation URL: $navigationUri');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Google Maps could not be opened. Please make sure Google Maps is installed.'),
            ),
          );
        }
      }
    } catch (e, stackTrace) {
      debugPrint('[Navigation] ERROR launching navigation: $e');
      debugPrintStack(stackTrace: stackTrace);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Google Maps could not be opened. Please make sure Google Maps is installed.'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isNavigating = false;
        });
      }
    }
  }

  void _showAdaptiveRerouteDialog(ParkingLotModel spot) {
    final l10n = context.l10n;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.auto_awesome, color: AppColors.primary, size: 22),
            const SizedBox(width: 8),
            Text(l10n.aiAdaptiveRerouting, style: AppTextStyles.headingSmall.copyWith(fontSize: 16)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${spot.name} (${l10n.slotsFree(0)}).',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.betterParkingFound, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Phoenix Marketcity Hub (0.4 km)', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
                  Text('${l10n.priceDifference} ₹0/hr • ${l10n.slotsFree(35)}', style: AppTextStyles.caption),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.decline),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.go('/parking-details/spot_phoenix');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(l10n.acceptReroute),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final parkingAsync = ref.watch(parkingDetailsProvider(widget.parkingId));
    final predictionAsync = ref.watch(predictionProvider(widget.parkingId));
    final reviewsAsync = ref.watch(parkingReviewsProvider(widget.parkingId));
    final digitalTwinStreamAsync = ref.watch(digitalTwinStreamProvider(widget.parkingId));
    final aiEngine = ref.watch(aiDecisionEngineProvider);

    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppNavigationDrawer(currentRoute: '/parking-details'),
      body: parkingAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error loading parking details: $err')),
        data: (spot) {
          if (spot == null) {
            return const Center(child: Text('Parking Lot Not Found'));
          }

          final bool isSurge = spot.isPeakHour || spot.congestionLevel > 0.6;

          return FutureBuilder<List<dynamic>>(
            future: Future.wait([
              aiEngine.getRecommendationExplanation(spot),
              aiEngine.getDynamicPricingRate(spot),
            ]),
            builder: (context, snapshot) {
              final l10n = context.l10n;
              final aiBullets = (snapshot.data?[0] as List<String>?)?.map((b) => context.localizeAiReasoning(b)).toList() ?? [
                l10n.lowestRouteTraffic,
                l10n.walkingDistanceMeters((spot.distanceInKm * 1000).toInt()),
                l10n.competitivePrice,
              ];
              final double dynamicRate = (snapshot.data?[1] as double?) ?? spot.baseHourlyRate;

              return CustomScrollView(
                slivers: [
                  // Large Parking Image Carousel Header with Hero Animation
                  SliverAppBar(
                    expandedHeight: 250,
                    pinned: true,
                    leading: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 18),
                          onPressed: () {
                            if (Navigator.of(context).canPop()) {
                              Navigator.of(context).pop();
                            } else if (context.canPop()) {
                              context.pop();
                            } else {
                              context.go('/home');
                            }
                          },
                        ),
                      ),
                    ),
                    actions: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: const Icon(Icons.menu, color: AppColors.primary, size: 22),
                          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: const Icon(Icons.share_outlined, color: AppColors.primary, size: 20),
                          onPressed: () => _shareParkingDetails(spot),
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      background: Stack(
                        children: [
                          // Carousel View
                          PageView.builder(
                            controller: _imagePageController,
                            onPageChanged: (index) => setState(() => _currentImageIndex = index),
                            itemCount: spot.imageUrls.isNotEmpty ? spot.imageUrls.length : 1,
                            itemBuilder: (context, index) {
                              final imgUrl = spot.imageUrls.isNotEmpty
                                  ? spot.imageUrls[index]
                                  : 'https://images.unsplash.com/photo-1506521781263-d8422e82f27a?auto=format&fit=crop&w=800&q=80';
                              return Hero(
                                tag: 'parking_img_${spot.id}_$index',
                                child: Image.network(
                                  imgUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    color: AppColors.primary,
                                    child: const Center(
                                      child: Icon(Icons.local_parking, size: 80, color: Colors.white30),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                          // Carousel Page Indicator Dots
                          if (spot.imageUrls.length > 1)
                            Positioned(
                              bottom: 16,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  spot.imageUrls.length,
                                  (idx) => AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    margin: const EdgeInsets.symmetric(horizontal: 4),
                                    width: _currentImageIndex == idx ? 20 : 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: _currentImageIndex == idx ? Colors.white : Colors.white54,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                          // Top Rating Badge Overlay
                          Positioned(
                            bottom: 16,
                            left: 16,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xB3000000),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.amber, size: 16),
                                  const SizedBox(width: 4),
                                  Text('${spot.rating} (${spot.reviewCount} reviews)',
                                      style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Main Body Content
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(AppConstants.largePadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name & Dynamic Hourly Rate
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(spot.name, style: AppTextStyles.headingLarge.copyWith(fontSize: 22)),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on_outlined, size: 16, color: AppColors.textSecondary),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(spot.address, style: AppTextStyles.bodyMedium, maxLines: 2),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('₹${dynamicRate.toInt()}/hr',
                                      style: AppTextStyles.headingLarge.copyWith(color: AppColors.primary)),
                                  if (isSurge)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.warning.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(context.l10n.peakSurgePlus(20),
                                          style: AppTextStyles.caption.copyWith(color: AppColors.warning, fontWeight: FontWeight.bold)),
                                    ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Live Adaptive Re-route Trigger Banner
                          if (spot.availableSlots == 0)
                            Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.warning.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Facility Full. AI adaptive re-routing available.',
                                      style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, color: AppColors.warning),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () => _showAdaptiveRerouteDialog(spot),
                                    child: const Text('Reroute'),
                                  ),
                                ],
                              ),
                            ),

                          // Quick Metrics Strip
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 10)],
                            ),
                            child: Row(
                              children: [
                                _buildStatItem(Icons.near_me, '${spot.distanceInKm} km', 'Distance'),
                                const SizedBox(height: 24, child: VerticalDivider(width: 1)),
                                _buildStatItem(Icons.directions_walk, '${spot.walkingTimeInMins} mins', 'Walk Time'),
                                const SizedBox(height: 24, child: VerticalDivider(width: 1)),
                                _buildStatItem(Icons.check_circle, '${spot.availableSlots}/${spot.totalSlots}', 'Live Slots'),
                                const SizedBox(height: 24, child: VerticalDivider(width: 1)),
                                _buildStatItem(Icons.shield_outlined, '${spot.securityRating}★', 'Security'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // EXPLAINABLE AI RECOMMENDATION SECTION
                          _buildExplainableAICard(spot, aiBullets),
                          const SizedBox(height: 24),

                          // AI PREDICTION ANALYTICS SECTION
                          predictionAsync.when(
                            data: (pred) => pred != null ? _buildAIPredictionCard(pred) : const SizedBox.shrink(),
                            loading: () => const Center(child: CircularProgressIndicator()),
                            error: (err, stack) => const SizedBox.shrink(),
                          ),
                          const SizedBox(height: 24),

                          // PARKING DIGITAL TWIN LIVE TELEMETRY STREAM PANEL
                          digitalTwinStreamAsync.when(
                            data: (twin) => _buildDigitalTwinCard(
                              twin ?? aiEngine.getDigitalTwin(spot),
                            ),
                            loading: () => _buildDigitalTwinCard(aiEngine.getDigitalTwin(spot)),
                            error: (err, stack) => _buildDigitalTwinCard(aiEngine.getDigitalTwin(spot)),
                          ),
                          const SizedBox(height: 24),

                          // AMENITIES & FEATURES SECTION
                          Text('Amenities & Facility Features', style: AppTextStyles.headingSmall),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 10,
                            children: spot.amenities.map((amenity) => _buildFeatureChip(amenity)).toList(),
                          ),
                          const SizedBox(height: 24),

                          // ACCESSIBILITY & VEHICLE TYPES SECTION
                          Text('Compatible Vehicles & Accessibility', style: AppTextStyles.headingSmall),
                          const SizedBox(height: 12),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final isNarrow = constraints.maxWidth < 340;
                              return Flex(
                                direction: isNarrow ? Axis.vertical : Axis.horizontal,
                                children: [
                                  Expanded(
                                    flex: isNarrow ? 0 : 1,
                                    child: Card(
                                      elevation: 0,
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        side: const BorderSide(color: AppColors.border),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Vehicles', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold)),
                                            const SizedBox(height: 6),
                                            Wrap(
                                              spacing: 4,
                                              runSpacing: 4,
                                              children: spot.availableVehicleTypes
                                                  .map((v) => Chip(
                                                        label: Text(v, style: AppTextStyles.caption),
                                                        padding: EdgeInsets.zero,
                                                        visualDensity: VisualDensity.compact,
                                                      ))
                                                  .toList(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: isNarrow ? 0 : 12, height: isNarrow ? 8 : 0),
                                  Expanded(
                                    flex: isNarrow ? 0 : 1,
                                    child: Card(
                                      elevation: 0,
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        side: const BorderSide(color: AppColors.border),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Operating Hours', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold)),
                                            const SizedBox(height: 6),
                                            Text(spot.operatingHours, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                                            const SizedBox(height: 4),
                                            Text('CCTV Monitored', style: AppTextStyles.caption.copyWith(color: AppColors.success)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 24),

                          // CUSTOMER REVIEWS SECTION
                          Text('Customer Reviews', style: AppTextStyles.headingSmall),
                          const SizedBox(height: 12),
                          reviewsAsync.when(
                            data: (reviews) => Column(
                              children: reviews.map((rev) => _buildReviewCard(rev)).toList(),
                            ),
                            loading: () => const CircularProgressIndicator(),
                            error: (err, stack) => const SizedBox.shrink(),
                          ),

                          const SizedBox(height: 32), // Clear bottom spacing inside scrollview
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),

      // Bottom Sticky Action Bar (Navigate + Reserve Parking)
      bottomNavigationBar: parkingAsync.when(
        data: (spot) => spot != null
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                      IconButton.outlined(
                        icon: const Icon(Icons.share, color: AppColors.primary, size: 20),
                        onPressed: () => _shareParkingDetails(spot),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        flex: 2,
                        child: SecondaryButton(
                          text: _isNavigating ? 'Opening...' : 'Navigate',
                          icon: _isNavigating ? Icons.hourglass_top : Icons.navigation_outlined,
                          onPressed: _isNavigating ? () {} : () => _navigateToParking(spot),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 3,
                        child: PrimaryButton(
                          text: 'Reserve Parking',
                          onPressed: () => _openReservationFlow(spot),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : const SizedBox.shrink(),
        loading: () => const SizedBox.shrink(),
        error: (err, stack) => const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildExplainableAICard(ParkingLotModel spot, List<String> bullets) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 12, offset: Offset(0, 4))],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'AI Recommendation Insights',
                        style: AppTextStyles.headingSmall.copyWith(color: Colors.white, fontSize: 15),
                        maxLines: 2,
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${spot.aiMatchScore.toInt()}% Match Score',
                  style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Confidence Level: ${spot.aiConfidence.toInt()}%',
            style: AppTextStyles.caption.copyWith(color: Colors.white70, fontWeight: FontWeight.w600),
          ),
          const Divider(color: Colors.white24, height: 20),
          Text('Why this parking was recommended:', style: AppTextStyles.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...bullets.map(
            (b) => Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle, color: Color(0xFF00E676), size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(b, style: AppTextStyles.bodySmall.copyWith(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIPredictionCard(PredictionModel pred) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.analytics_outlined, color: AppColors.primary, size: 20),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'AI Prediction Analytics',
                          style: AppTextStyles.headingSmall.copyWith(fontSize: 15),
                          maxLines: 2,
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(pred.demandTrend, style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Multi-Horizon Occupancy Progress Indicators
            _buildProgressRow('Current Occupancy', pred.currentOccupancyPercentage),
            const SizedBox(height: 8),
            _buildProgressRow('+15 Min Prediction', pred.predictedOccupancy15Min),
            const SizedBox(height: 8),
            _buildProgressRow('+30 Min Prediction', pred.predictedOccupancy30Min),
            const SizedBox(height: 8),
            _buildProgressRow('+1 Hour Prediction', pred.predictedOccupancy1Hour),
            const SizedBox(height: 8),
            _buildProgressRow('+2 Hours Prediction', pred.predictedOccupancy2Hours),
            const Divider(height: 24),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildPredictionStat('Best Arrival', pred.bestArrivalTime),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPredictionStat('Est. Wait Time', '< ${pred.predictedWaitingTimeMins} mins'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildPredictionStat('Traffic Trend', pred.trafficTrend),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPredictionStat('Pricing Trend', pred.dynamicPricingTrend),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDigitalTwinCard(DigitalTwinModel twin) {
    return Card(
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.model_training_outlined, color: AppColors.secondary, size: 20),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Digital Twin Live Telemetry',
                          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold, fontSize: 15),
                          maxLines: 2,
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text('LIVE STREAM', style: AppTextStyles.caption.copyWith(color: AppColors.success, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(child: _buildDigitalTwinMetric('Inflow Rate', '${twin.vehicleInflowRatePerHour} cars/hr', Icons.south_east, AppColors.success)),
                Expanded(child: _buildDigitalTwinMetric('Outflow Rate', '${twin.vehicleOutflowRatePerHour} cars/hr', Icons.north_east, AppColors.warning)),
                Expanded(child: _buildDigitalTwinMetric('Surge Multiplier', '${twin.currentSurgeMultiplier}x', Icons.speed, AppColors.primary)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.primary, size: 18),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            label,
            style: AppTextStyles.caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressRow(String label, double percentage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodySmall,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Text('${percentage.toInt()}%', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: (percentage / 100.0).clamp(0.0, 1.0),
            minHeight: 6,
            backgroundColor: AppColors.border,
            valueColor: AlwaysStoppedAnimation<Color>(
              percentage > 85 ? AppColors.error : (percentage > 70 ? AppColors.warning : AppColors.success),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPredictionStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildDigitalTwinMetric(String label, String value, IconData icon, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(value, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
        ),
        Text(
          label,
          style: AppTextStyles.caption,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildFeatureChip(String label) {
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
          const Icon(Icons.check, size: 16, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(label, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }

  Widget _buildReviewCard(ParkingReviewModel rev) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: const Icon(Icons.person, size: 18, color: AppColors.primary),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rev.userName,
                        style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${rev.vehicleType} • ${rev.date}',
                        style: AppTextStyles.caption,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 2),
                    Text(rev.rating.toString(), style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(rev.comment, style: AppTextStyles.bodySmall),
          ],
        ),
      ),
    );
  }
}
