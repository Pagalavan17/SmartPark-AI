import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/extensions/l10n_extension.dart';
import '../../../../core/utils/qr_pass_helper.dart';
import '../../../../models/reservation_model.dart';

/// Production Digital QR Parking Pass Dialog Widget
class QrPassDialog extends StatefulWidget {
  final ReservationModel reservation;

  const QrPassDialog({
    super.key,
    required this.reservation,
  });

  @override
  State<QrPassDialog> createState() => _QrPassDialogState();
}

class _QrPassDialogState extends State<QrPassDialog> {
  final GlobalKey _repaintKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final DateTime expiryTime = widget.reservation.arrivalTime.add(Duration(hours: widget.reservation.durationInHours));

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.verified, color: AppColors.success, size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.qrPassTitle,
                      style: AppTextStyles.headingSmall.copyWith(fontSize: 18, color: theme.colorScheme.onSurface),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, size: 20, color: theme.colorScheme.onSurfaceVariant),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Divider(height: 16, color: theme.colorScheme.outline),

              // RepaintBoundary wrapping complete QR Pass Card
              RepaintBoundary(
                key: _repaintKey,
                child: Container(
                  color: theme.colorScheme.surface,
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.reservation.parkingName,
                        style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.slotAllocatedLabel(widget.reservation.allocatedSlot),
                        style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),

                      // QR Code rendering
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkInputSurface : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [BoxShadow(color: isDark ? Colors.black26 : AppColors.shadow, blurRadius: 10)],
                        ),
                        child: QrImageView(
                          data: widget.reservation.qrCodeToken,
                          version: QrVersions.auto,
                          size: 180.0,
                          eyeStyle: const QrEyeStyle(
                            eyeShape: QrEyeShape.square,
                            color: AppColors.primary,
                          ),
                          dataModuleStyle: QrDataModuleStyle(
                            dataModuleShape: QrDataModuleShape.square,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: widget.reservation.reservationId));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.copiedToClipboard)),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              l10n.passIdLabel(widget.reservation.reservationId),
                              style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
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
                          color: theme.colorScheme.surfaceContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            _buildRow(l10n.selectVehicle, widget.reservation.vehicleNumber, theme: theme),
                            _buildRow(l10n.startTime, '${widget.reservation.arrivalTime.hour}:${widget.reservation.arrivalTime.minute.toString().padLeft(2, '0')}', theme: theme),
                            _buildRow(l10n.validUntil, '${expiryTime.hour}:${expiryTime.minute.toString().padLeft(2, '0')}', theme: theme),
                            _buildRow(l10n.reservation, widget.reservation.status, isSuccess: true, theme: theme),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Action Buttons Row (Download, Share, View Full Pass)
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: AppColors.primary, width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        QrPassHelper.downloadPass(
                          context: context,
                          repaintKey: _repaintKey,
                          passId: widget.reservation.reservationId,
                        );
                      },
                      child: const Icon(Icons.download_rounded, color: AppColors.primary, size: 20),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: AppColors.primary, width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        QrPassHelper.sharePass(
                          context: context,
                          repaintKey: _repaintKey,
                          passId: widget.reservation.reservationId,
                          parkingName: widget.reservation.parkingName,
                        );
                      },
                      child: const Icon(Icons.share_outlined, color: AppColors.primary, size: 20),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 3,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        context.go('/qr-pass');
                      },
                      icon: const Icon(Icons.qr_code_scanner, size: 16),
                      label: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          l10n.viewFullPass,
                          maxLines: 1,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
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

  Widget _buildRow(String label, String value, {bool isSuccess = false, required ThemeData theme}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: theme.colorScheme.onSurfaceVariant),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.bold,
                color: isSuccess ? AppColors.success : theme.colorScheme.onSurface,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
