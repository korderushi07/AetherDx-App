import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui';
import '../core/theme/colors.dart';
import '../core/theme/typography.dart';
import '../core/widgets/app_button.dart';
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
  bool _showGuidance = false;

  @override
  void initState() {
    super.initState();
    // 2s scan line controller, 1s pause status loop
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.05, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            _animationController.reset();
            _animationController.forward();
          }
        });
      }
    });

    _animationController.forward();

    // 1s delay guidance alert fade-in
    Timer(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _showGuidance = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showSimulationControl() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Simulation Control',
                  style: AppTypography.heading2,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Choose a quality check outcome to test the user flows:',
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                AppButton(
                  text: 'Simulate Success (Good Quality)',
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const AnalyzingNailScreen()),
                    );
                  },
                ),
                const SizedBox(height: 12),
                AppButton(
                  text: 'Simulate Alert (Poor Quality)',
                  isPrimary: false,
                  borderColor: AppColors.error,
                  textColor: AppColors.error,
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ImageQualityAlertScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Clinical dark camera base feed
      body: Stack(
        children: [
          // 1. Camera Feed Mock Background
          Positioned.fill(
            child: Opacity(
              opacity: 0.7,
              child: Image.asset(
                'assets/images/nail_to_scan.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 2. Viewfinder Alignment Card Frame (Centered)
          Center(
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white.withOpacity(0.6), width: 1.5),
                borderRadius: BorderRadius.circular(24),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  children: [
                    // Corner Viewfinder Brackets
                    Positioned.fill(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final double bracketSize = 20.0;
                          final double stroke = 3.0;
                          const Color bracketColor = AppColors.ai;

                          return Stack(
                            children: [
                              // Top Left
                              Positioned(
                                top: 8,
                                left: 8,
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
                                top: 8,
                                right: 8,
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
                                bottom: 8,
                                left: 8,
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
                                bottom: 8,
                                right: 8,
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
                    // Moving scan line with low glow
                    Positioned.fill(
                      child: AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Stack(
                            children: [
                              Positioned(
                                top: 220 * _animation.value,
                                left: 10,
                                right: 10,
                                child: Container(
                                  height: 2,
                                  decoration: BoxDecoration(
                                    color: AppColors.ai,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.ai.withOpacity(0.3),
                                        blurRadius: 4,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 3. Floating top bar action overlay
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: widget.onBackPressed,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Container(
                        width: 40,
                        height: 40,
                        color: Colors.white.withOpacity(0.25),
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                const Text(
                  'Scan Nail',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                GestureDetector(
                  onTap: _showSimulationControl,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        color: Colors.white.withOpacity(0.25),
                        child: const Text(
                          'Help',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 4. Shutter button & Guidance alert at the bottom
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Shutter capture trigger
                GestureDetector(
                  onTap: _showSimulationControl,
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Guidance banner capsule fading in after 1s
                AnimatedOpacity(
                  opacity: _showGuidance ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        color: Colors.black.withOpacity(0.4),
                        alignment: Alignment.center,
                        child: const Text(
                          'Align thumbnail inside the frame and hold steady',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
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
}
