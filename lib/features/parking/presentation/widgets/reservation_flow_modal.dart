import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/extensions/l10n_extension.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../models/parking_lot_model.dart';
import '../../../../models/reservation_model.dart';
import '../../../../models/vehicle_model.dart';
import '../parking_controller.dart';
import 'qr_pass_dialog.dart';

/// Step-by-Step Interactive Smart Reservation Wizard Widget
class ReservationFlowModal extends ConsumerStatefulWidget {
  final ParkingLotModel parkingLot;

  const ReservationFlowModal({
    super.key,
    required this.parkingLot,
  });

  @override
  ConsumerState<ReservationFlowModal> createState() => _ReservationFlowModalState();
}

class _ReservationFlowModalState extends ConsumerState<ReservationFlowModal> {
  int _currentStep = 1;

  // Step state
  String _selectedArrivalTime = 'Now (Instant Entry)';
  int _selectedDurationHours = 2;
  String _selectedVehicleType = 'Car';
  String? _vehicleRegistration = 'TN 07 CK 5555';

  static const List<String> _arrivalTimeOptions = [
    'Now (Instant Entry)',
    '+15 Mins',
    '+30 Mins',
    '+1 Hour',
    '+2 Hours',
  ];

  static const List<int> _durationOptions = [1, 2, 4, 6, 12];
  static const List<String> _vehicleTypes = ['Car', 'Bike', 'SUV', 'EV'];

  @override
  Widget build(BuildContext context) {
    final aiEngine = ref.watch(aiDecisionEngineProvider);
    final vehicleRepo = ref.watch(vehicleRepositoryProvider);

    return FutureBuilder<double>(
      future: aiEngine.getDynamicPricingRate(widget.parkingLot),
      builder: (context, snapshot) {
        final double hourlyRate = snapshot.data ?? widget.parkingLot.baseHourlyRate;
        final double baseFee = hourlyRate * _selectedDurationHours;
        final double taxes = (baseFee * 0.12).roundToDouble();
        const double serviceFee = 15.0;
        final double totalAmount = baseFee + taxes + serviceFee;

        return Container(
          padding: const EdgeInsets.all(AppConstants.largePadding),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Modal Handle Indicator Bar
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
                  const SizedBox(height: 16),

                  // Title & Step Progress Tracker Header
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          context.l10n.smartReservationWizard,
                          style: AppTextStyles.headingSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          context.l10n.stepProgress(_currentStep),
                          style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.parkingLot.name,
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 20),

                  // STEP 1: Arrival Time Selection
                  if (_currentStep == 1) ...[
                    Text(context.l10n.selectArrivalTime, style: AppTextStyles.headingSmall.copyWith(fontSize: 16)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 10,
                      children: _arrivalTimeOptions.map((time) {
                        final isSelected = _selectedArrivalTime == time;
                        final displayLabel = time == 'Now (Instant Entry)' ? context.l10n.instantEntryNow : time;
                        return ChoiceChip(
                          label: Text(displayLabel),
                          selected: isSelected,
                          selectedColor: AppColors.primary,
                          backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                          labelStyle: AppTextStyles.bodyMedium.copyWith(
                            color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          onSelected: (selected) {
                            if (selected) setState(() => _selectedArrivalTime = time);
                          },
                        );
                      }).toList(),
                    ),
                  ],

                  // STEP 2: Duration Selection
                  if (_currentStep == 2) ...[
                    Text(context.l10n.selectParkingDuration, style: AppTextStyles.headingSmall.copyWith(fontSize: 16, color: Theme.of(context).colorScheme.onSurface)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _durationOptions.map((hrs) {
                        final isSelected = _selectedDurationHours == hrs;
                        return ChoiceChip(
                          label: Text(context.l10n.durationHours(hrs)),
                          selected: isSelected,
                          selectedColor: AppColors.primary,
                          backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                          labelStyle: AppTextStyles.bodyMedium.copyWith(
                            color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          onSelected: (selected) {
                            if (selected) setState(() => _selectedDurationHours = hrs);
                          },
                        );
                      }).toList(),
                    ),
                  ],

                  // STEP 3: Vehicle Selection from Firestore
                  if (_currentStep == 3) ...[
                    Text(context.l10n.selectVehicleStep, style: AppTextStyles.headingSmall.copyWith(fontSize: 16, color: Theme.of(context).colorScheme.onSurface)),
                    const SizedBox(height: 12),
                    FutureBuilder<List<VehicleModel>>(
                      future: vehicleRepo.getUserVehicles('user_1'),
                      builder: (context, vSnapshot) {
                        final allVehicles = vSnapshot.data ?? [];
                        final filteredVehicles = allVehicles.where((v) {
                          return v.type.trim().toLowerCase() == _selectedVehicleType.trim().toLowerCase();
                        }).toList();

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Vehicle Type Filter', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _vehicleTypes.map((vType) {
                                final isSelected = _selectedVehicleType == vType;
                                return ChoiceChip(
                                  label: Text(vType),
                                  selected: isSelected,
                                  selectedColor: AppColors.primary,
                                  backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                                  labelStyle: AppTextStyles.caption.copyWith(
                                    color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                  onSelected: (selected) {
                                    if (selected) {
                                      setState(() {
                                        _selectedVehicleType = vType;
                                        final isMatch = allVehicles.any((v) =>
                                            v.registrationNumber == _vehicleRegistration &&
                                            v.type.trim().toLowerCase() == vType.trim().toLowerCase());
                                        if (!isMatch) {
                                          _vehicleRegistration = null;
                                        }
                                      });
                                    }
                                  },
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 12),
                            if (filteredVehicles.isNotEmpty)
                              Column(
                                children: filteredVehicles.map((v) {
                                  final isVehSelected = _vehicleRegistration == v.registrationNumber;
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    decoration: BoxDecoration(
                                      color: isVehSelected
                                          ? AppColors.primary.withValues(alpha: 0.12)
                                          : Theme.of(context).colorScheme.surface,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isVehSelected ? AppColors.primary : Theme.of(context).colorScheme.outline,
                                        width: isVehSelected ? 2 : 1,
                                      ),
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                      child: ListTile(
                                        onTap: () {
                                          setState(() {
                                            _vehicleRegistration = v.registrationNumber;
                                            _selectedVehicleType = v.type;
                                          });
                                        },
                                        leading: Icon(
                                          v.type.trim().toUpperCase() == 'BIKE'
                                              ? Icons.two_wheeler
                                              : (v.type.trim().toUpperCase() == 'EV'
                                                  ? Icons.electric_car
                                                  : Icons.directions_car),
                                          color: isVehSelected ? AppColors.primary : Theme.of(context).colorScheme.onSurfaceVariant,
                                        ),
                                        title: Text(
                                          '${v.modelName} (${v.registrationNumber})',
                                          style: AppTextStyles.bodyMedium.copyWith(
                                            fontWeight: isVehSelected ? FontWeight.bold : FontWeight.normal,
                                            color: Theme.of(context).colorScheme.onSurface,
                                          ),
                                        ),
                                        subtitle: Text('Type: ${v.type}', style: AppTextStyles.caption.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                                        trailing: isVehSelected
                                            ? const Icon(Icons.check_circle, color: AppColors.primary)
                                            : null,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              )
                            else
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surfaceContainer,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Theme.of(context).colorScheme.outline),
                                ),
                                child: Column(
                                  children: [
                                    Icon(Icons.directions_car_outlined, size: 36, color: Theme.of(context).colorScheme.onSurfaceVariant),
                                    const SizedBox(height: 8),
                                    Text(
                                      'No $_selectedVehicleType vehicles available',
                                      style: AppTextStyles.bodyMedium.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant, fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ],

                  // STEP 4: Dynamic Pricing Summary
                  if (_currentStep == 4) ...[
                    Text(context.l10n.reviewBookingSummary, style: AppTextStyles.headingSmall.copyWith(fontSize: 16, color: Theme.of(context).colorScheme.onSurface)),
                    const SizedBox(height: 12),
                    Card(
                      elevation: 0,
                      color: Theme.of(context).colorScheme.surfaceContainer,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          children: [
                            _buildSummaryItem(context.l10n.startTime, _selectedArrivalTime == 'Now (Instant Entry)' ? context.l10n.instantEntryNow : _selectedArrivalTime),
                            _buildSummaryItem(context.l10n.selectDuration, context.l10n.durationHours(_selectedDurationHours)),
                            _buildSummaryItem('Vehicle Number', _vehicleRegistration ?? 'N/A'),
                            _buildSummaryItem('Vehicle Class', _selectedVehicleType),
                            const Divider(height: 20),
                            _buildSummaryItem('Base Hourly Rate', '₹${widget.parkingLot.baseHourlyRate.toInt()}/hr'),
                            _buildSummaryItem('AI Dynamic Rate', '₹${hourlyRate.toInt()}/hr'),
                            _buildSummaryItem('Parking Subtotal', '₹${baseFee.toInt()}'),
                            _buildSummaryItem('Taxes & GST (12%)', '₹${taxes.toInt()}'),
                            _buildSummaryItem('Platform Service Fee', '₹${serviceFee.toInt()}'),
                            const Divider(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text('Grand Total', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                                ),
                                const SizedBox(width: 8),
                                Text('₹${totalAmount.toInt()}', style: AppTextStyles.headingSmall.copyWith(color: AppColors.primary)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  // STEP 5: Final Confirmation
                  if (_currentStep == 5) ...[
                    Text('5. Confirm Reservation', style: AppTextStyles.headingSmall.copyWith(fontSize: 16, color: Theme.of(context).colorScheme.onSurface)),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.verified, color: AppColors.success, size: 28),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Slot Guaranteed', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold, color: AppColors.success)),
                                Text('Slot A-${(10 + (_selectedDurationHours * 2)).clamp(1, 99)} allocated instantly via Digital Twin.', style: AppTextStyles.bodySmall.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Navigation Buttons Row
                  Row(
                    children: [
                      if (_currentStep > 1)
                        Expanded(
                          flex: 1,
                          child: OutlinedButton(
                            onPressed: () => setState(() => _currentStep--),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text('Back'),
                            ),
                          ),
                        ),
                      if (_currentStep > 1) const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: PrimaryButton(
                          text: _currentStep < 5 ? 'Next Step' : 'Confirm & Generate Pass',
                          onPressed: () async {
                            if (_currentStep == 3) {
                              if (_vehicleRegistration == null || _vehicleRegistration!.isEmpty) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Please select a vehicle to proceed.')),
                                  );
                                }
                                return;
                              }
                            }
                            if (_currentStep < 5) {
                              setState(() => _currentStep++);
                            } else {
                              // Complete reservation & update Firestore
                              final resRepo = ref.read(reservationRepositoryProvider);
                              final newRes = ReservationModel(
                                reservationId: 'SP-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                                parkingId: widget.parkingLot.id,
                                parkingName: widget.parkingLot.name,
                                parkingAddress: widget.parkingLot.address,
                                allocatedSlot: 'Slot A-${(10 + (_selectedDurationHours * 2)).clamp(1, 99)}',
                                arrivalTime: DateTime.now(),
                                durationInHours: _selectedDurationHours,
                                vehicleType: _selectedVehicleType,
                                vehicleNumber: _vehicleRegistration ?? 'TN 01 AB 1234',
                                baseRatePerHour: hourlyRate,
                                surgeFee: widget.parkingLot.isPeakHour ? 10.0 : 0.0,
                                serviceFee: serviceFee,
                                totalAmount: totalAmount,
                                qrCodeToken: 'SMARTPARK_PASS_${widget.parkingLot.id}_${DateTime.now().millisecondsSinceEpoch}',
                                status: 'Active',
                                createdAt: DateTime.now(),
                              );

                              await resRepo.createReservation(newRes);
                              ref.read(activeReservationProvider.notifier).state = newRes;

                              if (context.mounted) {
                                Navigator.pop(context); // Close bottom sheet
                                showDialog(
                                  context: context,
                                  builder: (ctx) => QrPassDialog(reservation: newRes),
                                );
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(color: theme.colorScheme.onSurfaceVariant),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
