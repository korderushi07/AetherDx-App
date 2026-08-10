import 'dart:async';
import 'package:flutter/material.dart';
import '../core/theme/colors.dart';
import '../core/theme/typography.dart';
import '../core/theme/spacing.dart';
import '../core/localization/translations.dart';
import 'specialists_screen.dart';

class FindingSpecialistsScreen extends StatefulWidget {
  final String conditionName;
  const FindingSpecialistsScreen({super.key, this.conditionName = 'Possible Psoriasis'});

  @override
  State<FindingSpecialistsScreen> createState() => _FindingSpecialistsScreenState();
}

class _FindingSpecialistsScreenState extends State<FindingSpecialistsScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _progressController;
  late Animation<double> _pulseAnimation;
  
  int _currentStatusIndex = 0;
  Timer? _statusTimer;

  final List<String> _statusMessages = [
    '• Getting your location...',
    '• Searching nearby specialists...',
    '• Checking clinic availability...',
    '• Preparing recommendations...',
  ];

  @override
  void initState() {
    super.initState();

    // Pulse animation controller for the medical scanner illustration
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 1.0, end: 2.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOut),
    );

    // Progress bar controller to run from 0 to 1 over 2 seconds
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _progressController.forward();

    // Status message rotator every 1.2 seconds
    _statusTimer = Timer.periodic(const Duration(milliseconds: 1200), (timer) {
      if (mounted) {
        setState(() {
          _currentStatusIndex = (_currentStatusIndex + 1) % _statusMessages.length;
        });
      }
    });

    _startSimulatedFetch();
  }

  Future<void> _startSimulatedFetch() async {
    // Simulated loading delay of 2 seconds
    // This logic is isolated so it can later be replaced with a real backend call:
    // await ClinicRepository().fetchNearbyClinics();
    await Future.delayed(const Duration(milliseconds: 1000));

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => SpecialistsScreen(
            conditionName: widget.conditionName,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _progressController.dispose();
    _statusTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
          child: Column(
            children: [
              const Spacer(flex: 2),
              
              // Animated medical illustration / radar scanner placeholder
              Center(
                child: SizedBox(
                  width: 160,
                  height: 160,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Pulsating ripple background
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Container(
                            width: 64 * _pulseAnimation.value,
                            height: 64 * _pulseAnimation.value,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary.withOpacity(
                                (1.0 - (_pulseAnimation.value - 1.0) / 1.2).clamp(0.0, 0.2),
                              ),
                            ),
                          );
                        },
                      ),
                      
                      // Outer pulse ripple (delayed / secondary effect)
                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          final scale = (_pulseAnimation.value + 0.4) > 2.2 
                              ? (_pulseAnimation.value - 0.8) 
                              : (_pulseAnimation.value + 0.4);
                          return Container(
                            width: 64 * scale,
                            height: 64 * scale,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary.withOpacity(
                                (1.0 - (scale - 1.0) / 1.2).clamp(0.0, 0.1),
                              ),
                            ),
                          );
                        },
                      ),

                      // Solid circle container for medical icon
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.15),
                              blurRadius: 20,
                              spreadRadius: 2,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          border: Border.all(
                            color: AppColors.secondaryBg,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.medical_services_rounded,
                          color: AppColors.primary,
                          size: 34,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.gapLarge),

              // Title
              Text(
                'Finding nearby dermatologists...'.tr(),
                style: AppTypography.sectionHeading.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.gapMedium),

              // Subtitle
              Text(
                "We're locating trusted skin specialists near your current location.".tr(),
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Progress Indicator
              SizedBox(
                width: 200,
                child: AnimatedBuilder(
                  animation: _progressController,
                  builder: (context, child) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: _progressController.value,
                        minHeight: 6,
                        backgroundColor: AppColors.secondaryBg,
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    );
                  },
                ),
              ),

              const Spacer(flex: 3),

              // Rotating Status Message display at bottom
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.0, 0.2),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      ),
                    );
                  },
                  child: Text(
                    _statusMessages[_currentStatusIndex].tr(),
                    key: ValueKey<int>(_currentStatusIndex),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
