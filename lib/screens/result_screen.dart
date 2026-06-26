import 'package:flutter/material.dart';
import 'package:maroapp/core/theme/colors.dart';
import 'package:maroapp/core/theme/typography.dart';
import 'package:maroapp/core/theme/radius.dart';
import 'package:maroapp/core/theme/shadows.dart';
import 'package:maroapp/core/widgets/app_button.dart';
import 'package:maroapp/core/widgets/app_card.dart';
import 'specialists_screen.dart';
import 'educational_screen.dart';
import 'nutrition_lifestyle_screen.dart';

class ResultScreen extends StatelessWidget {
  final String conditionName;
  final int matchPercentage;
  final String confidenceLabel;
  final String description;
  final String keySigns;
  final String nextSteps;
  final String careTips;

  const ResultScreen({
    super.key,
    this.conditionName = 'Nail Psoriasis',
    this.matchPercentage = 78,
    this.confidenceLabel = 'High confidence',
    this.description = 'A chronic autoimmune condition that affects nail cells, causing changes in appearance.',
    this.keySigns = 'Pitting, discoloration, rough texture, and nail thickening',
    this.nextSteps = 'Consult a dermatologist for proper diagnosis and treatment',
    this.careTips = 'Keep nails moisturized, avoid trauma, and manage stress',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // 1. Top Right Abstract Pattern Image Overlay
          Positioned(
            top: -20,
            right: -20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.asset(
                'assets/images/result_header_pattern.png',
                width: 190,
                height: 190,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 2. Main Content Stack
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header actions & titles
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back Button
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
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
                      const SizedBox(height: 28),
                      // Results upper text
                      const Text(
                        'RESULTS',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Your Results header
                      const Text(
                        'Your Results',
                        style: AppTypography.screenTitle,
                      ),
                      const SizedBox(height: 4),
                      // Analysis complete subtitle
                      const Text(
                        'AI analysis complete',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // White Sheet Container
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 24.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: AppRadius.cardBorderRadius,
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [AppShadows.soft],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 78% Match Card Banner
                                AppCard(
                                  backgroundColor: AppColors.secondaryBg,
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '$matchPercentage% match',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w800,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            confidenceLabel,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: AppColors.textSecondary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Security shield icon circular badge
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: const BoxDecoration(
                                          color: AppColors.primary,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.verified_user_rounded,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Diagnosis title & description
                                Text(
                                  conditionName,
                                  style: AppTypography.sectionHeading,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  description,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    const Icon(Icons.menu_book_rounded, color: AppColors.primary, size: 16),
                                    const SizedBox(width: 6),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(builder: (_) => const EducationalScreen()),
                                        );
                                      },
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size.zero,
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: const Text(
                                        'Read full health guide',
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                  child: Divider(color: Color(0xFFF1F5F9), thickness: 1.5),
                                ),

                                // Detailed list of symptoms and guides
                                _buildDetailsRow(
                                  icon: Icons.gps_fixed_rounded,
                                  title: 'Key Signs Detected',
                                  description: keySigns,
                                ),
                                const SizedBox(height: 20),
                                _buildDetailsRow(
                                  icon: Icons.gpp_maybe_outlined,
                                  title: 'Recommended Next Steps',
                                  description: nextSteps,
                                ),
                                const SizedBox(height: 20),
                                _buildDetailsRow(
                                  icon: Icons.description_outlined,
                                  title: 'General Care Tips',
                                  description: careTips,
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    const SizedBox(width: 44),
                                    const Icon(Icons.spa_outlined, color: AppColors.primary, size: 16),
                                    const SizedBox(width: 6),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(builder: (_) => const NutritionLifestyleScreen()),
                                        );
                                      },
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: Size.zero,
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: const Text(
                                        'View Nutrition & Lifestyle Suggestions',
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Fixed Bottom Button Area
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 24.0),
                          child: AppButton(
                            text: 'Book a doctor',
                            icon: Icons.calendar_today_outlined,
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const SpecialistsScreen()),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsRow({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                style: AppTypography.cardTitle,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
