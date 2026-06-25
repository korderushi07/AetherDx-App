import 'package:flutter/material.dart';

class ImageQualityAlertScreen extends StatelessWidget {
  const ImageQualityAlertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color darkTeal = Color(0xFF1F484C);
    const Color mutedText = Color(0xFF718096);

    return Scaffold(
      backgroundColor: const Color(0xFFFCFDFF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              // Header title
              const Text(
                'Image Quality Alert',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              // Header description
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "We couldn't analyze the image clearly. Please review the guidance below.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: mutedText,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Center Illustration Container
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: const Color(0xFFF1F5F9)),
                ),
                child: Center(
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Dashed Circle Orbit
                        CustomPaint(
                          size: const Size(160, 160),
                          painter: _DashedCirclePainter(),
                        ),
                        // Center Phone Icon Card
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.phone_android_outlined,
                            size: 38,
                            color: darkTeal,
                          ),
                        ),
                        // Top-Right Badge: Better Lighting (Angle: -45 deg)
                        // x = 100 + 80 * cos(-pi/4) - 20 = 136.5
                        // y = 100 + 80 * sin(-pi/4) - 20 = 23.5
                        Positioned(
                          left: 136.5,
                          top: 23.5,
                          child: _buildOrbitBadge(Icons.wb_sunny_outlined),
                        ),
                        // Bottom-Right Badge: Move Closer (Angle: 45 deg)
                        // x = 100 + 80 * cos(pi/4) - 20 = 136.5
                        // y = 100 + 80 * sin(pi/4) - 20 = 136.5
                        Positioned(
                          left: 136.5,
                          top: 136.5,
                          child: _buildOrbitBadge(Icons.zoom_in_outlined),
                        ),
                        // Bottom-Left Badge: Refocus (Angle: 135 deg)
                        // x = 100 + 80 * cos(3*pi/4) - 20 = 23.5
                        // y = 100 + 80 * sin(3*pi/4) - 20 = 136.5
                        Positioned(
                          left: 23.5,
                          top: 136.5,
                          child: _buildOrbitBadge(Icons.crop_free_outlined),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Guidance List Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 22.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFF1F5F9)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.01),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildGuidanceItem(
                      icon: Icons.wb_sunny_outlined,
                      title: 'Better lighting',
                      description: 'Use natural light for better results',
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14.0),
                      child: Divider(color: Color(0xFFF1F5F9), thickness: 1),
                    ),
                    _buildGuidanceItem(
                      icon: Icons.crop_free_outlined,
                      title: 'Refocus',
                      description: 'Hold your phone steady and tap to focus',
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14.0),
                      child: Divider(color: Color(0xFFF1F5F9), thickness: 1),
                    ),
                    _buildGuidanceItem(
                      icon: Icons.zoom_in_outlined,
                      title: 'Move closer',
                      description: 'Ensure the nail fills the scanning frame',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Try Again Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.refresh_outlined, size: 20),
                  label: const Text(
                    'Try Again',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E1E1E),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrbitBadge(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFCBE5EE),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Icon(
        icon,
        size: 20,
        color: const Color(0xFF1F484C),
      ),
    );
  }

  Widget _buildGuidanceItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Color(0xFFE4F3F5),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: const Color(0xFF1F484C),
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
                  color: Color(0xFF1F484C),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF718096),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DashedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final Paint paint = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final double dashWidth = 6.0;
    final double dashSpace = 4.0;
    double currentAngle = 0.0;

    while (currentAngle < 2 * 3.1415926535) {
      final double sweepAngle = dashWidth / radius;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(radius, radius), radius: radius),
        currentAngle,
        sweepAngle,
        false,
        paint,
      );
      currentAngle += (dashWidth + dashSpace) / radius;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
