import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:aetherdx/core/theme/colors.dart';
import 'package:aetherdx/core/theme/typography.dart';
import 'package:aetherdx/core/theme/radius.dart';
import 'package:aetherdx/core/theme/shadows.dart';
import 'package:aetherdx/core/theme/spacing.dart';
import 'package:aetherdx/core/widgets/app_button.dart';
import 'package:aetherdx/core/widgets/app_card.dart';
import 'package:aetherdx/core/theme/motion.dart';
import 'package:aetherdx/core/widgets/animations.dart';
import 'package:aetherdx/core/network/api_service.dart';
import 'image_quality_alert_screen.dart';
import 'result_screen.dart';

enum AnalysisStep {
  imageConfirmed,
  scanning,
  progressing,
  revealed,
}

class AnalyzingNailScreen extends StatefulWidget {
  final String imagePath;
  final Uint8List? imageBytes;
  const AnalyzingNailScreen({
    super.key,
    required this.imagePath,
    this.imageBytes,
  });

  @override
  State<AnalyzingNailScreen> createState() => _AnalyzingNailScreenState();
}

class _AnalyzingNailScreenState extends State<AnalyzingNailScreen> {
  AnalysisStep _currentStep = AnalysisStep.imageConfirmed;
  double _progressValue = 0.0;
  bool _isCompleted = false;
  Map<String, dynamic>? _predictionResult;

  @override
  void initState() {
    super.initState();
    _startSequence();
  }

  Map<String, dynamic> _mapModelResult(String predictedClass, double confidence) {
    final int match = (confidence * 100).toInt();
    final String confidenceLabel = confidence >= 0.85 ? 'High confidence' : 'Moderate confidence';
    
    switch (predictedClass) {
      case 'Psoriasis':
        return {
          'conditionName': 'Nail Psoriasis',
          'matchPercentage': match,
          'confidenceLabel': confidenceLabel,
          'description': 'A chronic autoimmune condition that affects nail cells, causing changes in appearance like pitting or scaling.',
          'keySigns': 'Pitting, yellow-brown discoloration, and crumbling nail texture',
          'nextSteps': 'Consult a dermatologist for a focused clinical skin examination',
          'careTips': 'Keep your hands well-moisturized, trim nails straight, and avoid mechanical injury',
        };
      case 'Liver Disease':
        return {
          'conditionName': 'Terry\'s Nails (Possible Liver Health Sign)',
          'matchPercentage': match,
          'confidenceLabel': confidenceLabel,
          'description': 'A structural nail change where the nail plate appears pale/white except for a thin dark band at the tip, which can correspond to metabolic or liver factors.',
          'keySigns': 'Pale white nail bed, narrow pink/red distal band, loss of half-moon lunula',
          'nextSteps': 'Consult a general practitioner or gastroenterologist for standard liver function tests',
          'careTips': 'Maintain a balanced nutritious diet, limit sodium/saturated fats, and strictly avoid alcohol',
        };
      case 'Healthy':
      default:
        return {
          'conditionName': 'Healthy Nails',
          'matchPercentage': match,
          'confidenceLabel': confidenceLabel,
          'description': 'Your nail structure and texture appear completely normal and healthy, showing no signs of systemic conditions.',
          'keySigns': 'Smooth and even nail plate, pink nail beds, firm and flexible tip',
          'nextSteps': 'Maintain your current daily nail hygiene and healthy balanced diet',
          'careTips': 'Keep hands clean and moisturized, avoid aggressive cleaning under nails, and let nails breathe between polishes',
        };
    }
  }

  void _startSequence() async {
    // Step 1: Image confirmed (starts immediately, checkmark fades in over 250ms)
    // Hold step 1 for 1.2s to show verified status
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() {
      _currentStep = AnalysisStep.scanning;
    });

    // Start backend API analysis call in the background
    final apiFuture = ApiService.predictNail(
      widget.imagePath,
      imageBytes: widget.imageBytes,
      generateXai: true,
    );

    // Step 2: AI Scanning (animated scan line, non-looping after 2s)
    await Future.delayed(const Duration(milliseconds: 2000));
    if (!mounted) return;
    setState(() {
      _currentStep = AnalysisStep.progressing;
      _progressValue = 0.5; // Set to 50% while backend finishes
    });

    try {
      // Wait for prediction API to finish
      final response = await apiFuture;
      final predictedClass = response['predicted_class'] as String?;
      final confidence = (response['confidence'] as num?)?.toDouble() ?? 0.0;
      final gradcamOverlay = response['gradcam_overlay'] as String?;

      // Quality Warning Case: If confidence is too low (< 70%), route directly to alert screen
      if (confidence < 0.70) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const ImageQualityAlertScreen()),
          );
        }
        return;
      }

      // Populate prediction details
      _predictionResult = _mapModelResult(predictedClass ?? 'Healthy', confidence);
      _predictionResult!['gradcam_overlay'] = gradcamOverlay;

      // Finish progress animation (move progress value to 100%)
      if (mounted) {
        setState(() {
          _progressValue = 1.0;
        });
        await Future.delayed(const Duration(milliseconds: 400));
        if (mounted) {
          setState(() {
            _currentStep = AnalysisStep.revealed;
            _isCompleted = true;
          });
        }
      }
    } catch (e) {
      // On connection errors, server errors, or invalid responses, route to quality alert screen
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const ImageQualityAlertScreen()),
        );
      }
    }
  }

  String _getStepTitle() {
    switch (_currentStep) {
      case AnalysisStep.imageConfirmed:
        return 'Image Confirmed';
      case AnalysisStep.scanning:
        return 'AI Scanning...';
      case AnalysisStep.progressing:
        return 'Analyzing Patterns...';
      case AnalysisStep.revealed:
        return 'Analysis Complete!';
    }
  }

  String _getStepDescription() {
    switch (_currentStep) {
      case AnalysisStep.imageConfirmed:
        return 'Nail photo quality checked and validated.';
      case AnalysisStep.scanning:
        return 'Detecting patterns and comparing with medical database.';
      case AnalysisStep.progressing:
        return 'Processing structures against classification models.';
      case AnalysisStep.revealed:
        return 'Nail patterns successfully processed.';
    }
  }

  IconData _getStepIcon() {
    if (_currentStep == AnalysisStep.revealed) {
      return Icons.check_circle_outline_rounded;
    }
    return Icons.auto_awesome_outlined;
  }

  Color _getStepIconColor() {
    if (_currentStep == AnalysisStep.revealed) {
      return AppColors.success;
    }
    return AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
            vertical: AppSpacing.screenPadding,
          ),
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
                        boxShadow: [AppShadows.soft],
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
              const SizedBox(height: 16),

              // Headers
              const Text(
                'Analyzing Nail',
                style: AppTypography.screenTitle,
              ),
              const SizedBox(height: 8),
              const Text(
                'Our AI is analyzing your nail image',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 28),

              // Viewfinder Scanner Section Card
              AppCard(
                backgroundColor: AppColors.secondaryBg,
                padding: const EdgeInsets.all(24.0),
                child: Center(
                  child: Container(
                    width: 230,
                    height: 230,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: AppRadius.cardBorderRadius,
                    ),
                    child: ClipRRect(
                      borderRadius: AppRadius.cardBorderRadius,
                      child: Stack(
                        children: [
                          // 1. Captured Nail Image from file or memory source
                          Positioned.fill(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: ClipRRect(
                                borderRadius: AppRadius.imageBorderRadius,
                                child: widget.imageBytes != null
                                    ? Image.memory(
                                        widget.imageBytes!,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        File(widget.imagePath),
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          ),

                          // Image Confirmed Checkmark Overlay (Step 1)
                          if (_currentStep == AnalysisStep.imageConfirmed)
                            Positioned.fill(
                              child: Container(
                                color: Colors.black.withValues(alpha: 0.15),
                                child: Center(
                                  child: TweenAnimationBuilder<double>(
                                    tween: Tween<double>(begin: 0.0, end: 1.0),
                                    duration: const Duration(milliseconds: 250),
                                    builder: (context, value, child) {
                                      return Opacity(
                                        opacity: value,
                                        child: Transform.scale(
                                          scale: 0.95 + (0.05 * value),
                                          child: Container(
                                            padding: const EdgeInsets.all(16),
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.check_circle_rounded,
                                              color: AppColors.success,
                                              size: 48,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),

                          // 2. Corner Viewfinder Brackets (Step 2)
                          if (_currentStep == AnalysisStep.scanning)
                            Positioned.fill(
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  final double bracketSize = 24.0;
                                  final double stroke = 4.0;
                                  const Color bracketColor = AppColors.primary;

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
                          if (_currentStep == AnalysisStep.scanning)
                            Positioned.fill(
                              child: TweenAnimationBuilder<double>(
                                tween: Tween<double>(begin: 0.05, end: 0.95),
                                duration: const Duration(seconds: 2),
                                builder: (context, value, child) {
                                  return Stack(
                                    children: [
                                      Positioned(
                                        top: value * 230.0,
                                        left: 12,
                                        right: 12,
                                        child: _buildLaserLine(),
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
              ),
              const SizedBox(height: 32),

              // Status Block (Analyzing details)
              AppCard(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    // Circular indicator badge
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _isCompleted ? const Color(0xFFDCFCE7) : AppColors.secondaryBg,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getStepIcon(),
                        color: _getStepIconColor(),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getStepTitle(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getStepDescription(),
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
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
                      child: AnimatedProgressBar(
                        value: _progressValue,
                        minHeight: 12,
                        backgroundColor: const Color(0xFFE2E8F0),
                        valueColor: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 45,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.0, end: _progressValue),
                      duration: const Duration(milliseconds: 800),
                      curve: AetherMotion.enter,
                      builder: (context, value, child) {
                        return Text(
                          '${(value * 100).toInt()}%',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // View Results Action Button when completed
              if (_isCompleted && _predictionResult != null)
                FadeSlideWidget(
                  delay: const Duration(milliseconds: 100),
                  slideDistance: AetherMotion.slideDistanceSmall,
                  child: AppButton(
                    text: 'View Results',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ResultScreen(
                            conditionName: _predictionResult!['conditionName'],
                            matchPercentage: _predictionResult!['matchPercentage'],
                            confidenceLabel: _predictionResult!['confidenceLabel'],
                            description: _predictionResult!['description'],
                            keySigns: _predictionResult!['keySigns'],
                            nextSteps: _predictionResult!['nextSteps'],
                            careTips: _predictionResult!['careTips'],
                            imagePath: widget.imagePath,
                            imageBytes: widget.imageBytes,
                            gradcamOverlay: _predictionResult!['gradcam_overlay'],
                          ),
                        ),
                      );
                    },
                  ),
                ),

              const SizedBox(height: 24),
              // Bottom Info Capsule
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.secondaryBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      color: AppColors.textSecondary,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'This usually takes 10–15 seconds',
                      style: AppTypography.caption.copyWith(
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
