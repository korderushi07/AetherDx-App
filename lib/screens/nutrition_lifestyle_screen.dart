import 'package:flutter/material.dart';
import 'package:maroapp/core/theme/colors.dart';
import 'package:maroapp/core/theme/typography.dart';
import 'package:maroapp/core/theme/spacing.dart';
import 'package:maroapp/core/widgets/app_bar.dart';
import 'package:maroapp/core/widgets/app_button.dart';
import 'package:maroapp/core/widgets/app_card.dart';
import 'package:maroapp/core/widgets/animations.dart';

class NutritionLifestyleScreen extends StatefulWidget {
  const NutritionLifestyleScreen({super.key});

  @override
  State<NutritionLifestyleScreen> createState() => _NutritionLifestyleScreenState();
}

class _NutritionLifestyleScreenState extends State<NutritionLifestyleScreen> {
  double _loggedWater = 1.5;
  final double _waterGoal = 2.5;

  void _incrementWater() {
    if (_loggedWater >= _waterGoal) return;
    setState(() {
      _loggedWater += 0.25;
      if (_loggedWater > _waterGoal) {
        _loggedWater = _waterGoal;
      }
    });

    if (_loggedWater == _waterGoal) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hydration goal reached! Keep it up! 💧'),
          backgroundColor: AppColors.success,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Nutrition & Lifestyle',
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
            vertical: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Nutrition & Lifestyle',
                style: AppTypography.heading1,
              ),
              const SizedBox(height: 8),
              const Text(
                'Personalized recommendations for optimal nail and overall health based on your latest analysis.',
                style: AppTypography.body,
              ),
              const SizedBox(height: AppSpacing.sectionSpace),

              // Hydration Target
              Text(
                'HYDRATION TARGET',
                style: AppTypography.overline,
              ),
              const SizedBox(height: 8),
              AppCard(
                padding: const EdgeInsets.all(AppSpacing.cardInternalPadding),
                child: Row(
                  children: [
                    AetherProgressRing(
                      value: _loggedWater / _waterGoal,
                      size: 80.0,
                      strokeWidth: 6.0,
                      color: AppColors.ai,
                      backgroundColor: AppColors.secondaryBg,
                      child: Text(
                        '${((_loggedWater / _waterGoal) * 100).toInt()}%',
                        style: AppTypography.caption.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_loggedWater.toStringAsFixed(1)}L of ${_waterGoal.toStringAsFixed(1)}L logged',
                            style: AppTypography.cardTitle,
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: _incrementWater,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Log Water +',
                                    style: AppTypography.caption.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
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
              ),
              const SizedBox(height: AppSpacing.sectionSpace),

              // Diet Focus
              Text(
                'DIET FOCUS',
                style: AppTypography.overline,
              ),
              const SizedBox(height: 8),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _buildSubtleNutrientTag('Biotin'),
                        const SizedBox(width: 8),
                        _buildSubtleNutrientTag('Zinc'),
                        const SizedBox(width: 8),
                        _buildSubtleNutrientTag('Vitamin E'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Prioritize these for nail health. Incorporate more nuts, seeds, and leafy greens.',
                      style: AppTypography.body,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sectionSpace),

              // Lifestyle Habits
              Text(
                'LIFESTYLE HABITS',
                style: AppTypography.overline,
              ),
              const SizedBox(height: 8),
              AppCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _buildLifestyleRow(
                      icon: Icons.wine_bar_outlined,
                      title: 'Limit alcohol intake',
                      subtitle: 'Can deplete essential vitamins needed for healthy nail growth.',
                    ),
                    const Divider(height: 1, color: AppColors.border),
                    _buildLifestyleRow(
                      icon: Icons.spa_outlined,
                      title: 'Cuticle care',
                      subtitle: 'Apply cuticle oil nightly to prevent peeling and hangnails.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sectionSpace),

              // Log Daily Habits Button
              AppButton(
                text: 'Log Daily Habits',
                icon: Icons.edit_note_rounded,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Daily habits successfully logged! 🌟'),
                      backgroundColor: AppColors.success,
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubtleNutrientTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.secondaryBg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: AppTypography.caption.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildLifestyleRow({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppColors.secondaryBg,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: AppColors.textPrimary, size: 16),
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
                  subtitle,
                  style: AppTypography.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
