import 'package:flutter/material.dart';
import 'dart:async';
import 'package:maroapp/core/theme/colors.dart';
import 'package:maroapp/core/theme/typography.dart';
import 'package:maroapp/core/widgets/app_button.dart';
import 'package:maroapp/core/widgets/app_card.dart';
import 'package:maroapp/core/widgets/animations.dart';
import 'result_screen.dart';

enum AnalysisStep {
  imageConfirmed,
  scanning,
  progressing,
  revealed,
}

class AnalyzingNailScreen extends StatefulWidget {
  const AnalyzingNailScreen({super.key});

  @override
  State<AnalyzingNailScreen> createState() => _AnalyzingNailScreenState();
}

class _AnalyzingNailScreenState extends State<AnalyzingNailScreen> {
  AnalysisStep _currentStep = AnalysisStep.imageConfirmed;
  double _progressValue = 0.0;
  bool _isCompleted = false;
  Timer? _progressTimer;
  int _elapsedMs = 0;

  @override
  void initState() {
    super.initState();
    _startSequence();
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    super.dispose();
  }

  void _startSequence() {
    const interval = Duration(milliseconds: 40);
    _progressTimer = Timer.periodic(interval, (timer) {
      _elapsedMs += 40;
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_elapsedMs <= 1200) {
          _currentStep = AnalysisStep.imageConfirmed;
          _progressValue = (_elapsedMs / 1200.0) * 0.25;
        } else if (_elapsedMs <= 3200) {
          _currentStep = AnalysisStep.scanning;
          _progressValue = 0.25 + (((_elapsedMs - 1200.0) / 2000.0) * 0.35);
        } else if (_elapsedMs < 4000) {
          _currentStep = AnalysisStep.progressing;
          _progressValue = 0.60 + (((_elapsedMs - 3200.0) / 800.0) * 0.40);
        } else {
          _currentStep = AnalysisStep.revealed;
          _progressValue = 1.0;
          _isCompleted = true;
          timer.cancel();
        }
      });
    });
  }

  String _getCenterLabel() {
    switch (_currentStep) {
      case AnalysisStep.imageConfirmed:
        return 'Validating';
      case AnalysisStep.scanning:
        return 'Detecting';
      case AnalysisStep.progressing:
        return 'Analyzing';
      case AnalysisStep.revealed:
        return 'Complete ✓';
    }
  }

  String _getStepDescription() {
    switch (_currentStep) {
      case AnalysisStep.imageConfirmed:
        return 'Checking image quality and clarity...';
      case AnalysisStep.scanning:
        return 'Identifying surface patterns and texture...';
      case AnalysisStep.progressing:
        return 'Running neural diagnostic models...';
      case AnalysisStep.revealed:
        return 'Analysis complete. Report is ready.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top Action Row
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
                        border: Border.all(color: AppColors.border, width: 1.0),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.textPrimary,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 36),

              // Title and subtles
              const Text(
                'Analyzing Nail',
                style: AppTypography.heading1,
              ),
              const SizedBox(height: 6),
              const Text(
                'Our AI is processing your scan',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 48),

              // Centered Circular progress ring
              Center(
                child: AetherProgressRing(
                  value: _progressValue,
                  size: 180,
                  strokeWidth: 4,
                  color: AppColors.ai,
                  backgroundColor: AppColors.secondaryBg,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isCompleted) ...[
                        TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0.9, end: 1.0),
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOutCubic,
                          builder: (context, scale, child) {
                            return Transform.scale(
                              scale: scale,
                              child: const Icon(
                                Icons.check_circle_rounded,
                                color: AppColors.success,
                                size: 44,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Complete ✓',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.success,
                          ),
                        ),
                      ] else ...[
                        Text(
                          '${(_progressValue * 100).toInt()}%',
                          style: AppTypography.display,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getCenterLabel(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ]
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 48),

              // Status card with step description
              AppCard(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Text(
                  _getStepDescription(),
                  style: AppTypography.body,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 48),

              // Bottom action button revealed at completion
              AnimatedOpacity(
                opacity: _isCompleted ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 250),
                child: _isCompleted
                    ? AppButton(
                        text: 'View Diagnostics',
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const ResultScreen()),
                          );
                        },
                      )
                    : const SizedBox(height: 52),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
