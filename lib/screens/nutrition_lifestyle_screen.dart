import 'package:flutter/material.dart';
import 'package:aetherdx/core/theme/colors.dart';
import 'package:aetherdx/core/theme/typography.dart';
import 'package:aetherdx/core/widgets/app_bar.dart';
import 'package:aetherdx/core/widgets/app_button.dart';
import 'package:aetherdx/core/localization/translations.dart';
import '../core/network/api_service.dart';

class NutritionLifestyleScreen extends StatefulWidget {
  final String conditionName;

  const NutritionLifestyleScreen({
    super.key,
    this.conditionName = 'Healthy Nails',
  });

  @override
  State<NutritionLifestyleScreen> createState() => _NutritionLifestyleScreenState();
}

class _NutritionLifestyleScreenState extends State<NutritionLifestyleScreen> {
  double _loggedWater = 2.0;
  final double _waterGoal = 2.5;
  
  Map<String, dynamic>? _recommendations;
  bool _isLoading = true;
  String? _errorMessage;

  // Real-time interactive habits tracker list
  final List<Map<String, dynamic>> _habits = [
    {'title': 'Drink 2L of water'.tr(), 'isCompleted': true},
    {'title': 'Eat nutrient-rich food'.tr(), 'isCompleted': true},
    {'title': 'Apply cuticle moisturizer'.tr(), 'isCompleted': false},
    {'title': 'Protect hands while cleaning'.tr(), 'isCompleted': false},
  ];

  @override
  void initState() {
    super.initState();
    _fetchRecommendations();
  }

  Future<void> _fetchRecommendations() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await ApiService.getLifestyleRecommendations(widget.conditionName);
      setState(() {
        _recommendations = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _incrementWater(double amount) {
    if (_loggedWater >= _waterGoal) return;
    setState(() {
      _loggedWater += amount;
      if (_loggedWater > _waterGoal) {
        _loggedWater = _waterGoal;
      }
    });

    if (_loggedWater == _waterGoal) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hydration goal reached! Keep it up! 💧'.tr()),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // Helper to map dynamic foods based on predicted report focus nutrients
  List<Map<String, dynamic>> _getFoodItems(List<String> nutrients) {
    final foodMap = {
      'biotin': {'name': 'Avocado', 'icon': Icons.spa_outlined},
      'zinc': {'name': 'Seeds', 'icon': Icons.grain_outlined},
      'vitamin e': {'name': 'Nuts', 'icon': Icons.eco_outlined},
      'omega-3': {'name': 'Salmon', 'icon': Icons.set_meal_outlined},
      'vitamin d': {'name': 'Eggs', 'icon': Icons.egg_outlined},
      'protein': {'name': 'Lentils', 'icon': Icons.lunch_dining_outlined},
      'vitamin b12': {'name': 'Fish', 'icon': Icons.set_meal_outlined},
      'iron': {'name': 'Spinach', 'icon': Icons.grass_outlined},
    };
    final List<Map<String, dynamic>> results = [];
    for (var n in nutrients) {
      final key = n.toLowerCase();
      if (foodMap.containsKey(key)) {
        results.add(foodMap[key]!);
      }
    }
    if (results.isEmpty) {
      results.add({'name': 'Avocado', 'icon': Icons.spa_outlined});
      results.add({'name': 'Nuts', 'icon': Icons.eco_outlined});
      results.add({'name': 'Seeds', 'icon': Icons.grain_outlined});
    } else if (results.length == 1) {
      results.add({'name': 'Nuts', 'icon': Icons.eco_outlined});
      results.add({'name': 'Seeds', 'icon': Icons.grain_outlined});
    } else if (results.length == 2) {
      results.add({'name': 'Seeds', 'icon': Icons.grain_outlined});
    }
    return results;
  }

  int get _completedHabitsCount => _habits.where((h) => h['isCompleted'] == true).length;

  @override
  Widget build(BuildContext context) {
    // Premium theme colors
    const Color backgroundLight = Color(0xFFFBFBFA);
    const Color softMint = Color(0xFFE6F4EA);
    const Color borderLight = Color(0xFFE2E8F0);
    const Color graySubtitle = Color(0xFF64748B);

    return Scaffold(
      backgroundColor: backgroundLight,
      appBar: CustomAppBar(
        title: 'Nutrition & Wellness'.tr(),
        onBackPressed: () => Navigator.of(context).pop(),
        showNotification: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    )
                  : _errorMessage != null
                      ? _buildErrorState()
                      : SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 12),
                              
                              // 1. Header Layout
                              Text(
                                'Nutrition & Lifestyle'.tr(),
                                style: AppTypography.screenTitle,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Your personalized daily wellness plan'.tr(),
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  color: graySubtitle,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // 2. Today's Wellness Hero Card
                              _buildWellnessHero(softMint, borderLight),
                              const SizedBox(height: 18),

                              // 3. Today's Goals Section
                              Text(
                                'Today\'s Goals'.tr(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 10),
                              _buildGoalsRow(),
                              const SizedBox(height: 18),

                              // 4. Today's Nutrition Focus Section
                              _buildNutritionFocusCard(borderLight),
                              const SizedBox(height: 16),

                              // 5. Daily Hydration Section
                              _buildHydrationCard(softMint, borderLight),
                              const SizedBox(height: 16),

                              // 6. Today's Habits Section
                              _buildHabitsCard(borderLight),
                              const SizedBox(height: 16),

                              // 7. Weekly Progress Section
                              _buildWeeklyProgressCard(softMint, borderLight),
                              const SizedBox(height: 24),

                              // 8. Primary CTA
                              AppButton(
                                text: 'Complete Today\'s Check-in'.tr(),
                                icon: Icons.arrow_forward_rounded,
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Wellness check-in successfully submitted! 🚀'.tr()),
                                      backgroundColor: AppColors.success,
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.error,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load suggestions'.tr(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _fetchRecommendations,
              icon: const Icon(Icons.refresh_rounded),
              label: Text('Retry'.tr()),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWellnessHero(Color mint, Color border) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: mint,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD1E7DD), width: 1.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Today\'s Wellness'.tr(),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'You\'re doing well. Complete 2 more goals to stay on track today.'.tr(),
                  style: const TextStyle(
                    fontSize: 12.5,
                    height: 1.35,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2E6554),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Circular progress visualizer
          Stack(
            alignment: Alignment.center,
            children: [
              const SizedBox(
                width: 68,
                height: 68,
                child: CircularProgressIndicator(
                  value: 0.82,
                  backgroundColor: Colors.white38,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  strokeWidth: 6,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '82',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'Good'.tr(),
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsRow() {
    final double hydrationPercentage = _loggedWater / _waterGoal;
    return SizedBox(
      height: 105,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: [
          _buildGoalCard(
            title: 'Nutrition'.tr(),
            subtitle: '2 of 3 goals'.tr(),
            percentage: 0.67,
            icon: Icons.restaurant_outlined,
            color: const Color(0xFF6366F1),
          ),
          const SizedBox(width: 10),
          _buildGoalCard(
            title: 'Hydration'.tr(),
            subtitle: '${_loggedWater.toStringAsFixed(1)} / ${_waterGoal.toStringAsFixed(1)}L'.tr(),
            percentage: hydrationPercentage,
            icon: Icons.water_drop_outlined,
            color: AppColors.primary,
          ),
          const SizedBox(width: 10),
          _buildGoalCard(
            title: 'Nail Care'.tr(),
            subtitle: '1 task left'.tr(),
            percentage: 0.50,
            icon: Icons.spa_outlined,
            color: const Color(0xFFEC4899),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalCard({
    required String title,
    required String subtitle,
    required double percentage,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: 115,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      value: percentage,
                      backgroundColor: const Color(0xFFF1F5F9),
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      strokeWidth: 3.5,
                    ),
                  ),
                  Icon(icon, size: 14, color: color),
                ],
              ),
              Text(
                '${(percentage * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title.tr(),
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle.tr(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionFocusCard(Color border) {
    final recs = _recommendations ?? {};
    final dietText = recs['diet_suggestions'] as String? ?? 'Incorporate healthy foods.';
    final focusNutrients = List<String>.from(recs['focus_nutrients'] ?? ['Biotin', 'Zinc', 'Vitamin E']);
    final foodItems = _getFoodItems(focusNutrients);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Today\'s Nutrition Focus'.tr(),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Navigating to full nutrition schedule...'.tr()),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              child: Text(
                'View Plan →'.tr(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nutrients to prioritize based on your wellness plan'.tr(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 12),
              
              // Nutrient Chips
              Row(
                children: [
                  _buildNutrientBadge((focusNutrients.elementAtOrNull(0) ?? 'Biotin').tr(), const Color(0xFFEEF2FF), const Color(0xFF6366F1)),
                  const SizedBox(width: 8),
                  _buildNutrientBadge((focusNutrients.elementAtOrNull(1) ?? 'Zinc').tr(), const Color(0xFFFFF1F2), const Color(0xFFEC4899)),
                  const SizedBox(width: 8),
                  _buildNutrientBadge((focusNutrients.elementAtOrNull(2) ?? 'Vitamin E').tr(), const Color(0xFFECFDF5), const Color(0xFF10B981)),
                ],
              ),
              const SizedBox(height: 16),
              
              Text(
                dietText.tr(),
                style: const TextStyle(
                  fontSize: 12.5,
                  color: AppColors.textPrimary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              
              // Recommended Food Items Layout
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: foodItems.map((item) {
                  return _buildFoodSourceChip((item['name'] as String).tr(), item['icon']);
                }).toList(),
              ),
              const SizedBox(height: 14),
              
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Loading all recommended foods...'.tr()), duration: const Duration(seconds: 1)),
                  );
                },
                child: Text(
                  'View all recommended foods →'.tr(),
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHydrationCard(Color mint, Color border) {
    final double percentage = _loggedWater / _waterGoal;
    final double remaining = _waterGoal - _loggedWater;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daily Hydration'.tr(),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_loggedWater.toStringAsFixed(1)}L / ${_waterGoal.toStringAsFixed(1)}L',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '${(percentage * 100).toInt()}%',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Custom progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: percentage,
                  backgroundColor: const Color(0xFFF1F5F9),
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 10),
              
              Text(
                remaining > 0
                    ? '${(remaining * 1000).toInt()}ml remaining to reach your goal'.tr()
                    : 'Hydration goal achieved! 💧'.tr(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 16),
              
              // Increment buttons
              Row(
                children: [
                  Expanded(
                    child: _buildHydrationLogButton('+ 250ml', mint, () => _incrementWater(0.25)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildHydrationLogButton('+ 500ml', mint, () => _incrementWater(0.50)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHydrationLogButton(String text, Color bg, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildHabitsCard(Color border) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Today\'s Habits'.tr(),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              '$_completedHabitsCount/${_habits.length} Completed'.tr(),
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: _habits.map((habit) => _buildHabitItem(habit)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildHabitItem(Map<String, dynamic> habit) {
    final bool completed = habit['isCompleted'];
    return GestureDetector(
      onTap: () {
        setState(() {
          habit['isCompleted'] = !completed;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: completed ? AppColors.primary : const Color(0xFFCBD5E1),
                  width: 2,
                ),
                color: completed ? AppColors.primary : Colors.transparent,
              ),
              child: completed
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                habit['title'],
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: completed ? FontWeight.w700 : FontWeight.w600,
                  color: completed ? AppColors.textPrimary : const Color(0xFF64748B),
                  decoration: completed ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyProgressCard(Color mint, Color border) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Progress'.tr(),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Weekly Routine'.tr(),
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: mint,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.local_fire_department_rounded, color: AppColors.primary, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          '5 Day Streak'.tr(),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildWeeklyTracker(),
              const SizedBox(height: 14),
              Text(
                'You’re building a healthy routine!'.tr(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyTracker() {
    final days = ['M'.tr(), 'T'.tr(), 'W'.tr(), 'T'.tr(), 'F'.tr(), 'S'.tr(), 'S'.tr()];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(days.length, (index) {
        final day = days[index];
        final bool isCompleted = index < 5;
        final bool isCurrent = index == 5;
        
        return Column(
          children: [
            Text(
              day,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Color(0xFF94A3B8),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? AppColors.primary
                    : isCurrent
                        ? Colors.white
                        : const Color(0xFFF1F5F9),
                border: isCurrent
                    ? Border.all(color: AppColors.primary, width: 2)
                    : null,
              ),
              alignment: Alignment.center,
              child: isCompleted
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : isCurrent
                      ? Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        )
                      : null,
            ),
          ],
        );
      }),
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

  Widget _buildFoodSourceChip(String name, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            name,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
