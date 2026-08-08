import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
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
  final Completer<GoogleMapController> _mapController = Completer();
  
  static const LatLng _initialCameraPosition = LatLng(13.0067, 80.2020); // Chennai Center
  LatLng _userLocation = _initialCameraPosition;

  Set<Marker> _markers = {};
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

  @override
  void initState() {
    super.initState();
    _determineUserLocation();
  }

  Future<void> _determineUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _userLocation = LatLng(position.latitude, position.longitude);
    });

    final controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newLatLngZoom(_userLocation, 14.5));
  }

  void _loadMapMarkers(List<ParkingLotModel> lots) {
    final Set<Marker> newMarkers = {};
    for (final lot in lots) {
      final double freeRatio = lot.availableSlots / lot.totalSlots;
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

      newMarkers.add(
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

    setState(() {
      _markers = newMarkers;
    });
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
    final parkingRepo = ref.watch(parkingRepositoryProvider);
    final aiEngine = ref.watch(aiDecisionEngineProvider);

    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppNavigationDrawer(currentRoute: '/search'),
      body: Stack(
        children: [
          // Google Map Interface
          FutureBuilder<List<ParkingLotModel>>(
            future: parkingRepo.getAllParkingLots(),
            builder: (context, snapshot) {
              final allLots = snapshot.data ?? [];
              final lots = _searchQuery.isEmpty
                  ? allLots
                  : allLots.where((l) => l.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

              if (lots.isNotEmpty && _markers.isEmpty) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _loadMapMarkers(lots);
                  if (_selectedLot == null) {
                    setState(() => _selectedLot = lots.first);
                  }
                });
              }

              return GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: _initialCameraPosition,
                  zoom: 13.5,
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                trafficEnabled: true,
                markers: _markers,
                polylines: _polylines,
                onMapCreated: (GoogleMapController controller) {
                  if (!_mapController.isCompleted) {
                    _mapController.complete(controller);
                  }
                },
              );
            },
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
                          hintText: 'Search destination or parking area...',
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
                          label: Text(filter),
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
                  onPressed: _determineUserLocation,
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
                                        Text(_selectedLot!.name, style: AppTextStyles.headingSmall.copyWith(fontSize: 17)),
                                        if (_selectedLot!.aiMatchScore >= 95)
                                          Container(
                                            margin: const EdgeInsets.only(left: 6),
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: AppColors.primary,
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text('AI Pick', style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(_selectedLot!.address, style: AppTextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                              ),
                              Text('₹${_selectedLot!.baseHourlyRate.toInt()}/hr', style: AppTextStyles.headingSmall.copyWith(color: AppColors.primary)),
                            ],
                          ),
                          const Divider(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildMiniMetric(Icons.near_me, '${_selectedLot!.distanceInKm} km'),
                              _buildMiniMetric(Icons.directions_walk, '${_selectedLot!.walkingTimeInMins} mins'),
                              _buildMiniMetric(Icons.check_circle, '${twin.liveTotalSlots - twin.liveOccupiedSlots} slots free', isSuccess: true),
                              _buildMiniMetric(Icons.auto_awesome, '${_selectedLot!.aiMatchScore.toInt()}% AI Score'),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: SecondaryButton(
                                  text: 'Details',
                                  onPressed: () => context.go('/parking-details/${_selectedLot!.id}'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                flex: 2,
                                child: PrimaryButton(
                                  text: 'Reserve Now',
                                  onPressed: () => _openReservationFlow(_selectedLot!),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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

  Widget _buildMiniMetric(IconData icon, String label, {bool isSuccess = false}) {
    return Row(
      children: [
        Icon(icon, size: 14, color: isSuccess ? AppColors.success : AppColors.primary),
        const SizedBox(width: 4),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            fontWeight: FontWeight.bold,
            color: isSuccess ? AppColors.success : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
