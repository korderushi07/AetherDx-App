import 'package:flutter/material.dart';
import 'specialists_screen.dart';

class EducationalScreen extends StatelessWidget {
  const EducationalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color darkTeal = Color(0xFF0F3E42);
    const Color slateText = Color(0xFF1E293B);
    const Color mutedText = Color(0xFF64748B);
    const Color lightCyan = Color(0xFFE0F7FA);
    const Color accentCyan = Color(0xFF007E8A);
    const Color alertRedBg = Color(0xFFFEE2E2);
    const Color alertRedText = Color(0xFF991B1B);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Header (Back button, Title, Notification Bell)
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

            // 2. Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    // Hero Image Banner
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
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
                            child: const Icon(Icons.image_outlined, color: mutedText, size: 48),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Tag Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F2FE),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Nail Health Guide',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0369A1),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Title
                    const Text(
                      'Understanding Fungal Infections',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: slateText,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Subtitle
                    const Text(
                      'A comprehensive overview of common nail conditions, their early indicators, and effective management strategies for optimal health.',
                      style: TextStyle(
                        fontSize: 14,
                        color: mutedText,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Symptoms Overview Header
                    Row(
                      children: const [
                        Icon(Icons.query_stats_rounded, color: accentCyan, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Symptoms Overview',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: slateText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

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
                        const SizedBox(width: 14),
                        Expanded(
                          child: _buildSymptomCard(
                            icon: Icons.layers_outlined,
                            title: 'Thickening',
                            description: 'Nails may become unusually thick or distorted in shape over time.',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Early Detection Callout
                    Container(
                      decoration: BoxDecoration(
                        color: lightCyan,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(16),
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
                              color: accentCyan,
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
                                    color: accentCyan,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Identifying these symptoms early significantly improves the efficacy of treatment and reduces recovery time.',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF1E5257),
                                    height: 1.35,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Condition Awareness Header
                    const Text(
                      'Condition Awareness',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: slateText,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Condition Awareness Card Description
                    Container(
                      width: double.infinity,
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
                      padding: const EdgeInsets.all(20),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Onychomycosis, commonly known as a fungal nail infection, is a prevalent condition that begins as a white or yellow spot under the tip of your fingernail or toenail. As the fungal infection goes deeper, it may cause the nail to discolor, thicken, and crumble at the edge.',
                            style: TextStyle(
                              fontSize: 14,
                              color: mutedText,
                              height: 1.45,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'While often harmless in early stages, prolonged neglect can lead to discomfort and permanent damage to the nail bed. It\'s crucial to maintain proper hygiene and monitor any changes in your nail\'s appearance or texture.',
                            style: TextStyle(
                              fontSize: 14,
                              color: mutedText,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Dietary Recommendations Section
                    const Text(
                      'Dietary Recommendations',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: slateText,
                      ),
                    ),
                    const SizedBox(height: 12),

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
                    const SizedBox(height: 28),

                    // Warning Alert Card (When to consult a doctor)
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: alertRedBg,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      padding: const EdgeInsets.all(24),
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
                                  color: Color(0xFFEF4444),
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'When to consult a doctor',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: alertRedText,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'If self-care steps haven\'t helped, and the nail becomes increasingly discolored, thickened, or deformed. Also seek medical advice if you have diabetes and suspect an infection.',
                            style: TextStyle(
                              fontSize: 13,
                              color: alertRedText,
                              height: 1.45,
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Find a Doctor Button
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => const SpecialistsScreen()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1E1E24),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(26),
                                ),
                              ),
                              child: const Text(
                                'Find a Doctor',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSymptomCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      height: 160,
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
              color: Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF1E293B), size: 18),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: Text(
              description,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF64748B),
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
      ),
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
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
