import 'package:flutter/material.dart';
import 'package:maroapp/core/theme/colors.dart';
import 'package:maroapp/core/theme/typography.dart';
import 'package:maroapp/core/theme/spacing.dart';
import 'package:maroapp/core/widgets/app_bar.dart';
import 'package:maroapp/core/widgets/app_card.dart';
import 'package:maroapp/core/widgets/animations.dart';
import 'result_screen.dart';

class HistoryScreen extends StatelessWidget {
  final VoidCallback onBackPressed;

  const HistoryScreen({
    super.key,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> historyData = [
      {
        'date': 'Nov 1, 2025',
        'condition': 'Fungal Infection',
        'confidence': '92%',
        'statusText': 'High Risk',
        'badgeBg': const Color(0xFFFEE2E2),
        'badgeText': AppColors.error,
        'reportParams': {
          'conditionName': 'Fungal Infection',
          'matchPercentage': 92,
          'confidenceLabel': 'High confidence',
          'description': 'A common fungal infection of the nail, causing discoloration, scaling, and thickening. It is often caused by dermatophytes.',
          'keySigns': 'Discoloration, scaling under the nail, thickening, and crumbly edges',
          'nextSteps': 'Consult a dermatologist to confirm diagnosis and obtain prescription antifungal medication',
          'careTips': 'Keep nails dry and clean, wear breathable socks, and avoid sharing nail clippers',
        }
      },
      {
        'date': 'March 20, 2025',
        'condition': 'Healthy Nail',
        'confidence': '98%',
        'statusText': 'Healthy',
        'badgeBg': const Color(0xFFDCFCE7),
        'badgeText': AppColors.success,
        'reportParams': {
          'conditionName': 'Healthy Nail',
          'matchPercentage': 98,
          'confidenceLabel': 'Very high confidence',
          'description': 'Your nail appears healthy and shows no major signs of infection, psoriasis, or other common disorders.',
          'keySigns': 'Smooth texture, consistent pinkish hue, normal thickness, and intact cuticle',
          'nextSteps': 'No immediate medical action required. Maintain your routine hand and nail hygiene',
          'careTips': 'Moisturize cuticles, trim nails straight across, and avoid harsh chemical nail products',
        }
      },
      {
        'date': 'Feb 18, 2025',
        'condition': 'Nail Psoriasis',
        'confidence': '85%',
        'statusText': 'Moderate',
        'badgeBg': const Color(0xFFFEF3C7),
        'badgeText': AppColors.warning,
        'reportParams': {
          'conditionName': 'Nail Psoriasis',
          'matchPercentage': 85,
          'confidenceLabel': 'High confidence',
          'description': 'A chronic autoimmune condition that affects nail cells, causing changes in appearance.',
          'keySigns': 'Pitting, discoloration, rough texture, and nail thickening',
          'nextSteps': 'Consult a dermatologist for proper diagnosis and treatment',
          'careTips': 'Keep nails moisturized, avoid trauma, and manage stress',
        }
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Analysis History',
        onBackPressed: onBackPressed,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filter Bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
                vertical: 12.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${historyData.length} results',
                    style: AppTypography.caption,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.filter_list_rounded,
                          color: AppColors.textPrimary,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Filter',
                          style: AppTypography.caption.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Timeline Entries List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPadding,
                  0.0,
                  AppSpacing.screenPadding,
                  80.0,
                ),
                itemCount: historyData.length,
                itemBuilder: (context, index) {
                  final item = historyData[index];
                  final bool isFirst = index == 0;
                  final bool isLast = index == historyData.length - 1;

                  return IntrinsicHeight(
                    child: FadeSlideWidget(
                      delay: Duration(milliseconds: 50 * index),
                      slideDistance: 8.0,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Left Timeline Column
                          SizedBox(
                            width: 32,
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                Positioned(
                                  top: 0,
                                  bottom: isLast ? 20 : 0,
                                  child: Container(
                                    width: 2,
                                    color: const Color(0xFFE2E8F0),
                                  ),
                                ),
                                Positioned(
                                  top: 6,
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: isFirst
                                          ? AppColors.primary
                                          : const Color(0xFFCBD5E1),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Right Details Column & Card
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Date Header
                                Text(
                                  item['date'].toString().toUpperCase(),
                                  style: AppTypography.overline.copyWith(
                                    color: AppColors.textTertiary,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // Report Card
                                AppCard(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Row 1: Condition and Status Badge
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            item['condition'],
                                            style: AppTypography.cardTitle,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: item['badgeBg'],
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              item['statusText'].toString().toUpperCase(),
                                              style: AppTypography.overline.copyWith(
                                                color: item['badgeText'],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),

                                      // Row 2: View Report trigger link
                                      GestureDetector(
                                        onTap: () {
                                          final report = item['reportParams'] as Map<String, dynamic>;
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) => ResultScreen(
                                                conditionName: report['conditionName'],
                                                matchPercentage: report['matchPercentage'],
                                                confidenceLabel: report['confidenceLabel'],
                                                description: report['description'],
                                                keySigns: report['keySigns'],
                                                nextSteps: report['nextSteps'],
                                                careTips: report['careTips'],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          'View Report →',
                                          style: AppTypography.caption.copyWith(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
