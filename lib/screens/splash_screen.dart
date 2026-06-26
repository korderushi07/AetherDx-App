import 'package:flutter/material.dart';
import 'dart:async';
import 'package:maroapp/core/theme/colors.dart';
import 'package:maroapp/core/theme/typography.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    });
  }

  Widget _buildCrossEmblem() {
    return SizedBox(
      width: 48,
      height: 48,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Horizontal bar
          Container(
            width: 48,
            height: 12,
            decoration: BoxDecoration(
              color: AppColors.textPrimary,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          // Vertical bar
          Container(
            width: 12,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.textPrimary,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          // Clean intersection center cover
          Container(
            width: 12,
            height: 12,
            color: AppColors.textPrimary,
          ),
          // Center Indigo AI dot
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.ai,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Centered branding elements
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCrossEmblem(),
                const SizedBox(height: 24),
                const Text(
                  'AetherDX',
                  style: AppTypography.display,
                ),
                const SizedBox(height: 8),
                const Text(
                  'NAIL HEALTH AI ANALYSIS',
                  style: AppTypography.overline,
                ),
              ],
            ),
          ),
          // Bottom loading track
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(seconds: 3),
              builder: (context, value, child) {
                return LinearProgressIndicator(
                  value: value,
                  backgroundColor: Colors.transparent,
                  color: AppColors.ai,
                  minHeight: 2,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
