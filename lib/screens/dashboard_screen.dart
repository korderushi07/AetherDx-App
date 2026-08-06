import 'package:flutter/material.dart';
import 'package:aetherdx/state/app_state.dart';
import 'package:aetherdx/core/theme/colors.dart';
import 'package:aetherdx/core/theme/typography.dart';
import 'package:aetherdx/core/theme/spacing.dart';
import 'package:aetherdx/core/theme/radius.dart';
import 'package:aetherdx/core/widgets/app_card.dart';
import 'package:aetherdx/core/widgets/section_title.dart';
import 'package:aetherdx/core/theme/motion.dart';
import 'package:aetherdx/core/widgets/animations.dart';
import 'educational_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aetherdx/core/localization/translations.dart';

class DashboardScreen extends StatelessWidget {
  final VoidCallback onUploadNailImagePressed;
  final VoidCallback onProfilePressed;

  const DashboardScreen({
    super.key,
    required this.onUploadNailImagePressed,
    required this.onProfilePressed,
  });

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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Avatar on left
                      FadeSlideWidget(
                        delay: Duration.zero,
                        slideDistance: 0,
                        child: GestureDetector(
                          onTap: onProfilePressed,
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
                            ),
                            child: appState.buildAvatarWidget(22),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  
                  // Text greeting below avatar
                  FadeSlideWidget(
                    delay: const Duration(milliseconds: 60),
                    slideDistance: -AetherMotion.slideDistanceSmall,
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.outfit(
                          fontSize: 26,
                          color: const Color(0xFF94A3B8),
                          fontWeight: FontWeight.w300,
                          letterSpacing: -0.5,
                        ),
                        children: [
                          TextSpan(text: 'Hello, '.tr()),
                          TextSpan(
                            text: '${appState.name.trim().split(RegExp(r'\s+')).first} !',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1F2937),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sectionSpace),

                  // 2. Hero Section (AI Nail Scan)
                  FadeSlideWidget(
                    delay: const Duration(milliseconds: 120),
                    slideDistance: AetherMotion.slideDistanceSmall,
                    child: GestureDetector(
                      onTap: onUploadNailImagePressed,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF0F3E42), Color(0xFF1B6E74)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: AppRadius.cardBorderRadius,
                          border: Border.all(color: const Color(0xFF238E95), width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF155E63).withValues(alpha: 0.15),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
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
                                          color: Colors.white.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          'Est. Time: 5s'.tr(),
                                          style: const TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'AI Nail Scan'.tr(),
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Upload a nail image for instant disease detection.'.tr(),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFFE2F3F5),
                                      height: 1.35,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  Container(
                                    width: 145,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(19),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.08),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: onUploadNailImagePressed,
                                        borderRadius: BorderRadius.circular(19),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Start Scan'.tr(),
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w800,
                                                  color: AppColors.primary,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              const Icon(
                                                Icons.arrow_forward_rounded,
                                                size: 18,
                                                color: AppColors.primary,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
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

                  // Clinical Trust Banner
                  FadeSlideWidget(
                    delay: const Duration(milliseconds: 230),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFF2FAF9), // Ultra-light soft teal matching secondaryBg
                            Color(0xFFFFFFFF), // Pure white
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/result_header_pattern.png'),
                          fit: BoxFit.cover,
                          opacity: 0.05, // Subtle pattern transparency
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(36),
                          topRight: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(36),
                        ),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.18), 
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 54,
                                height: 54,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.1),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(6),
                                    bottomLeft: Radius.circular(6),
                                    bottomRight: Radius.circular(20),
                                  ),
                                  border: Border.all(
                                    color: AppColors.primary.withValues(alpha: 0.22),
                                    width: 1.5,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.health_and_safety_rounded, // Medical cross shield icon
                                  color: AppColors.primary,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Trusted by Doctors'.tr(),
                                      style: GoogleFonts.outfit(
                                        fontSize: 19,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFF0F3E42), // Deep rich teal
                                        letterSpacing: -0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Tested on 1200+ Patients'.tr(),
                                      style: GoogleFonts.outfit(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primary,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Approved by Lata Mangeshkar Hospital, Nagpur'.tr(),
                                      style: GoogleFonts.outfit(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textSecondary,
                                        letterSpacing: 0.1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 22),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: _buildTrustBadge('94.4%', 'Accuracy', align: CrossAxisAlignment.start)),
                              Container(
                                height: 24,
                                width: 1.5,
                                color: AppColors.primary.withValues(alpha: 0.12),
                              ),
                              Expanded(child: _buildTrustBadge('1,200+', 'Clinical Cases', align: CrossAxisAlignment.center)),
                              Container(
                                height: 24,
                                width: 1.5,
                                color: AppColors.primary.withValues(alpha: 0.12),
                              ),
                              Expanded(child: _buildTrustBadge('HIPAA', 'Secure Storage', align: CrossAxisAlignment.end)),
                            ],
                          ),
                        ],
                      ),
                    ),
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
                      child: SectionTitle(title: 'Recent Activity'.tr()),
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






  Widget _buildDailyTipCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: AppRadius.cardBorderRadius,
        border: Border.all(color: const Color(0xFFDCFCE7), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  '💡',
                  style: TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Daily Nail Health Tip'.tr(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Keep nails dry after washing to reduce fungal growth.'.tr(),
            style: const TextStyle(
              fontSize: 13.5,
              color: AppColors.textSecondary,
              height: 1.45,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const EducationalScreen()),
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Read More'.tr(),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.primary),
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
            color: AppColors.success.withValues(alpha: 0.1),
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
                title.tr(),
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle.tr(),
                style: AppTypography.caption,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTrustBadge(String value, String label, {CrossAxisAlignment align = CrossAxisAlignment.start}) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(
          value.tr(),
          style: GoogleFonts.outfit(
            fontSize: 17,
            fontWeight: FontWeight.w600, // Reduced from w900 (bold) to w600 (semi-bold)
            color: const Color(0xFF0F3E42), // Dark deep teal
            letterSpacing: -0.3,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label.tr(),
          style: GoogleFonts.outfit(
            fontSize: 11.5,
            fontWeight: FontWeight.w400, // Reduced from w600 (semi-bold) to w400 (regular)
            color: AppColors.textSecondary,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }


}
