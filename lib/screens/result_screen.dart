import 'package:flutter/material.dart';
import 'package:maroapp/core/theme/colors.dart';
import 'package:maroapp/core/theme/typography.dart';
import 'package:maroapp/core/widgets/app_button.dart';
import 'package:maroapp/core/widgets/app_card.dart';
import 'specialists_screen.dart';
import 'nutrition_lifestyle_screen.dart';
import '../core/widgets/animations.dart';

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
    this.conditionName = 'Mild Onychomycosis',
    this.matchPercentage = 92,
    this.confidenceLabel = 'Mild',
    this.description = 'A common fungal infection of the nail, causing discoloration, scaling, and thickening. It is often caused by dermatophytes.',
    this.keySigns = 'Discoloration, scaling under the nail, thickening, and crumbly edges',
    this.nextSteps = 'Consult a dermatologist to confirm diagnosis and obtain prescription antifungal medication',
    this.careTips = 'Keep nails dry and clean, wear breathable socks, apply antifungal as directed',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Header navigation
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.border, width: 1.0),
                      ),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: AppColors.textPrimary,
                        size: 20,
                      ),
                    ),
                  ),
                  const Text(
                    '11:42 AM',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Diagnostic Report Header Label
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Diagnostic Report',
                style: AppTypography.heading1,
              ),
            ),
            const SizedBox(height: 16),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main Diagnosis Card
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            conditionName,
                            style: AppTypography.heading1,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$matchPercentage% Match Probability',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: AnimatedProgressBar(
                              value: matchPercentage / 100.0,
                              minHeight: 4,
                              backgroundColor: AppColors.secondaryBg,
                              valueColor: AppColors.ai,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('MILD', style: AppTypography.overline.copyWith(fontSize: 8)),
                              Text('MODERATE', style: AppTypography.overline.copyWith(fontSize: 8)),
                              Text('SEVERE', style: AppTypography.overline.copyWith(fontSize: 8)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Two-Column Section: Key Signs & Next Steps
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Key Signs Column
                        Expanded(
                          child: AppCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'KEY SIGNS',
                                  style: AppTypography.overline,
                                ),
                                const SizedBox(height: 8),
                                ...keySigns.split(',').map((item) => Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    '· ${item.trim()}',
                                    style: AppTypography.body,
                                  ),
                                )),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Next Steps Column
                        Expanded(
                          child: AppCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'NEXT STEPS',
                                  style: AppTypography.overline,
                                ),
                                const SizedBox(height: 8),
                                ...nextSteps.split(',').map((item) => Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    '· ${item.trim()}',
                                    style: AppTypography.body,
                                  ),
                                )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Care Guidelines checklist card
                    const Text(
                      'CARE GUIDELINES',
                      style: AppTypography.overline,
                    ),
                    const SizedBox(height: 8),
                    AppCard(
                      child: Column(
                        children: careTips.split(',').map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 2.0),
                                child: Icon(
                                  Icons.check_circle_rounded,
                                  color: AppColors.success,
                                  size: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  item.trim(),
                                  style: AppTypography.body,
                                ),
                              ),
                            ],
                          ),
                        )).toList(),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Action Buttons
                    AppButton(
                      text: 'Find Nearest Specialist',
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const SpecialistsScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const NutritionLifestyleScreen()),
                          );
                        },
                        child: const Text(
                          'View Diet & Lifestyle Plan',
                          style: TextStyle(
                            color: AppColors.ai,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
