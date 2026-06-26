import 'package:flutter/material.dart';
import 'package:maroapp/core/theme/colors.dart';
import 'package:maroapp/core/theme/typography.dart';
import 'package:maroapp/core/theme/shadows.dart';
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
                style: AppTypography.screenTitle,
              ),
              const SizedBox(height: 8),
              // Header description
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "We couldn't analyze the image clearly. Please review the guidance below.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Center Illustration Container
              AppCard(
                backgroundColor: AppColors.secondaryBg,
                height: 250,
                child: Center(
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Dashed Circle Orbit
                        CustomPaint(
                          size: const Size(160, 160),
                          painter: _DashedCirclePainter(),
                        ),
                        // Center Phone Icon Card
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [AppShadows.soft],
                          ),
                          child: const Icon(
                            Icons.phone_android_outlined,
                            size: 38,
                            color: AppColors.primary,
                          ),
                        ),
                        // Top-Right Badge: Better Lighting (Angle: -45 deg)
                        // x = 100 + 80 * cos(-pi/4) - 20 = 136.5
                        // y = 100 + 80 * sin(-pi/4) - 20 = 23.5
                        Positioned(
                          left: 136.5,
                          top: 23.5,
                          child: _buildOrbitBadge(Icons.wb_sunny_outlined),
                        ),
                        // Bottom-Right Badge: Move Closer (Angle: 45 deg)
                        // x = 100 + 80 * cos(pi/4) - 20 = 136.5
                        // y = 100 + 80 * sin(pi/4) - 20 = 136.5
                        Positioned(
                          left: 136.5,
                          top: 136.5,
                          child: _buildOrbitBadge(Icons.zoom_in_outlined),
                        ),
                        // Bottom-Left Badge: Refocus (Angle: 135 deg)
                        // x = 100 + 80 * cos(3*pi/4) - 20 = 23.5
                        // y = 100 + 80 * sin(3*pi/4) - 20 = 136.5
                        Positioned(
                          left: 23.5,
                          top: 136.5,
                          child: _buildOrbitBadge(Icons.crop_free_outlined),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Guidance List Card
              AppCard(
                child: Column(
                  children: [
                    _buildGuidanceItem(
                      icon: Icons.wb_sunny_outlined,
                      title: 'Better lighting',
                      description: 'Use natural light for better results',
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14.0),
                      child: Divider(color: Color(0xFFF1F5F9), thickness: 1),
                    ),
                    _buildGuidanceItem(
                      icon: Icons.crop_free_outlined,
                      title: 'Refocus',
                      description: 'Hold your phone steady and tap to focus',
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14.0),
                      child: Divider(color: Color(0xFFF1F5F9), thickness: 1),
                    ),
                    _buildGuidanceItem(
                      icon: Icons.zoom_in_outlined,
                      title: 'Move closer',
                      description: 'Ensure the nail fills the scanning frame',
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

  Widget _buildOrbitBadge(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.secondaryBg,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [AppShadows.soft],
      ),
      child: Icon(
        icon,
        size: 20,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildGuidanceItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: AppColors.secondaryBg,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
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
                style: AppTypography.cardTitle.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: AppTypography.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final Paint paint = Paint()
      ..color = AppColors.placeholder
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final double dashWidth = 6.0;
    final double dashSpace = 4.0;
    double currentAngle = 0.0;

    while (currentAngle < 2 * 3.1415926535) {
      final double sweepAngle = dashWidth / radius;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(radius, radius), radius: radius),
        currentAngle,
        sweepAngle,
        false,
        paint,
      );
      currentAngle += (dashWidth + dashSpace) / radius;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
