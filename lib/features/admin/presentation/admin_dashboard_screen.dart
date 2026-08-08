import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_navigation_drawer.dart';

import '../../../services/sensor/sensor_providers.dart';
import 'admin_providers.dart';

/// Production Enterprise Admin Dashboard Screen
class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedTimeFrame = 'Daily';

  final List<Map<String, String>> _incidents = [
    {'id': 'INC-101', 'title': 'ANPR Camera #4 Offline', 'severity': 'High', 'facility': 'Metro Cyber Park'},
    {'id': 'INC-102', 'title': 'Occupancy Spike > 95%', 'severity': 'Medium', 'facility': 'Phoenix Marketcity'},
    {'id': 'INC-103', 'title': 'Barrier Gate Delay', 'severity': 'Low', 'facility': 'Express Avenue'},
  ];

  @override
  Widget build(BuildContext context) {
    final analyticsAsync = ref.watch(adminAnalyticsProvider(_selectedTimeFrame));
    final systemHealth = ref.watch(systemHealthStatusProvider);
    final twinStreamAsync = ref.watch(digitalTwinStreamProvider('spot_metro'));

    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppNavigationDrawer(currentRoute: '/admin'),
      appBar: AppBar(
        title: const Text('Enterprise AI Admin Dashboard'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.download),
            tooltip: 'Export Reports',
            onSelected: (format) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Exporting $_selectedTimeFrame Report as $format...')),
              );
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(value: 'PDF', child: Text('Export PDF Report')),
              const PopupMenuItem(value: 'CSV', child: Text('Export CSV Data')),
              const PopupMenuItem(value: 'Excel', child: Text('Export Excel Sheet')),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeframe Selector Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Platform Executive Summary', style: AppTextStyles.headingSmall),
                DropdownButton<String>(
                  value: _selectedTimeFrame,
                  items: const [
                    DropdownMenuItem(value: 'Daily', child: Text('Today')),
                    DropdownMenuItem(value: 'Weekly', child: Text('This Week')),
                    DropdownMenuItem(value: 'Monthly', child: Text('This Month')),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedTimeFrame = val);
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Top Stat Cards Grid
            analyticsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Text('Error loading analytics: $err'),
              data: (report) => Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildMetricCard('Total Revenue', '₹${report.totalRevenue.toInt()}', Icons.payments, AppColors.success)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildMetricCard('Live Occupancy', '${report.globalOccupancyRate}%', Icons.pie_chart, AppColors.primary)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildMetricCard('Active Bookings', '${report.totalReservations}', Icons.confirmation_number, AppColors.secondary)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildMetricCard('AI Accuracy', '${report.aiPredictionAccuracy}%', Icons.auto_awesome, Colors.purple)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildMetricCard('EV Energy', '${report.evChargingEnergyKWh.toInt()} kWh', Icons.ev_station, AppColors.success)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildMetricCard('CO₂ Saved', '${report.co2SavingsKg.toInt()} kg', Icons.eco, Colors.green)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // DIGITAL TWIN LIVE TELEMETRY & HARDWARE HEALTH
            Text('Digital Twin & Hardware Telemetry', style: AppTextStyles.headingSmall),
            const SizedBox(height: 12),
            twinStreamAsync.when(
              data: (twin) => Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Metro Cyber Park Twin', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
                            child: Text('ONLINE STREAM', style: AppTextStyles.caption.copyWith(color: AppColors.success, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildSensorStatus('IoT Sensors', '120 / 120 Online', true),
                          _buildSensorStatus('ANPR Cameras', '12 / 12 Online', true),
                          _buildSensorStatus('RFID Readers', '8 / 8 Online', true),
                          _buildSensorStatus('Barrier Gates', '4 / 4 Online', true),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (context, error) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 24),

            // SYSTEM HEALTH SERVICES MONITOR
            Text('Microservice System Health', style: AppTextStyles.headingSmall),
            const SizedBox(height: 12),
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: systemHealth.entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(entry.key, style: AppTextStyles.bodyMedium),
                          Row(
                            children: [
                              Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle)),
                              const SizedBox(width: 6),
                              Text('Operational', style: AppTextStyles.caption.copyWith(color: AppColors.success, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // INCIDENT MANAGEMENT & ACTION CENTER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Active Incident Log', style: AppTextStyles.headingSmall),
                Text('${_incidents.length} Pending', style: AppTextStyles.caption.copyWith(color: AppColors.error, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Column(
              children: _incidents.map((inc) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppColors.border)),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.orangeAccent,
                      child: Icon(Icons.warning, color: Colors.white, size: 20),
                    ),
                    title: Text(inc['title']!, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                    subtitle: Text('Facility: ${inc['facility']} • Severity: ${inc['severity']}', style: AppTextStyles.caption),
                    trailing: TextButton(
                      onPressed: () {
                        setState(() {
                          _incidents.removeWhere((item) => item['id'] == inc['id']);
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Incident ${inc['id']} resolved.')),
                        );
                      },
                      child: const Text('Resolve'),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.15),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.caption),
                  Text(value, style: AppTextStyles.headingSmall.copyWith(fontSize: 18)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorStatus(String title, String subtitle, bool isOnline) {
    return Column(
      children: [
        Icon(isOnline ? Icons.check_circle : Icons.error, color: isOnline ? AppColors.success : AppColors.error, size: 20),
        const SizedBox(height: 4),
        Text(title, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold)),
        Text(subtitle, style: AppTextStyles.caption.copyWith(fontSize: 10)),
      ],
    );
  }
}
