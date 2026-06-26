import 'package:flutter/material.dart';
import 'package:maroapp/core/theme/colors.dart';
import 'package:maroapp/core/theme/typography.dart';
import 'package:maroapp/core/theme/radius.dart';
import 'package:maroapp/core/widgets/app_button.dart';
import 'package:maroapp/core/widgets/app_card.dart';
import 'image_quality_alert_screen.dart';
import 'analyzing_nail_screen.dart';

class ScanNailScreen extends StatefulWidget {
  final VoidCallback onBackPressed;

  const ScanNailScreen({
    super.key,
    required this.onBackPressed,
  });

  @override
  State<ScanNailScreen> createState() => _ScanNailScreenState();
}

class _ScanNailScreenState extends State<ScanNailScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.08, end: 0.92).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Action Row (Back button, Title header, Help button)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Circular Back Button
                  GestureDetector(
                    onTap: widget.onBackPressed,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: AppColors.textPrimary,
                        size: 20,
                      ),
                    ),
                  ),
                  // Title Header
                  const Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Scan Nail',
                          style: AppTypography.screenTitle,
                        ),
                        SizedBox(height: 4),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Capture a clear image of your nail for accurate analysis',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Circular Help Button
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.help_outline_rounded,
                      color: AppColors.textPrimary,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Viewfinder Scanner Section Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: AppColors.secondaryBg,
                  borderRadius: AppRadius.cardBorderRadius,
                ),
                child: Center(
                  child: Container(
                    width: 230,
                    height: 230,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: AppRadius.cardBorderRadius,
                    ),
                    child: ClipRRect(
                      borderRadius: AppRadius.cardBorderRadius,
                      child: Stack(
                        children: [
                          // 1. Centered Nail Image
                          Positioned.fill(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Image.asset(
                                'assets/images/nail_to_scan.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          // 2. Corner Viewfinder Brackets
                          Positioned.fill(
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final double bracketSize = 24.0;
                                final double stroke = 4.0;
                                const Color bracketColor = AppColors.primary;

                                return Stack(
                                  children: [
                                    // Top Left
                                    Positioned(
                                      top: 16,
                                      left: 16,
                                      child: Container(
                                        width: bracketSize,
                                        height: bracketSize,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            top: BorderSide(color: bracketColor, width: stroke),
                                            left: BorderSide(color: bracketColor, width: stroke),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Top Right
                                    Positioned(
                                      top: 16,
                                      right: 16,
                                      child: Container(
                                        width: bracketSize,
                                        height: bracketSize,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            top: BorderSide(color: bracketColor, width: stroke),
                                            right: BorderSide(color: bracketColor, width: stroke),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Bottom Left
                                    Positioned(
                                      bottom: 16,
                                      left: 16,
                                      child: Container(
                                        width: bracketSize,
                                        height: bracketSize,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(color: bracketColor, width: stroke),
                                            left: BorderSide(color: bracketColor, width: stroke),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Bottom Right
                                    Positioned(
                                      bottom: 16,
                                      right: 16,
                                      child: Container(
                                        width: bracketSize,
                                        height: bracketSize,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(color: bracketColor, width: stroke),
                                            right: BorderSide(color: bracketColor, width: stroke),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          // 3. Glowing Laser Scanner Line Animation
                          Positioned.fill(
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return AnimatedBuilder(
                                  animation: _animation,
                                  builder: (context, child) {
                                    return Stack(
                                      children: [
                                        Positioned(
                                          top: constraints.maxHeight * _animation.value,
                                          left: 20,
                                          right: 20,
                                          child: Container(
                                            height: 3,
                                            decoration: BoxDecoration(
                                              color: AppColors.primary,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: AppColors.primary.withValues(alpha: 0.8),
                                                  blurRadius: 8,
                                                  spreadRadius: 2,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Instructions Panel Card
              AppCard(
                child: Column(
                  children: [
                    // Good Lighting Instruction row
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: AppColors.secondaryBg,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.wb_sunny_outlined,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Good Lighting',
                                style: AppTypography.cardTitle,
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Use natural light for better results',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14.0),
                      child: Divider(color: Color(0xFFF1F5F9), thickness: 1),
                    ),
                    // Keep Steady Instruction row
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: AppColors.secondaryBg,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.back_hand_outlined,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Keep Steady',
                                style: AppTypography.cardTitle,
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Hold your phone steady and clear',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Capture Image Button
              AppButton(
                text: 'Capture Image',
                icon: Icons.camera_alt_outlined,
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    builder: (BuildContext context) {
                      return SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                'Simulation Control',
                                style: AppTypography.sectionHeading,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Choose a quality check outcome to test the user flows:',
                                style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              AppButton(
                                text: 'Simulate Success (Good Quality)',
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (_) => const AnalyzingNailScreen()),
                                  );
                                },
                              ),
                              const SizedBox(height: 12),
                              AppButton(
                                text: 'Simulate Alert (Poor Quality)',
                                isPrimary: false,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).push(
                                    MaterialPageRoute(builder: (_) => const ImageQualityAlertScreen()),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 80), // spacer for bottom nav bar
            ],
          ),
        ),
      ),
    );
  }
}
