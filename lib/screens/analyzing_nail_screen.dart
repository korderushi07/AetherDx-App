import 'package:flutter/material.dart';
import 'result_screen.dart';

class AnalyzingNailScreen extends StatefulWidget {
  const AnalyzingNailScreen({super.key});

  @override
  State<AnalyzingNailScreen> createState() => _AnalyzingNailScreenState();
}

class _AnalyzingNailScreenState extends State<AnalyzingNailScreen> with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_progressController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _isCompleted = true;
          });
        }
      });

    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color darkTeal = Color(0xFF1F484C);
    const Color mutedText = Color(0xFF718096);

    final double progressPercent = _progressAnimation.value;
    final int displayPercent = (progressPercent * 100).toInt();

    return Scaffold(
      backgroundColor: const Color(0xFFFCFDFF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top Action Row (Back button & title space)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
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
                        Icons.arrow_back_ios_new_rounded,
                        color: Color(0xFF1E293B),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Headers
              const Text(
                'Analyzing Nail',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1E293B),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Our AI is analyzing your nail image',
                style: TextStyle(
                  fontSize: 14,
                  color: mutedText,
                ),
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
                          // 1. Captured Nail Image (reusing result image)
                          Positioned.fill(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.asset(
                                  'assets/images/nail_analysis_result.png',
                                  fit: BoxFit.cover,
                                ),
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
                          // 3. Triple Horizontal Cyan Laser Lines
                          Positioned.fill(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildLaserLine(),
                                const SizedBox(height: 24),
                                _buildLaserLine(),
                                const SizedBox(height: 24),
                                _buildLaserLine(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Status Block (Analyzing details)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFF1F5F9)),
                ),
                child: Row(
                  children: [
                    // Circular indicator badge
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _isCompleted ? const Color(0xFFDCFCE7) : const Color(0xFFE6F4F8),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isCompleted ? Icons.check_circle_outline_rounded : Icons.auto_awesome_outlined,
                        color: _isCompleted ? const Color(0xFF15803D) : const Color(0xFF33A8C7),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isCompleted ? 'Analysis Complete!' : 'Analyzing...',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: darkTeal,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _isCompleted
                                ? 'Nail patterns successfully processed.'
                                : 'Detecting patterns and comparing with medical database',
                            style: const TextStyle(
                              fontSize: 13,
                              color: mutedText,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Progress Bar Row
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progressPercent,
                        minHeight: 12,
                        backgroundColor: const Color(0xFFE2E8F0),
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 45,
                    child: Text(
                      '$displayPercent%',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF3B82F6),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // View Results Action Button when completed
              if (_isCompleted)
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const ResultScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: darkTeal,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(27),
                      ),
                    ),
                    child: const Text(
                      'View Results',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                    ),
                  ),
                ),

              const SizedBox(height: 24),
              // Bottom Info Capsule
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.access_time_rounded,
                      color: mutedText,
                      size: 16,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'This usually takes 10–15 seconds',
                      style: TextStyle(
                        fontSize: 12,
                        color: mutedText,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLaserLine() {
    return Container(
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
    );
  }
}
