import 'package:flutter/material.dart';
import 'image_quality_alert_screen.dart';
import 'analyzing_nail_screen.dart';

class ScanNailScreen extends StatefulWidget {
  final VoidCallback onBackPressed;

  const ScanNailScreen({
    super.key,
    required this.onBackPressed,
  });

  @override
  State<ScanNailScreen> createState() => _ScanNailScreenState();
}

class _ScanNailScreenState extends State<ScanNailScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.08, end: 0.92).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFDFF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Action Row (Back button, Title header, Help button)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Circular Back Button
                  GestureDetector(
                    onTap: widget.onBackPressed,
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
                        Icons.arrow_back_ios_new_rounded,
                        color: Color(0xFF1E293B),
                        size: 20,
                      ),
                    ),
                  ),
                  // Title Header
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Scan Nail',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1F484C),
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 4),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Capture a clear image of your nail for accurate analysis',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF64748B),
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Circular Help Button
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
                      Icons.help_outline_rounded,
                      color: Color(0xFF1E293B),
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Viewfinder Scanner Section Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFE4F3F5),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Center(
                  child: Container(
                    width: 230,
                    height: 230,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: Stack(
                        children: [
                          // 1. Centered Nail Image
                          Positioned.fill(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Image.asset(
                                'assets/images/nail_to_scan.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          // 2. Corner Viewfinder Brackets
                          Positioned.fill(
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final double bracketSize = 24.0;
                                final double stroke = 4.0;
                                const Color bracketColor = Color(0xFF3E9BB0);

                                return Stack(
                                  children: [
                                    // Top Left
                                    Positioned(
                                      top: 16,
                                      left: 16,
                                      child: Container(
                                        width: bracketSize,
                                        height: bracketSize,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            top: BorderSide(color: bracketColor, width: stroke),
                                            left: BorderSide(color: bracketColor, width: stroke),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Top Right
                                    Positioned(
                                      top: 16,
                                      right: 16,
                                      child: Container(
                                        width: bracketSize,
                                        height: bracketSize,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            top: BorderSide(color: bracketColor, width: stroke),
                                            right: BorderSide(color: bracketColor, width: stroke),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Bottom Left
                                    Positioned(
                                      bottom: 16,
                                      left: 16,
                                      child: Container(
                                        width: bracketSize,
                                        height: bracketSize,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(color: bracketColor, width: stroke),
                                            left: BorderSide(color: bracketColor, width: stroke),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Bottom Right
                                    Positioned(
                                      bottom: 16,
                                      right: 16,
                                      child: Container(
                                        width: bracketSize,
                                        height: bracketSize,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(color: bracketColor, width: stroke),
                                            right: BorderSide(color: bracketColor, width: stroke),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          // 3. Glowing Laser Scanner Line Animation
                          Positioned.fill(
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return AnimatedBuilder(
                                  animation: _animation,
                                  builder: (context, child) {
                                    return Stack(
                                      children: [
                                        Positioned(
                                          top: constraints.maxHeight * _animation.value,
                                          left: 20,
                                          right: 20,
                                          child: Container(
                                            height: 3,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF49C3DF),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: const Color(0xFF49C3DF).withValues(alpha: 0.8),
                                                  blurRadius: 8,
                                                  spreadRadius: 2,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Instructions Panel Card
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
                    // Good Lighting Instruction row
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Color(0xFFE4F3F5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.wb_sunny_outlined,
                            color: Color(0xFF1F484C),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Good Lighting',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1F484C),
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Use natural light for better results',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF718096),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14.0),
                      child: Divider(color: Color(0xFFF1F5F9), thickness: 1),
                    ),
                    // Keep Steady Instruction row
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Color(0xFFE4F3F5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.back_hand_outlined,
                            color: Color(0xFF1F484C),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Keep Steady',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1F484C),
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Hold your phone steady and clear',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF718096),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Capture Image Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      builder: (BuildContext context) {
                        return SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text(
                                  'Simulation Control',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF1F484C),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Choose a quality check outcome to test the user flows:',
                                  style: TextStyle(fontSize: 13, color: Color(0xFF718096)),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (_) => const AnalyzingNailScreen()),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1F484C),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: const Text('Simulate Success (Good Quality)'),
                                ),
                                const SizedBox(height: 12),
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (_) => const ImageQualityAlertScreen()),
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color(0xFF1F484C),
                                    side: const BorderSide(color: Color(0xFF1F484C)),
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: const Text('Simulate Alert (Poor Quality)'),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.camera_alt_outlined, size: 20),
                  label: const Text(
                    'Capture Image',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1F484C),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 80), // spacer for bottom nav bar
            ],
          ),
        ),
      ),
    );
  }
}
