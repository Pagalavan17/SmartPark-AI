import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/widgets/custom_search_bar.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/secondary_button.dart';
import '../../../core/widgets/app_navigation_drawer.dart';

import '../../../models/parking_lot_model.dart';
import '../../../services/sensor/sensor_providers.dart';

import '../../parking/presentation/parking_controller.dart';
import '../../parking/presentation/widgets/reservation_flow_modal.dart';

/// Complete Live Google Parking Map Screen with AI Smart Pick & Traffic Overlays
class LiveParkingMapScreen extends ConsumerStatefulWidget {
  const LiveParkingMapScreen({super.key});

  @override
  ConsumerState<LiveParkingMapScreen> createState() => _LiveParkingMapScreenState();
}

class _LiveParkingMapScreenState extends ConsumerState<LiveParkingMapScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GoogleMapController? _rawMapController;
  final Completer<GoogleMapController> _mapControllerCompleter = Completer();
  
  static const LatLng _initialCameraPosition = LatLng(12.9715, 80.0434); // CIT Main Gate Parking Center
  LatLng _userLocation = _initialCameraPosition;

  Set<Polyline> _polylines = {};
  ParkingLotModel? _selectedLot;

  String _searchQuery = '';
  String _selectedFilter = 'AI Recommended';
  final List<String> _filterChips = [
    'AI Recommended',
    'Nearest',
    'Cheapest',
    'EV Charging',
    'Covered',
    'Lowest Traffic',
    'Open Now',
  ];

  String _getFilterChipLabel(BuildContext context, String chip) {
    final l10n = context.l10n;
    switch (chip) {
      case 'AI Recommended':
        return l10n.aiRecommended;
      case 'Nearest':
        return l10n.nearest;
      case 'Cheapest':
        return l10n.cheapest;
      case 'EV Charging':
        return l10n.evCharging;
      case 'Covered':
        return l10n.covered;
      case 'Lowest Traffic':
        return l10n.lowestTraffic;
      case 'Open Now':
        return l10n.openNow;
      default:
        return chip;
    }
  }

  @override
  void initState() {
    super.initState();
    _determineUserLocation(showFeedback: false);
  }

  Future<void> _determineUserLocation({bool showFeedback = false}) async {
    if (!mounted) return;

    try {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('[Location] Location service is disabled.');
        if (showFeedback && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.locationServicesDisabled),
              duration: const Duration(seconds: 3),
            ),
          );
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('[Location] Location permission denied by user.');
          if (showFeedback && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.l10n.locationPermissionRequiredMsg),
                duration: const Duration(seconds: 3),
              ),
            );
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('[Location] Location permission permanently denied.');
        if (showFeedback && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(context.l10n.locationPermissionPermanentDeniedMsg),
              duration: const Duration(seconds: 4),
              action: SnackBarAction(
                label: context.l10n.settings,
                onPressed: () => Geolocator.openAppSettings(),
              ),
            ),
          );
        }
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 5),
      ).catchError((_) async {
        return await Geolocator.getLastKnownPosition() ?? Position(
          longitude: _initialCameraPosition.longitude,
          latitude: _initialCameraPosition.latitude,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          altitudeAccuracy: 0,
          heading: 0,
          headingAccuracy: 0,
          speed: 0,
          speedAccuracy: 0,
        );
      });

      if (!mounted) return;

      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
      });

      GoogleMapController? controller = _rawMapController;
      if (controller == null && !_mapControllerCompleter.isCompleted) {
        controller = await _mapControllerCompleter.future.timeout(
          const Duration(seconds: 3),
          onTimeout: () => throw TimeoutException('Map controller timed out'),
        );
      }

      if (controller != null) {
        await controller.animateCamera(CameraUpdate.newLatLngZoom(_userLocation, 16.0));
        debugPrint('[Location] Camera animated to position: $_userLocation');
        if (showFeedback && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Centered map on your current location'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else if (showFeedback && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Map is still initializing. Please try again in a moment.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      debugPrint('[Location] Exception while centering camera: $e');
      if (showFeedback && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unable to obtain location: ${e.toString().split("\n").first}'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Set<Marker> _buildMapMarkers(List<ParkingLotModel> lots) {
    final Set<Marker> markers = {};
    for (final lot in lots) {
      final double freeRatio = lot.totalSlots > 0 ? lot.availableSlots / lot.totalSlots : 0.0;
      BitmapDescriptor markerColor;

      if (lot.aiMatchScore >= 95.0) {
        markerColor = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
      } else if (freeRatio > 0.3) {
        markerColor = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      } else if (freeRatio > 0.1) {
        markerColor = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
      } else {
        markerColor = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      }

      markers.add(
        Marker(
          markerId: MarkerId(lot.id),
          position: LatLng(lot.latitude, lot.longitude),
          icon: markerColor,
          infoWindow: InfoWindow(
            title: lot.name,
            snippet: '${lot.availableSlots} slots free • ₹${lot.baseHourlyRate.toInt()}/hr',
          ),
          onTap: () {
            setState(() {
              _selectedLot = lot;
              _drawRouteToLot(lot);
            });
          },
        ),
      );
    }
    return markers;
  }

  void _drawRouteToLot(ParkingLotModel lot) {
    final Set<Polyline> newPolylines = {
      Polyline(
        polylineId: PolylineId('route_${lot.id}'),
        color: AppColors.primary,
        width: 5,
        points: [
          _userLocation,
          LatLng((_userLocation.latitude + lot.latitude) / 2, (_userLocation.longitude + lot.longitude) / 2),
          LatLng(lot.latitude, lot.longitude),
        ],
      ),
    };
    setState(() => _polylines = newPolylines);
  }

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
    final lotsAsync = ref.watch(parkingLotsProvider);
    final aiEngine = ref.watch(aiDecisionEngineProvider);

    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppNavigationDrawer(currentRoute: '/search'),
      body: Stack(
        children: [
          // Google Map — markers are driven by parkingLotsProvider stream
          Positioned.fill(
            child: lotsAsync.when(
              loading: () => GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: _initialCameraPosition,
                  zoom: 13.5,
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                trafficEnabled: true,
                markers: const {},
                polylines: const {},
                onMapCreated: (GoogleMapController controller) {
                  _rawMapController = controller;
                  if (!_mapControllerCompleter.isCompleted) {
                    _mapControllerCompleter.complete(controller);
                  }
                },
              ),
              error: (error, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.cloud_off_outlined,
                          size: 56, color: AppColors.textLight),
                      const SizedBox(height: 16),
                      const Text(
                        'Unable to load parking locations.\nCheck your internet connection and try again.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      TextButton.icon(
                        onPressed: () => ref.invalidate(parkingLotsProvider),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
              data: (allLots) {
                final lots = _searchQuery.isEmpty
                    ? allLots
                    : allLots
                        .where((l) => l.name
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase()))
                        .toList();

                if (_selectedLot == null && lots.isNotEmpty) {
                  _selectedLot = lots.first;
                }

                final markers = _buildMapMarkers(lots);

                return GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: _initialCameraPosition,
                    zoom: 13.5,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  trafficEnabled: true,
                  markers: markers,
                  polylines: _polylines,
                  onMapCreated: (GoogleMapController controller) {
                    _rawMapController = controller;
                    if (!_mapControllerCompleter.isCompleted) {
                      _mapControllerCompleter.complete(controller);
                    }
                    debugPrint('[GoogleMap] Map platform view created and bound successfully.');
                  },
                );
              },
            ),
          ),

          // Top Header (Search Bar + Drawer Toggle + Filter Chips)
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: const Icon(Icons.menu, color: AppColors.primary, size: 24),
                          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomSearchBar(
                          hintText: context.l10n.searchPlaceholder,
                          onChanged: (val) => setState(() => _searchQuery = val),
                        ),
                      ),
                    ],
                  ),
                ),

                // Horizontal Filter Chips Bar
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
                    itemCount: _filterChips.length,
                    itemBuilder: (context, index) {
                      final filter = _filterChips[index];
                      final isSelected = filter == _selectedFilter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(_getFilterChipLabel(context, filter)),
                          selected: isSelected,
                          selectedColor: AppColors.primary,
                          backgroundColor: Colors.white,
                          labelStyle: AppTextStyles.bodyMedium.copyWith(
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          onSelected: (selected) {
                            if (selected) setState(() => _selectedFilter = filter);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Floating Action Buttons (Recenter & Map Legend)
          Positioned(
            right: 16,
            bottom: _selectedLot != null ? 240 : 30,
            child: Column(
              children: [
                FloatingActionButton.small(
                  heroTag: 'legend_btn',
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primary,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Live Occupancy Color Legend'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildLegendItem('Violet', 'AI Smart Pick Highlight'),
                            _buildLegendItem('Green', 'High Availability (> 30% Free)'),
                            _buildLegendItem('Orange', 'Moderate Availability (10-30% Free)'),
                            _buildLegendItem('Red', 'Nearly Full (< 10% Free)'),
                          ],
                        ),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
                        ],
                      ),
                    );
                  },
                  child: const Icon(Icons.info_outline),
                ),
                const SizedBox(height: 8),
                FloatingActionButton.small(
                  heroTag: 'my_loc_btn',
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primary,
                  onPressed: () => _determineUserLocation(showFeedback: true),
                  child: const Icon(Icons.my_location),
                ),
              ],
            ),
          ),

          // Persistent Interactive Bottom Card for Selected Parking Lot
          if (_selectedLot != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: 24,
              child: Consumer(
                builder: (context, ref, child) {
                  final twinAsync = ref.watch(digitalTwinStreamProvider(_selectedLot!.id));
                  final twin = twinAsync.value ?? aiEngine.getDigitalTwin(_selectedLot!);

                  return SelectedParkingCard(
                    parkingLot: _selectedLot!,
                    freeSlots: twin.liveTotalSlots - twin.liveOccupiedSlots,
                    onDetails: () => context.go('/parking-details/${_selectedLot!.id}'),
                    onReserve: () => _openReservationFlow(_selectedLot!),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String colorName, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(Icons.location_on, size: 20, color: _getLegendColor(colorName)),
          const SizedBox(width: 8),
          Expanded(child: Text(description, style: AppTextStyles.bodySmall)),
        ],
      ),
    );
  }

  Color _getLegendColor(String name) {
    switch (name) {
      case 'Violet':
        return Colors.purple;
      case 'Green':
        return Colors.green;
      case 'Orange':
        return Colors.orange;
      case 'Red':
      default:
        return Colors.red;
    }
  }


}

/// Standalone, Fully Responsive Selected Parking Result Card Widget
class SelectedParkingCard extends StatelessWidget {
  final ParkingLotModel parkingLot;
  final int freeSlots;
  final VoidCallback onDetails;
  final VoidCallback onReserve;

  const SelectedParkingCard({
    super.key,
    required this.parkingLot,
    required this.freeSlots,
    required this.onDetails,
    required this.onReserve,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              parkingLot.name,
                              style: AppTextStyles.headingSmall.copyWith(fontSize: 17),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (parkingLot.aiMatchScore >= 95) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'AI Pick',
                                style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        parkingLot.address,
                        style: AppTextStyles.caption,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '₹${parkingLot.baseHourlyRate.toInt()}/hr',
                  style: AppTextStyles.headingSmall.copyWith(color: AppColors.primary),
                ),
              ],
            ),
            const Divider(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                buildMiniMetric(context, Icons.near_me, context.l10n.kmAway(parkingLot.distanceInKm)),
                buildMiniMetric(context, Icons.directions_walk, context.l10n.minsWalk(parkingLot.walkingTimeInMins)),
                buildMiniMetric(context, Icons.check_circle, context.l10n.slotsFree(freeSlots), isSuccess: true),
                buildMiniMetric(context, Icons.auto_awesome, context.l10n.aiScore(parkingLot.aiMatchScore.toInt()), isHighlight: true),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: SecondaryButton(
                    text: context.l10n.parkingDetails,
                    onPressed: onDetails,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: PrimaryButton(
                    text: context.l10n.reserveNow,
                    onPressed: onReserve,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMiniMetric(
    BuildContext context,
    IconData icon,
    String label, {
    bool isSuccess = false,
    bool isHighlight = false,
  }) {
    final Color itemColor = isHighlight
        ? AppColors.primary
        : (isSuccess ? AppColors.success : AppColors.primary);

    final Color textColor = isHighlight
        ? AppColors.primary
        : (isSuccess ? AppColors.success : Theme.of(context).colorScheme.onSurface);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: itemColor),
        const SizedBox(width: 4),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 150),
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
          ),
        ),
      ],
    );
  }
}
