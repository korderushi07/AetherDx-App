import 'package:flutter/material.dart';
import 'package:maroapp/state/app_state.dart';
import 'package:maroapp/core/theme/colors.dart';
import 'package:maroapp/core/theme/typography.dart';
import 'package:maroapp/core/theme/spacing.dart';
import 'package:maroapp/core/theme/radius.dart';
import 'package:maroapp/core/widgets/app_button.dart';
import 'package:maroapp/core/widgets/app_card.dart';
import 'package:maroapp/core/widgets/section_title.dart';
import 'package:maroapp/core/theme/motion.dart';
import 'package:maroapp/core/widgets/animations.dart';
import 'result_screen.dart';
import 'educational_screen.dart';

class DashboardScreen extends StatelessWidget {
  final VoidCallback onUploadNailImagePressed;

  const DashboardScreen({
    super.key,
    required this.onUploadNailImagePressed,
  });

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning 👋';
    } else if (hour < 17) {
      return 'Good Afternoon 👋';
    } else {
      return 'Good Evening 👋';
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
                  // 1. Smart AI Assistant Greeting
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FadeSlideWidget(
                        delay: const Duration(milliseconds: 60),
                        slideDistance: -AetherMotion.slideDistanceSmall,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getGreeting(),
                              style: AppTypography.caption,
                            ),
                            const SizedBox(height: AppSpacing.gapSmall),
                            Text(
                              appState.name,
                              style: AppTypography.screenTitle,
                            ),
                            const SizedBox(height: AppSpacing.gapSmall),
                            const Row(
                              children: [
                                Icon(Icons.auto_awesome_rounded, color: AppColors.primary, size: 14),
                                SizedBox(width: 4),
                                Text(
                                  'AI Nail Health Assistant',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Ready to analyze your nail health.',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Circular Notification Icon (fades in, 0ms delay, no slide)
                      FadeSlideWidget(
                        delay: Duration.zero,
                        slideDistance: 0,
                        child: Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.cardBg,
                                shape: BoxShape.circle,
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              child: const Icon(
                                Icons.notifications_none_rounded,
                                color: AppColors.textPrimary,
                                size: 22,
                              ),
                            ),
                            Positioned(
                              right: 3,
                              top: 3,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: AppColors.error,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sectionSpace),

                  // 2. Hero Section (AI Nail Scan)
                  FadeSlideWidget(
                    delay: const Duration(milliseconds: 120),
                    slideDistance: AetherMotion.slideDistanceSmall,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const EducationalScreen()),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.secondaryBg,
                          borderRadius: AppRadius.cardBorderRadius,
                          border: Border.all(color: const Color(0xFFBBEBF2), width: 1.5),
                        ),
                        padding: const EdgeInsets.all(AppSpacing.cardInternalPadding),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // AI Powered Badges
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.verified, color: AppColors.primary, size: 10),
                                            SizedBox(width: 4),
                                            Text(
                                              'AI Powered',
                                              style: TextStyle(
                                                fontSize: 9,
                                                fontWeight: FontWeight.w800,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: 0.6),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Text(
                                          'Est. Time: 5s',
                                          style: TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'AI Nail Scan',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.primary,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Upload a nail image for instant AI disease detection.',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.primary,
                                      height: 1.3,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  AppButton(
                                    text: 'Start AI Scan',
                                    icon: Icons.camera_alt_outlined,
                                    onPressed: onUploadNailImagePressed,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Compact Scanning Graphic Illustration
                            Expanded(
                              flex: 3,
                              child: Container(
                                height: 120,
                                decoration: BoxDecoration(
                                  borderRadius: AppRadius.imageBorderRadius,
                                  color: Colors.white.withValues(alpha: 0.4),
                                ),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: AppRadius.imageBorderRadius,
                                      child: Image.asset(
                                        'assets/images/nail_scan_illustration.png',
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: AppRadius.imageBorderRadius,
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            AppColors.primary.withValues(alpha: 0.15),
                                            Colors.transparent,
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sectionSpace),

                  // Health Overview Heading
                  FadeSlideWidget(
                    delay: const Duration(milliseconds: 180),
                    child: const SectionTitle(title: 'Health Overview'),
                  ),
                  const SizedBox(height: AppSpacing.gapMedium),

                  // Health Overview Stats Row 1
                  FadeSlideWidget(
                    delay: const Duration(milliseconds: 230),
                    child: Row(
                      children: [
                        _buildStatCard('Current Risk', 'Low', AppColors.success, bg: const Color(0xFFDCFCE7)),
                        const SizedBox(width: AppSpacing.cardSpace),
                        _buildStatCard('Last Scan', 'Yesterday', AppColors.textPrimary),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.cardSpace),

                  // Health Overview Stats Row 2
                  FadeSlideWidget(
                    delay: const Duration(milliseconds: 280),
                    child: Row(
                      children: [
                        _buildStatCard('Total Scans', '12', AppColors.textPrimary),
                        const SizedBox(width: AppSpacing.cardSpace),
                        _buildStatCard('AI Accuracy', '99%', AppColors.primary, bg: AppColors.secondaryBg),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sectionSpace),

                  // Latest Analysis section
                  FadeSlideWidget(
                    delay: const Duration(milliseconds: 330),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionTitle(title: 'Latest Analysis'),
                        const SizedBox(height: AppSpacing.gapMedium),
                        if (!appState.hasScans)
                          _buildEmptyStateCard(context)
                        else
                          _buildLatestAnalysisCard(context),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sectionSpace),

                  // AI Status Card
                  FadeSlideWidget(
                    delay: const Duration(milliseconds: 380),
                    child: _buildAIStatusCard(context, appState),
                  ),
                  const SizedBox(height: AppSpacing.sectionSpace),

                  // Daily Health Tip Card
                  FadeSlideWidget(
                    delay: const Duration(milliseconds: 430),
                    child: _buildDailyTipCard(context),
                  ),
                  const SizedBox(height: AppSpacing.sectionSpace),

                  // Recent Activity section
                  if (appState.hasScans) ...[
                    FadeSlideWidget(
                      delay: const Duration(milliseconds: 480),
                      child: const SectionTitle(title: 'Recent Activity'),
                    ),
                    const SizedBox(height: AppSpacing.gapMedium),
                    FadeSlideWidget(
                      delay: const Duration(milliseconds: 530),
                      child: _buildRecentActivitySection(),
                    ),
                  ],
                  const SizedBox(height: 80),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // --- Widget helper builders ---

  Widget _buildStatCard(String label, String value, Color textColor, {Color bg = Colors.white}) {
    return Expanded(
      child: AppCard(
        backgroundColor: bg,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTypography.caption,
            ),
            const SizedBox(height: AppSpacing.gapSmall),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: textColor,
              ),
            ),
          ],
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
              // Image Thumbnail with rounded corners
              ClipRRect(
                borderRadius: AppRadius.imageBorderRadius,
                child: Image.asset(
                  'assets/images/nail_analysis_result.png',
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              // Disease Name & Date details
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
                        // Status badge (Mild)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: const BoxDecoration(
                            color: Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: const Text(
                            'Mild',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: AppColors.warning,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Yesterday',
                      style: AppTypography.caption,
                    ),
                    const SizedBox(height: 6),
                    const Row(
                      children: [
                        Text(
                          'CONFIDENCE',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textSecondary,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          '92%',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          // Animated horizontal progress indicator
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const AnimatedProgressBar(
              value: 0.92,
              minHeight: 8,
              backgroundColor: Color(0xFFF1F5F9),
              valueColor: AppColors.primary,
            ),
          ),
          const SizedBox(height: 20),
          // View Full Report button spanning full width
          AppButton(
            text: 'View Full Report',
            onPressed: () {
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
          ),
        ],
      ),
    );
  }

  Widget _buildAIStatusCard(BuildContext context, AppState appState) {
    return AppCard(
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: AppColors.secondaryBg,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.psychology_outlined,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'AI Assistant',
                  style: AppTypography.cardTitle,
                ),
                const SizedBox(height: 2),
                const Text(
                  'Ready to Analyze',
                  style: AppTypography.caption,
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () {
                    appState.hasScans = !appState.hasScans;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(appState.hasScans ? 'Switched to Analyzed State' : 'Switched to Onboarding Empty State'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  child: const Text(
                    'Model: AtherDx AI v2  [tap to toggle]',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Live status pulse marker
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'Online',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDailyTipCard(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text(
                '💡',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(width: 8),
              Text(
                'Daily Nail Health Tip',
                style: AppTypography.cardTitle,
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Keep nails dry after washing to reduce fungal growth.',
            style: TextStyle(
              fontSize: 13.5,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const EducationalScreen()),
              );
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Read More',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.primary),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivitySection() {
    return AppCard(
      child: Column(
        children: [
          _buildRecentActivityItem('Scan Completed', 'Yesterday'),
          const Divider(color: Color(0xFFF1F5F9), thickness: 1.5, height: 24),
          _buildRecentActivityItem('Report Downloaded', '3 days ago'),
          const Divider(color: Color(0xFFF1F5F9), thickness: 1.5, height: 24),
          _buildRecentActivityItem('Health Tip Viewed', '1 week ago'),
        ],
      ),
    );
  }

  Widget _buildRecentActivityItem(String title, String subtitle) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check,
            color: AppColors.success,
            size: 14,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: AppTypography.caption,
              ),
            ],
          ),
        ),
      ],
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
              color: Color(0xFFF1F5F9),
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
            onPressed: onUploadNailImagePressed,
          ),
        ],
      ),
    );
  }
}
