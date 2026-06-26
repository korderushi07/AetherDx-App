import 'package:flutter/material.dart';
import 'package:maroapp/state/app_state.dart';
import 'package:maroapp/core/theme/colors.dart';
import 'package:maroapp/core/theme/typography.dart';
import 'package:maroapp/core/theme/spacing.dart';
import 'package:maroapp/core/theme/radius.dart';
import 'package:maroapp/core/widgets/app_button.dart';
import 'package:maroapp/core/widgets/app_card.dart';
import 'package:maroapp/core/theme/motion.dart';
import 'package:maroapp/core/widgets/animations.dart';
import 'result_screen.dart';

class DashboardScreen extends StatefulWidget {
  final VoidCallback onUploadNailImagePressed;

  const DashboardScreen({
    super.key,
    required this.onUploadNailImagePressed,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double _heroScale = 1.0;
  bool _tipDismissed = false;

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppState appState = AppState();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: appState,
          builder: (context, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Unified Header Row
                  FadeSlideWidget(
                    delay: const Duration(milliseconds: 60),
                    slideDistance: -AetherMotion.slideDistanceSmall,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            // 36px Circular user initials avatar
                            Container(
                              width: 36,
                              height: 36,
                              decoration: const BoxDecoration(
                                color: AppColors.secondaryBg,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                appState.name.substring(0, 1),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${_getGreeting()}, ${appState.name}',
                                  style: AppTypography.heading2.copyWith(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: const BoxDecoration(
                                        color: AppColors.ai,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Text(
                                      'AI Engine Ready',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.notifications_none_rounded,
                            color: AppColors.textPrimary,
                            size: 24,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sectionSpace),

                  // 2. Primary Hero Card (Start AI Scan)
                  FadeSlideWidget(
                    delay: const Duration(milliseconds: 120),
                    child: GestureDetector(
                      onTapDown: (_) => setState(() => _heroScale = 0.97),
                      onTapUp: (_) {
                        setState(() => _heroScale = 1.0);
                        widget.onUploadNailImagePressed();
                      },
                      onTapCancel: () => setState(() => _heroScale = 1.0),
                      child: AnimatedScale(
                        scale: _heroScale,
                        duration: const Duration(milliseconds: 120),
                        curve: Curves.easeOutCubic,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: AppRadius.cardBorderRadius,
                            gradient: const RadialGradient(
                              colors: [
                                Color(0x1F6366F1), // Indigo overlay (12% opacity)
                                AppColors.primary,
                              ],
                              radius: 0.8,
                              center: Alignment.center,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF0C4A6E).withOpacity(0.12),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              )
                            ],
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'START AI SCAN',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Analyze nail health instantly',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF93C5FD),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sectionSpace),

                  // 3. Latest Analysis (Above the Fold)
                  FadeSlideWidget(
                    delay: const Duration(milliseconds: 180),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'LATEST ANALYSIS',
                          style: AppTypography.overline,
                        ),
                        const SizedBox(height: AppSpacing.gapMedium),
                        if (!appState.hasScans)
                          _buildEmptyStateCard(context)
                        else
                          _buildLatestAnalysisCard(context),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sectionSpace),

                  // 4. Health Overview Stats
                  FadeSlideWidget(
                    delay: const Duration(milliseconds: 240),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'HEALTH OVERVIEW',
                          style: AppTypography.overline,
                        ),
                        const SizedBox(height: AppSpacing.gapMedium),
                        _buildHealthOverviewCard(appState),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sectionSpace),

                  // 5. Daily Health Tip Alert Banner
                  if (!_tipDismissed)
                    FadeSlideWidget(
                      delay: const Duration(milliseconds: 300),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryBg,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.border, width: 0.5),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info_outline_rounded,
                              color: AppColors.textPrimary,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'Nail health tip: moisturize cuticles nightly to prevent splits.',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => setState(() => _tipDismissed = true),
                              child: const Icon(
                                Icons.close_rounded,
                                color: AppColors.textSecondary,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 80),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLatestAnalysisCard(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: AppRadius.imageBorderRadius,
                child: Image.asset(
                  'assets/images/nail_analysis_result.png',
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Fungal Infection',
                          style: AppTypography.cardTitle,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const ResultScreen(
                                  conditionName: 'Fungal Infection',
                                  matchPercentage: 92,
                                  confidenceLabel: 'Mild',
                                  description: 'A common fungal infection of the nail, causing discoloration, scaling, and thickening. It is often caused by dermatophytes.',
                                  keySigns: 'Discoloration, scaling under the nail, thickening, and crumbly edges',
                                  nextSteps: 'Consult a dermatologist to confirm diagnosis and obtain prescription antifungal medication',
                                  careTips: 'Keep nails dry and clean, wear breathable socks, and avoid sharing nail clippers',
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            'View →',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '92% Match Probability',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(2)),
            child: AnimatedProgressBar(
              value: 0.92,
              minHeight: 4,
              backgroundColor: AppColors.secondaryBg,
              valueColor: AppColors.ai,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthOverviewCard(AppState appState) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Row(
        children: [
          Expanded(
            child: _buildMetricCell(
              value: 'Low',
              label: 'RISK LEVEL',
              valueColor: AppColors.success,
            ),
          ),
          Container(width: 1, height: 48, color: AppColors.border),
          Expanded(
            child: _buildMetricCell(
              value: appState.hasScans ? '12' : '0',
              label: 'TOTAL SCANS',
              valueColor: AppColors.textPrimary,
            ),
          ),
          Container(width: 1, height: 48, color: AppColors.border),
          Expanded(
            child: _buildMetricCell(
              value: '99%',
              label: 'AI ACCURACY',
              valueColor: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCell({
    required String value,
    required String label,
    required Color valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTypography.overline.copyWith(fontSize: 9),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyStateCard(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.secondaryBg,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.camera_enhance_outlined,
              color: AppColors.primary,
              size: 32,
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'No Scan Yet',
            style: AppTypography.cardTitle,
          ),
          const SizedBox(height: 8),
          const Text(
            'Upload your first nail image to receive an AI-powered diagnosis.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          AppButton(
            text: 'Start First Scan',
            onPressed: widget.onUploadNailImagePressed,
          ),
        ],
      ),
    );
  }
}
