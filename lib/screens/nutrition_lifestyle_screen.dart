import 'package:flutter/material.dart';

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
          backgroundColor: Color(0xFF29A887),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color darkTeal = Color(0xFF0F3E42);
    const Color slateText = Color(0xFF1E293B);
    const Color mutedText = Color(0xFF64748B);
    const Color lightBlueBg = Color(0xFFEAF8FA);
    const Color accentBlue = Color(0xFF007E8A);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Custom AppBar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
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
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: slateText,
                        size: 20,
                      ),
                    ),
                  ),
                  const Text(
                    'Medcare',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: darkTeal,
                      letterSpacing: -0.8,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.notifications_none_rounded,
                      color: slateText,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),

            // 2. Scrollable Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    const Text(
                      'Nutrition & Lifestyle',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: slateText,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Personalized recommendations for optimal nail and overall health based on your latest analysis.',
                      style: TextStyle(
                        fontSize: 14,
                        color: mutedText,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Card 1: Diet Suggestions
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: lightBlueBg,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: const Color(0xFFD0ECF0), width: 1.5),
                      ),
                      padding: const EdgeInsets.all(20),
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
                                  color: accentBlue,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Diet Suggestions',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: accentBlue,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'FOCUS NUTRIENTS',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF94A3B8),
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
                                    color: slateText,
                                    height: 1.45,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Card 2: Hydration Goal
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(20),
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
                                      color: Color(0xFFE0F2FE),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.water_drop_outlined,
                                      color: Color(0xFF0284C7),
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'Hydration Goal',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: slateText,
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
                                    color: Color(0xFFF1F5F9),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: slateText,
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
                              color: mutedText,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Custom Linear Progress bar
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: _loggedWater / _waterGoal,
                              backgroundColor: const Color(0xFFF1F5F9),
                              color: accentBlue,
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
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                              Text(
                                '${_waterGoal.toStringAsFixed(1)}L goal',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

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
                              borderRadius: BorderRadius.circular(24),
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
                                    color: Color(0xFFEF4444),
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                const Text(
                                  'Limit Alcohol',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: slateText,
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
                                      color: mutedText,
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
                          child: Container(
                            height: 180,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.02),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
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
                                    color: slateText,
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
                                      color: mutedText,
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
                    const SizedBox(height: 24),

                    // Log Daily Habits Button
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Daily habits successfully logged! 🌟'),
                              backgroundColor: Color(0xFF29A887),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit_note_rounded, size: 20),
                        label: const Text('Log Daily Habits'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E1E24),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(27),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            // 3. Bottom Navigation Bar Container
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
          color: isSelected ? const Color(0xFF49C3DF) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isSelected ? const Color(0xFF22252A) : const Color(0xFF90A4AE),
          size: 24,
        ),
      ),
    );
  }
}
