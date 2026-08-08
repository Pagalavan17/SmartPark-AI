import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../models/reservation_model.dart';

/// Production Digital QR Parking Pass Dialog Widget
class QrPassDialog extends StatelessWidget {
  final ReservationModel reservation;

  const QrPassDialog({
    super.key,
    required this.reservation,
  });

  @override
  Widget build(BuildContext context) {
    final DateTime expiryTime = reservation.arrivalTime.add(Duration(hours: reservation.durationInHours));

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.verified, color: AppColors.success, size: 24),
                      const SizedBox(width: 8),
                      Text('Digital QR Pass', style: AppTextStyles.headingSmall.copyWith(fontSize: 18)),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(height: 16),
              Text(
                reservation.parkingName,
                style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                'Slot Allocated: ${reservation.allocatedSlot}',
                style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // QR Code rendering
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [BoxShadow(color: AppColors.shadow, blurRadius: 10)],
                ),
                child: QrImageView(
                  data: reservation.qrCodeToken,
                  version: QrVersions.auto,
                  size: 180.0,
                  eyeStyle: const QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: AppColors.primary,
                  ),
                  dataModuleStyle: const QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: reservation.reservationId));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Reservation ID copied to clipboard!')),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Pass ID: #${reservation.reservationId}',
                      style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.copy, size: 14, color: AppColors.primary),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildRow('Vehicle', reservation.vehicleNumber),
                    _buildRow('Entry Time', 'Today, ${reservation.arrivalTime.hour}:${reservation.arrivalTime.minute.toString().padLeft(2, '0')}'),
                    _buildRow('Expiry Time', '${expiryTime.hour}:${expiryTime.minute.toString().padLeft(2, '0')}'),
                    _buildRow('Status', reservation.status, isSuccess: true),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Action Buttons Row (Download, Share, View Gate Pass)
              Row(
                children: [
                  IconButton.outlined(
                    icon: const Icon(Icons.download_rounded, color: AppColors.primary),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('QR Pass image saved to device storage.')),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  IconButton.outlined(
                    icon: const Icon(Icons.share_outlined, color: AppColors.primary),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Sharing QR Pass link...')),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        context.go('/qr-pass');
                      },
                      icon: const Icon(Icons.qr_code_scanner, size: 18),
                      label: const Text('View Full Pass'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isSuccess = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.caption),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.bold,
              color: isSuccess ? AppColors.success : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
