import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color darkTeal = Color(0xFF1E293B);
    const Color mutedText = Color(0xFF64748B);
    const Color purpleAccent = Color(0xFF7C3AED);
    const Color lightPurpleBg = Color(0xFFEEF2FF);

    return Scaffold(
      backgroundColor: const Color(0xFFE2E2FC),
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
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Color(0xFF1E293B),
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
                          color: purpleAccent,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Your Results header
                      const Text(
                        'Your Results',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: darkTeal,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Analysis complete subtitle
                      const Text(
                        'AI analysis complete',
                        style: TextStyle(
                          fontSize: 14,
                          color: mutedText,
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
                      borderRadius: BorderRadius.circular(36),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
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
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                  decoration: BoxDecoration(
                                    color: lightPurpleBg,
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: const [
                                          Text(
                                            '78% match',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w800,
                                              color: purpleAccent,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            'High confidence',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: mutedText,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Security shield icon circular badge
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: const BoxDecoration(
                                          color: purpleAccent,
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
                                const Text(
                                  'Nail Psoriasis',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                    color: darkTeal,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'A chronic autoimmune condition that affects nail cells, causing changes in appearance.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: mutedText,
                                    height: 1.4,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20.0),
                                  child: Divider(color: Color(0xFFF1F5F9), thickness: 1.5),
                                ),

                                // Detailed list of symptoms and guides
                                _buildDetailsRow(
                                  icon: Icons.gps_fixed_rounded,
                                  title: 'Key Signs Detected',
                                  description: 'Pitting, discoloration, rough texture, and nail thickening',
                                ),
                                const SizedBox(height: 20),
                                _buildDetailsRow(
                                  icon: Icons.gpp_maybe_outlined,
                                  title: 'Recommended Next Steps',
                                  description: 'Consult a dermatologist for proper diagnosis and treatment',
                                ),
                                const SizedBox(height: 20),
                                _buildDetailsRow(
                                  icon: Icons.description_outlined,
                                  title: 'General Care Tips',
                                  description: 'Keep nails moisturized, avoid trauma, and manage stress',
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Fixed Bottom Button Area
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 24.0),
                          child: SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.calendar_today_outlined, size: 18),
                              label: const Text(
                                'Book a doctor',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: purpleAccent,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                              ),
                            ),
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
            color: Color(0xFFEEF2FF),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: const Color(0xFF7C3AED),
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
                style: const TextStyle(
                  fontSize: 15,
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
