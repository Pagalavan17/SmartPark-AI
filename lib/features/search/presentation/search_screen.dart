import 'package:flutter/material.dart';
import 'live_parking_map_screen.dart';

/// Search Screen delegating directly to Production Live Google Parking Map
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LiveParkingMapScreen();
  }
}
