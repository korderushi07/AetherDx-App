import 'package:flutter/material.dart';
import 'package:maroapp/core/theme/colors.dart';
import 'package:maroapp/core/theme/typography.dart';
import 'package:maroapp/core/theme/spacing.dart';
import 'package:maroapp/core/theme/radius.dart';
import 'package:maroapp/core/widgets/app_bar.dart';
import 'package:maroapp/core/widgets/app_button.dart';
import 'package:maroapp/core/widgets/app_card.dart';
import 'package:maroapp/core/widgets/section_title.dart';
import 'specialists_screen.dart';

class EducationalScreen extends StatelessWidget {
  const EducationalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Medcare',
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Image Banner
              ClipRRect(
                borderRadius: AppRadius.cardBorderRadius,
                child: Image.network(
                  'https://images.unsplash.com/photo-1604654894610-df63bc536371?auto=format&fit=crop&q=80&w=600',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 200,
                      color: const Color(0xFFE2E8F0),
                      alignment: Alignment.center,
                      child: const Icon(Icons.image_outlined, color: AppColors.textSecondary, size: 48),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.gapLarge),

              // Tag Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.secondaryBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Nail Health Guide',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.gapMedium),

              // Title
              const Text(
                'Understanding Fungal Infections',
                style: AppTypography.screenTitle,
              ),
              const SizedBox(height: AppSpacing.gapSmall),

              // Subtitle
              const Text(
                'A comprehensive overview of common nail conditions, their early indicators, and effective management strategies for optimal health.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: AppSpacing.sectionSpace),

              // Symptoms Overview Header
              const SectionTitle(
                title: 'Symptoms Overview',
                trailing: Icon(Icons.query_stats_rounded, color: AppColors.primary, size: 20),
              ),
              const SizedBox(height: AppSpacing.gapMedium),

              // Symptoms Cards Row
              Row(
                children: [
                  Expanded(
                    child: _buildSymptomCard(
                      icon: Icons.grain_outlined,
                      title: 'Discoloration',
                      description: 'Yellowing or white spots appearing under the tip of the nail.',
                    ),
                  ),
                  const SizedBox(width: AppSpacing.cardSpace),
                  Expanded(
                    child: _buildSymptomCard(
                      icon: Icons.layers_outlined,
                      title: 'Thickening',
                      description: 'Nails may become unusually thick or distorted in shape over time.',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.cardSpace),

              // Early Detection Callout
              AppCard(
                backgroundColor: AppColors.secondaryBg,
                padding: const EdgeInsets.all(AppSpacing.cardInternalPadding),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.info_outline_rounded,
                        color: AppColors.primary,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Early Detection',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Identifying these symptoms early significantly improves the efficacy of treatment and reduces recovery time.',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.primary,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sectionSpace),

              // Condition Awareness Header
              const SectionTitle(title: 'Condition Awareness'),
              const SizedBox(height: AppSpacing.gapMedium),

              // Condition Awareness Card Description
              const AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Onychomycosis, commonly known as a fungal nail infection, is a prevalent condition that begins as a white or yellow spot under the tip of your fingernail or toenail. As the fungal infection goes deeper, it may cause the nail to discolor, thicken, and crumble at the edge.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.45,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'While often harmless in early stages, prolonged neglect can lead to discomfort and permanent damage to the nail bed. It\'s crucial to maintain proper hygiene and monitor any changes in your nail\'s appearance or texture.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sectionSpace),

              // Dietary Recommendations Section
              const SectionTitle(title: 'Dietary Recommendations'),
              const SizedBox(height: AppSpacing.gapMedium),

              // Dietary List Items
              _buildDietaryItem(
                title: 'Probiotic-rich Foods',
                description: 'Yogurt, kefir, and kombucha help maintain healthy microflora.',
              ),
              _buildDietaryItem(
                title: 'Lean Proteins',
                description: 'Essential for keratin production, the main structural protein in nails.',
              ),
              _buildDietaryItem(
                title: 'Iron & Zinc Supplements',
                description: 'Consult your physician before adding new supplements to your routine.',
              ),
              const SizedBox(height: AppSpacing.sectionSpace),

              // Warning Alert Card (When to consult a doctor)
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE2E2),
                  borderRadius: AppRadius.cardBorderRadius,
                ),
                padding: const EdgeInsets.all(AppSpacing.cardInternalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.warning_amber_rounded,
                            color: AppColors.error,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'When to consult a doctor',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.error,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'If self-care steps haven\'t helped, and the nail becomes increasingly discolored, thickened, or deformed. Also seek medical advice if you have diabetes and suspect an infection.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.error,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Find a Doctor Button
                    AppButton(
                      text: 'Find a Doctor',
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const SpecialistsScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sectionSpace),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSymptomCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return AppCard(
      height: 160,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.textPrimary, size: 18),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: AppTypography.cardTitle,
          ),
          const SizedBox(height: 6),
          Expanded(
            child: Text(
              description,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDietaryItem({
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      child: AppCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Color(0xFFDCFCE7),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.check,
                color: Color(0xFF15803D),
                size: 14,
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
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
