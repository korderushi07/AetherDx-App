import 'package:flutter/material.dart';
import 'package:maroapp/core/theme/colors.dart';
import 'package:maroapp/core/theme/typography.dart';
import 'package:maroapp/core/widgets/app_bar.dart';
import 'package:maroapp/core/widgets/app_card.dart';
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
        'region': 'Left Index Finger',
        'action': 'Topical Antifungal',
        'titleColor': AppColors.primary,
        'badgeBg': AppColors.primary,
        'badgeText': Colors.white,
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
        'region': 'Right Thumb',
        'action': 'Routine Care',
        'titleColor': AppColors.textPrimary,
        'badgeBg': AppColors.secondaryBg,
        'badgeText': AppColors.primary,
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
        'region': 'Left Thumb',
        'action': 'Dermatologist Consult',
        'titleColor': const Color(0xFF8C5333),
        'badgeBg': const Color(0xFFFEE2E2),
        'badgeText': AppColors.error,
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
        showNotification: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 2. Action Filter Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Showing all past nail analysis entries',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.filter_list_rounded,
                          color: AppColors.textPrimary,
                          size: 16,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Filter',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 3. Timeline Entries List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 80.0),
                itemCount: historyData.length,
                itemBuilder: (context, index) {
                  final item = historyData[index];
                  final bool isFirst = index == 0;
                  final bool isLast = index == historyData.length - 1;

                  return IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Left Timeline Column
                        SizedBox(
                          width: 32,
                          child: Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              // Connector line
                              Positioned(
                                top: isFirst ? 14 : 0,
                                bottom: isLast ? 0 : 0,
                                child: Container(
                                  width: 2,
                                  decoration: BoxDecoration(
                                    color: isLast
                                        ? Colors.transparent
                                        : const Color(0xFFE2E8F0),
                                  ),
                                ),
                              ),
                              if (isLast)
                                Positioned(
                                  top: 0,
                                  bottom: 14,
                                  child: Container(
                                    width: 2,
                                    color: const Color(0xFFE2E8F0),
                                  ),
                                ),
                              // Bullet Dot
                              Positioned(
                                top: 6,
                                child: isFirst
                                    ? Container(
                                        width: 16,
                                        height: 16,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: AppColors.primary,
                                            width: 4,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        width: 10,
                                        height: 10,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFCBD5E1),
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
                                item['date'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 10),

                              // Report Card
                              AppCard(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Row 1: Upper labels
                                    const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'CONDITION DETECTED',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.placeholder,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        Text(
                                          'CONFIDENCE SCORE',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.placeholder,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),

                                    // Row 2: Title and badge
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          item['condition'],
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w800,
                                            color: item['titleColor'],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: item['badgeBg'],
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            item['confidence'],
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w800,
                                              color: item['badgeText'],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                      color: AppColors.secondaryBg,
                                      thickness: 1.5,
                                      height: 24,
                                    ),

                                    // Row 3: Metadata columns
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Analyzed Region',
                                              style: AppTypography.caption,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              item['region'],
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.textPrimary,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Recommended Action',
                                              style: AppTypography.caption,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              item['action'],
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.textPrimary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                      color: AppColors.secondaryBg,
                                      thickness: 1.5,
                                      height: 24,
                                    ),

                                    // Row 4: View full report link
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
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            'View full report',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w800,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                          SizedBox(width: 4),
                                          Icon(
                                            Icons.chevron_right_rounded,
                                            color: AppColors.primary,
                                            size: 16,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 28),
                            ],
                          ),
                        ),
                      ],
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
