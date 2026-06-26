import 'package:flutter/material.dart';
import 'package:maroapp/core/theme/colors.dart';
import 'package:maroapp/core/theme/typography.dart';
import 'package:maroapp/core/theme/radius.dart';
import 'package:maroapp/core/theme/spacing.dart';
import 'package:maroapp/core/widgets/app_bar.dart';
import 'package:maroapp/core/widgets/app_button.dart';
import 'package:maroapp/core/widgets/app_card.dart';

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
        title: 'Medcare',
        onBackPressed: () => Navigator.of(context).pop(),
        showNotification: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Scrollable Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    const Text(
                      'Nutrition & Lifestyle',
                      style: AppTypography.screenTitle,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Personalized recommendations for optimal nail and overall health based on your latest analysis.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sectionSpace),

                    // Card 1: Diet Suggestions
                    AppCard(
                      backgroundColor: AppColors.secondaryBg,
                      padding: const EdgeInsets.all(AppSpacing.cardInternalPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.restaurant_rounded,
                                  color: AppColors.primary,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Diet Suggestions',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          AppCard(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'FOCUS NUTRIENTS',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.placeholder,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                // Nutrient Badges
                                Row(
                                  children: [
                                    _buildNutrientBadge('Biotin', const Color(0xFFEEF2FF), const Color(0xFF6366F1)),
                                    const SizedBox(width: 8),
                                    _buildNutrientBadge('Zinc', const Color(0xFFFFF1F2), const Color(0xFFEC4899)),
                                    const SizedBox(width: 8),
                                    _buildNutrientBadge('Vitamin E', const Color(0xFFECFDF5), const Color(0xFF10B981)),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Incorporate more nuts, seeds, and leafy greens. Consider a biotin supplement to strengthen nail beds.',
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    color: AppColors.textPrimary,
                                    height: 1.45,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.cardSpace),

                    // Card 2: Hydration Goal
                    AppCard(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.all(AppSpacing.cardInternalPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: const BoxDecoration(
                                      color: AppColors.secondaryBg,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.water_drop_outlined,
                                      color: AppColors.primary,
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'Hydration Goal',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              // Circular Plus Add Button
                              GestureDetector(
                                onTap: _incrementWater,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: AppColors.secondaryBg,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: AppColors.primary,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Dehydration directly impacts nail brittleness. Aim for 2.5L daily.',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Custom Linear Progress bar
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: _loggedWater / _waterGoal,
                              backgroundColor: AppColors.secondaryBg,
                              color: AppColors.primary,
                              minHeight: 8,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Goal metrics text
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${_loggedWater.toStringAsFixed(2)}L logged',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.placeholder,
                                ),
                              ),
                              Text(
                                '${_waterGoal.toStringAsFixed(1)}L goal',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.placeholder,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.cardSpace),

                    // Card 3 & 4 Lifestyle columns (Alcohol & Cuticle Care)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card 3: Limit Alcohol
                        Expanded(
                          child: Container(
                            height: 180,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF5F5),
                              borderRadius: AppRadius.cardBorderRadius,
                              border: Border.all(color: const Color(0xFFFEE2E2), width: 1.5),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFEE2E2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.wine_bar_outlined,
                                    color: AppColors.error,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                const Text(
                                  'Limit Alcohol',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Expanded(
                                  child: Text(
                                    'Can deplete essential vitamins needed for healthy nail growth.',
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      color: AppColors.textSecondary,
                                      height: 1.35,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        // Card 4: Cuticle Care
                        Expanded(
                          child: AppCard(
                            height: 180,
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFEEF2FF),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.clean_hands_outlined,
                                    color: Color(0xFF6366F1),
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                const Text(
                                  'Cuticle Care',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Expanded(
                                  child: Text(
                                    'Apply cuticle oil nightly to prevent peeling and hangnails.',
                                    maxLines: 4,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      color: AppColors.textSecondary,
                                      height: 1.35,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            // 2. Bottom Navigation Bar Container
            Container(
              margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF22252A),
                borderRadius: BorderRadius.circular(35),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(context, icon: Icons.home_outlined, isSelected: false),
                  _buildNavItem(context, icon: Icons.history, isSelected: false),
                  _buildNavItem(context, icon: Icons.calendar_today, isSelected: true),
                  _buildNavItem(context, icon: Icons.person_outline, isSelected: false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientBadge(String label, Color bg, Color text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: text,
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, {required IconData icon, required bool isSelected}) {
    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          if (icon == Icons.home_outlined) {
            Navigator.of(context).popUntil((route) => route.isFirst);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Navigation tab tapped'),
                duration: Duration(seconds: 1),
              ),
            );
          }
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : const Color(0xFF94A3B8),
          size: 24,
        ),
      ),
    );
  }
}
