import 'package:flutter/material.dart';
import 'package:maroapp/core/theme/colors.dart';
import 'package:maroapp/core/theme/typography.dart';
import 'package:maroapp/core/theme/spacing.dart';
import 'package:maroapp/core/widgets/app_button.dart';
import 'package:maroapp/core/widgets/app_card.dart';

class ImageQualityAlertScreen extends StatelessWidget {
  const ImageQualityAlertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
            vertical: AppSpacing.screenPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              // Header title
              const Text(
                'Image Quality Alert',
                style: AppTypography.heading1,
              ),
              const SizedBox(height: 8),
              // Header description
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "We couldn't process the image. Please review the suggestions below.",
                  textAlign: TextAlign.center,
                  style: AppTypography.body,
                ),
              ),
              const SizedBox(height: 32),

              // Illustration Card
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.secondaryBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Silhouette of smartphone
                    Container(
                      width: 80,
                      height: 130,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border, width: 2),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(15, 23, 42, 0.04),
                            blurRadius: 16.0,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: const BoxDecoration(
                              color: AppColors.secondaryBg,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Icon(
                            Icons.camera_alt_outlined,
                            size: 26,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                    // Red X overlay badge
                    Positioned(
                      right: MediaQuery.of(context).size.width * 0.35,
                      top: 45,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Guidance Card
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _buildGuidanceItem(
                      icon: Icons.wb_sunny_outlined,
                      title: 'Better Lighting',
                      description: 'Use natural or bright indoor light',
                    ),
                    const Divider(height: 1, color: AppColors.border),
                    _buildGuidanceItem(
                      icon: Icons.crop_free_outlined,
                      title: 'Refocus Camera',
                      description: 'Tap screen to focus on the nail',
                    ),
                    const Divider(height: 1, color: AppColors.border),
                    _buildGuidanceItem(
                      icon: Icons.zoom_in_outlined,
                      title: 'Move Closer',
                      description: 'Ensure the nail fills the frame',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Try Again Button
              AppButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icons.refresh_outlined,
                text: 'Try Again',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuidanceItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.secondaryBg,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(
              icon,
              color: AppColors.textPrimary,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.cardTitle,
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: AppTypography.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
