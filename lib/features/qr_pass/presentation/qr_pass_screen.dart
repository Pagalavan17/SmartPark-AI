import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/extensions/l10n_extension.dart';
import '../../../core/utils/qr_pass_helper.dart';
import '../../../core/widgets/custom_app_bar.dart';

/// Digital QR Gate Pass Screen for Entry & Exit Scanning
class QrPassScreen extends StatefulWidget {
  const QrPassScreen({super.key});

  @override
  State<QrPassScreen> createState() => _QrPassScreenState();
}

class _QrPassScreenState extends State<QrPassScreen> {
  final GlobalKey _repaintKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    const String qrDataToken = 'SMARTPARK_PASS_SP-982341_SLOT_A14';
    final l10n = context.l10n;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        title: l10n.qrPassTitle,
        onBackPressed: () => context.go('/home'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        child: Column(
          children: [
            // Warning Banner
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l10n.scanQrAtGate,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.warning,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Premium Digital Parking Ticket Card wrapped in RepaintBoundary
            RepaintBoundary(
              key: _repaintKey,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? Colors.black45 : AppColors.shadow,
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Ticket Top Badge Header
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(AppConstants.cardBorderRadius),
                          topRight: Radius.circular(AppConstants.cardBorderRadius),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.local_parking, color: Colors.white, size: 22),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Metro Cyber Park',
                              style: AppTextStyles.headingSmall.copyWith(color: Colors.white, fontSize: 16),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              l10n.passActive.toUpperCase(),
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.success,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // QR Code Generator Widget
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          QrImageView(
                            data: qrDataToken,
                            version: QrVersions.auto,
                            size: 200.0,
                            eyeStyle: const QrEyeStyle(
                              eyeShape: QrEyeShape.square,
                              color: AppColors.primary,
                            ),
                            dataModuleStyle: QrDataModuleStyle(
                              dataModuleShape: QrDataModuleShape.square,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '${l10n.bookingId}: #SP-982341',
                            style: AppTextStyles.caption.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Divider(height: 1, color: theme.colorScheme.outline),

                    // Ticket Particulars Breakdown
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              _buildTicketInfo(l10n.selectVehicle, 'TN 01 AB 1234', context),
                              const SizedBox(width: 12),
                              _buildTicketInfo(l10n.parkingLocation, 'Slot A-14', context),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              _buildTicketInfo(l10n.startTime, '10:00 AM', context),
                              const SizedBox(width: 12),
                              _buildTicketInfo(l10n.endTime, '02:00 PM', context),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Action Quick Tools Row (Download, Share, Navigate)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionIconButton(
                  context: context,
                  icon: Icons.download_rounded,
                  label: l10n.download,
                  onTap: () {
                    QrPassHelper.downloadPass(
                      context: context,
                      repaintKey: _repaintKey,
                      passId: 'SP-982341',
                    );
                  },
                ),
                _buildActionIconButton(
                  context: context,
                  icon: Icons.share_rounded,
                  label: l10n.share,
                  onTap: () {
                    QrPassHelper.sharePass(
                      context: context,
                      repaintKey: _repaintKey,
                      passId: 'SP-982341',
                      parkingName: 'Metro Cyber Park',
                    );
                  },
                ),
                _buildActionIconButton(
                  context: context,
                  icon: Icons.directions_outlined,
                  label: l10n.navigate,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${l10n.startNavigation}...')),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketInfo(String label, String value, BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(color: theme.colorScheme.onSurfaceVariant),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildActionIconButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: isDark ? Colors.black26 : AppColors.shadow, blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface)),
      ],
    );
  }
}
