import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/extensions/l10n_extension.dart';
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

  String _getTimeframeLabel(BuildContext context, String timeframe) {
    final l10n = context.l10n;
    switch (timeframe) {
      case 'Daily':
        return l10n.today;
      case 'Weekly':
        return l10n.thisWeek;
      case 'Monthly':
        return l10n.thisMonth;
      default:
        return timeframe;
    }
  }

  @override
  Widget build(BuildContext context) {
    final analyticsAsync = ref.watch(adminAnalyticsProvider(_selectedTimeFrame));
    final systemHealth = ref.watch(systemHealthStatusProvider);
    final twinStreamAsync = ref.watch(digitalTwinStreamProvider('spot_metro'));
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Scaffold(
      key: _scaffoldKey,
      drawer: const AppNavigationDrawer(currentRoute: '/admin'),
      appBar: AppBar(
        title: Text(
          l10n.adminDashboard,
          style: AppTextStyles.headingSmall.copyWith(color: theme.colorScheme.onSurface),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        leading: IconButton(
          icon: Icon(Icons.menu, color: theme.colorScheme.onSurface),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.download, color: theme.colorScheme.onSurface),
            tooltip: l10n.exportReports,
            onSelected: (format) {
              final timeframeLabel = _getTimeframeLabel(context, _selectedTimeFrame);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.exportingReport(timeframeLabel, format))),
              );
            },
            itemBuilder: (ctx) => [
              PopupMenuItem(value: 'PDF', child: Text(l10n.exportPdfReport)),
              PopupMenuItem(value: 'CSV', child: Text(l10n.exportCsvData)),
              PopupMenuItem(value: 'Excel', child: Text(l10n.exportExcelSheet)),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeframe Selector Row
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.platformExecutiveSummary,
                      style: AppTextStyles.headingSmall.copyWith(fontSize: 16, color: theme.colorScheme.onSurface),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  DropdownButton<String>(
                    value: _selectedTimeFrame,
                    dropdownColor: theme.colorScheme.surface,
                    style: AppTextStyles.bodyMedium.copyWith(color: theme.colorScheme.onSurface),
                    items: ['Daily', 'Weekly', 'Monthly'].map((tf) {
                      return DropdownMenuItem(
                        value: tf,
                        child: Text(_getTimeframeLabel(context, tf)),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedTimeFrame = val);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Top Stat Cards Grid
              analyticsAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (err, stack) => Text('${l10n.error}: $err'),
                data: (report) => LayoutBuilder(
                  builder: (context, constraints) {
                    final isVeryNarrow = constraints.maxWidth < 320;
                    if (isVeryNarrow) {
                      return Column(
                        children: [
                          _buildMetricCard(l10n.totalRevenue, '₹${report.totalRevenue.toInt()}', Icons.payments, AppColors.success),
                          const SizedBox(height: 8),
                          _buildMetricCard(l10n.occupancyRate, '${report.globalOccupancyRate}%', Icons.pie_chart, AppColors.primary),
                          const SizedBox(height: 8),
                          _buildMetricCard(l10n.activeBooking, '${report.totalReservations}', Icons.confirmation_number, AppColors.secondary),
                          const SizedBox(height: 8),
                          _buildMetricCard(l10n.aiScore(report.aiPredictionAccuracy.toInt()), '${report.aiPredictionAccuracy}%', Icons.auto_awesome, Colors.purple),
                          const SizedBox(height: 8),
                          _buildMetricCard('EV Energy', '${report.evChargingEnergyKWh.toInt()} kWh', Icons.ev_station, AppColors.success),
                          const SizedBox(height: 8),
                          _buildMetricCard('CO₂ Saved', '${report.co2SavingsKg.toInt()} kg', Icons.eco, Colors.green),
                        ],
                      );
                    }
                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: _buildMetricCard(l10n.totalRevenue, '₹${report.totalRevenue.toInt()}', Icons.payments, AppColors.success)),
                            const SizedBox(width: 8),
                            Expanded(child: _buildMetricCard(l10n.occupancyRate, '${report.globalOccupancyRate}%', Icons.pie_chart, AppColors.primary)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(child: _buildMetricCard(l10n.activeBooking, '${report.totalReservations}', Icons.confirmation_number, AppColors.secondary)),
                            const SizedBox(width: 8),
                            Expanded(child: _buildMetricCard(l10n.aiScore(report.aiPredictionAccuracy.toInt()), '${report.aiPredictionAccuracy}%', Icons.auto_awesome, Colors.purple)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(child: _buildMetricCard('EV Energy', '${report.evChargingEnergyKWh.toInt()} kWh', Icons.ev_station, AppColors.success)),
                            const SizedBox(width: 8),
                            Expanded(child: _buildMetricCard('CO₂ Saved', '${report.co2SavingsKg.toInt()} kg', Icons.eco, Colors.green)),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // DIGITAL TWIN LIVE TELEMETRY & HARDWARE HEALTH
              Text('Digital Twin & Hardware Telemetry', style: AppTextStyles.headingSmall.copyWith(fontSize: 16)),
              const SizedBox(height: 12),
              twinStreamAsync.when(
                loading: () => Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(),
                          const SizedBox(height: 12),
                          Text(l10n.loading, style: AppTextStyles.caption),
                        ],
                      ),
                    ),
                  ),
                ),
                error: (err, stack) {
                  debugPrint('AdminDashboard Telemetry Error: $err');
                  debugPrintStack(stackTrace: stack);
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          const Icon(Icons.signal_cellular_connected_no_internet_4_bar, color: AppColors.error, size: 32),
                          const SizedBox(height: 8),
                          Text(
                            l10n.error,
                            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.error),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.somethingWentWrong,
                            style: AppTextStyles.caption,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed: () {
                              ref.invalidate(digitalTwinStreamProvider('spot_metro'));
                            },
                            icon: const Icon(Icons.refresh, size: 16),
                            label: Text(l10n.retry),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                data: (twin) {
                  if (twin == null) {
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            const Icon(Icons.sensors_off, color: AppColors.textSecondary, size: 32),
                            const SizedBox(height: 8),
                            Text(
                              l10n.error,
                              style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10n.noParkingAvailable,
                              style: AppTextStyles.caption,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            OutlinedButton.icon(
                              onPressed: () {
                                ref.invalidate(digitalTwinStreamProvider('spot_metro'));
                              },
                              icon: const Icon(Icons.refresh, size: 16),
                              label: Text(l10n.retry),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Metro Cyber Park Twin',
                                  style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'ONLINE STREAM',
                                  style: AppTextStyles.caption.copyWith(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 10),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(child: _buildSensorStatus('IoT Sensors', '120 / 120 Online', true)),
                              Expanded(child: _buildSensorStatus('ANPR Cameras', '12 / 12 Online', true)),
                              Expanded(child: _buildSensorStatus('RFID Readers', '8 / 8 Online', true)),
                              Expanded(child: _buildSensorStatus('Barrier Gates', '4 / 4 Online', true)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Divider(height: 1),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: _buildTelemetryMetric(
                                  'Inflow Rate',
                                  '${twin.vehicleInflowRatePerHour} cars/hr',
                                  Icons.call_received,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildTelemetryMetric(
                                  'Outflow Rate',
                                  '${twin.vehicleOutflowRatePerHour} cars/hr',
                                  Icons.call_made,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: _buildTelemetryMetric(
                                  l10n.occupancyRate,
                                  '${twin.liveTotalSlots > 0 ? ((twin.liveOccupiedSlots / twin.liveTotalSlots) * 100).toStringAsFixed(1) : 0}%',
                                  Icons.pie_chart_outline,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _buildTelemetryMetric(
                                  'Surge Multiplier',
                                  '${twin.currentSurgeMultiplier}x',
                                  Icons.trending_up,
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
              const SizedBox(height: 20),

              // SYSTEM HEALTH SERVICES MONITOR
              Text(l10n.systemHealth, style: AppTextStyles.headingSmall.copyWith(fontSize: 16)),
              const SizedBox(height: 12),
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: systemHealth.entries.map((entry) {
                      String statusLabel = 'Operational';
                      Color statusColor = AppColors.success;

                      if (entry.key == 'Digital Twin Gateway') {
                        if (twinStreamAsync.hasError || (twinStreamAsync.hasValue && twinStreamAsync.value == null)) {
                          statusLabel = 'Unavailable';
                          statusColor = AppColors.error;
                        } else if (twinStreamAsync.isLoading) {
                          statusLabel = l10n.loading;
                          statusColor = Colors.orange;
                        } else {
                          statusLabel = 'Operational';
                          statusColor = AppColors.success;
                        }
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                entry.key,
                                style: AppTextStyles.bodyMedium,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: statusColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  statusLabel,
                                  style: AppTextStyles.caption.copyWith(
                                    color: statusColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // INCIDENT MANAGEMENT & ACTION CENTER
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.recentIncidents,
                      style: AppTextStyles.headingSmall.copyWith(fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${_incidents.length} ${l10n.statusPending}',
                    style: AppTextStyles.caption.copyWith(color: AppColors.error, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (_incidents.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(l10n.noIncidentsFound, style: AppTextStyles.bodyMedium),
                  ),
                )
              else
                Column(
                  children: _incidents.map((inc) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: AppColors.border),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final isNarrow = constraints.maxWidth < 280;
                            if (isNarrow) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const CircleAvatar(
                                        radius: 14,
                                        backgroundColor: Colors.orangeAccent,
                                        child: Icon(Icons.warning, color: Colors.white, size: 16),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          inc['title']!,
                                          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${inc['facility']} • ${inc['severity']}',
                                    style: AppTextStyles.caption,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _incidents.removeWhere((item) => item['id'] == inc['id']);
                                        });
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('${inc['id']} ${l10n.statusSuccess}')),
                                        );
                                      },
                                      child: Text(l10n.done),
                                    ),
                                  ),
                                ],
                              );
                            }
                            return Row(
                              children: [
                                const CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Colors.orangeAccent,
                                  child: Icon(Icons.warning, color: Colors.white, size: 18),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        inc['title']!,
                                        style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${inc['facility']} • ${inc['severity']}',
                                        style: AppTextStyles.caption,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 4),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _incidents.removeWhere((item) => item['id'] == inc['id']);
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('${inc['id']} ${l10n.statusSuccess}')),
                                    );
                                  },
                                  child: Text(l10n.done),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: color.withValues(alpha: 0.15),
              child: Icon(icon, color: color, size: 16),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.caption.copyWith(fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      value,
                      style: AppTextStyles.headingSmall.copyWith(fontSize: 15),
                      maxLines: 1,
                    ),
                  ),
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
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(isOnline ? Icons.check_circle : Icons.error, color: isOnline ? AppColors.success : AppColors.error, size: 16),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            title,
            style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            subtitle,
            style: AppTextStyles.caption.copyWith(fontSize: 9),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildTelemetryMetric(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(fontSize: 10),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold, fontSize: 13),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
