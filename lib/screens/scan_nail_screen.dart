import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aetherdx/core/theme/colors.dart';
import 'package:aetherdx/core/widgets/app_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:aetherdx/core/localization/translations.dart';
import 'image_adjust_screen.dart';

class ScanNailScreen extends StatefulWidget {
  final VoidCallback onBackPressed;

  const ScanNailScreen({
    super.key,
    required this.onBackPressed,
  });

  @override
  State<ScanNailScreen> createState() => _ScanNailScreenState();
}

class _ScanNailScreenState extends State<ScanNailScreen> {

  Future<void> _captureImage(ImageSource source) async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (pickedFile != null && mounted) {
        final bytes = await pickedFile.readAsBytes();
        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ImageAdjustScreen(
                imagePath: pickedFile.path,
                imageBytes: bytes,
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to access camera/gallery: $e'.tr()),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color lightBackground = AppColors.background;
    
    return Scaffold(
      backgroundColor: lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Top Immersive Header Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Button (White circular card with border)
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
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: AppColors.textPrimary,
                        size: 20,
                      ),
                    ),
                  ),
                  // Title Center
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'DIAGNOSTIC SCAN'.tr(),
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Align finger with scanner'.tr(),
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  // Help / Guide Button
                  GestureDetector(
                    onTap: () => _showTipsModal(context),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.info_outline_rounded,
                        color: AppColors.textPrimary,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // 2. Camera Viewfinder Screen Area
            Center(
              child: Container(
                width: 260,
                height: 310,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFC7F3F7), width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      blurRadius: 25,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Viewfinder Radial Aura Grid
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              colors: [
                                AppColors.primary.withValues(alpha: 0.05),
                                Colors.transparent,
                              ],
                              radius: 0.75,
                            ),
                          ),
                        ),
                      ),

                      // Centered Hand/Nail 3D Box Animation Guide
                      Positioned.fill(
                        child: const Center(
                          child: _BoxScannerAnimationWidget(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Active Frame Guide Pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.01),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF14B8A6),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'ALIGN SINGLE FINGERNAIL IN BOX'.tr(),
                    style: GoogleFonts.outfit(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
              child: AppButton(
                text: 'Start Scan'.tr(),
                onPressed: () {
                  _showPhotoSourceDialog(context);
                },
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showPhotoSourceDialog(BuildContext context) {
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
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Capture Nail Photo'.tr(),
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  'Choose your preferred input source:'.tr(),
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                AppButton(
                  text: 'Take a Photo'.tr(),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _captureImage(ImageSource.camera);
                  },
                ),
                const SizedBox(height: 12),
                AppButton(
                  text: 'Choose from Gallery'.tr(),
                  isPrimary: false,
                  onPressed: () {
                    Navigator.of(context).pop();
                    _captureImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Beautiful Bottom Sheet modal detailing professional photography parameters
  void _showTipsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Diagnostic Scanning Guide'.tr(),
                  style: GoogleFonts.outfit(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Follow these guidelines for optimal analysis results:'.tr(),
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                
                // 3D printed box scanner tip
                _buildTipRow(
                  icon: Icons.view_in_ar_rounded,
                  iconColor: const Color(0xFF14B8A6),
                  title: '3D Printed Box (Recommended)'.tr(),
                  description: 'Place your smartphone face-down on the top plate and slide your finger into the front opening slot.'.tr(),
                ),
                const SizedBox(height: 16),
                
                // Good Lighting tip
                _buildTipRow(
                  icon: Icons.wb_sunny_rounded,
                  iconColor: const Color(0xFFF59E0B),
                  title: 'Optimal Lighting'.tr(),
                  description: 'Place the hand under strong, direct overhead light. Avoid deep shadows or yellow tints.'.tr(),
                ),
                const SizedBox(height: 16),

                // Keep Steady tip
                _buildTipRow(
                  icon: Icons.center_focus_strong_rounded,
                  iconColor: AppColors.primary,
                  title: 'Focus & Clarity'.tr(),
                  description: 'Hold the phone steady. Ensure the fingernail is sharp and in clear focus (avoid motion blur).'.tr(),
                ),
                const SizedBox(height: 16),

                // Clean surfaces tip
                _buildTipRow(
                  icon: Icons.cleaning_services_rounded,
                  iconColor: const Color(0xFF38BDF8),
                  title: 'Clean Prep'.tr(),
                  description: 'Remove any nail polish, dirt, or stickers before scanning for accurate surface reading.'.tr(),
                ),
                const SizedBox(height: 28),

                AppButton(
                  text: 'Understand & Begin'.tr(),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTipRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.tr(),
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description.tr(),
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}



// 3D Box Scanner Guideline Animation widget
class _BoxScannerAnimationWidget extends StatefulWidget {
  const _BoxScannerAnimationWidget();

  @override
  State<_BoxScannerAnimationWidget> createState() => _BoxScannerAnimationWidgetState();
}

class _BoxScannerAnimationWidgetState extends State<_BoxScannerAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fingerProgress;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat();

    _fingerProgress = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0).chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 45,
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(1.0),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 0.0).chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 35,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 220,
      child: AnimatedBuilder(
        animation: _fingerProgress,
        builder: (context, child) {
          return CustomPaint(
            painter: _BoxScannerPainter(progress: _fingerProgress.value),
          );
        },
      ),
    );
  }
}

// Vector 3D Isometric Painter rendering phone scanner chassis and finger slide
class _BoxScannerPainter extends CustomPainter {
  final double progress;

  _BoxScannerPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paintDark = Paint()..color = const Color(0xFF334155); // Shadows (slate-700)
    final Paint paintMedium = Paint()..color = const Color(0xFF475569); // Main body (slate-600)
    final Paint paintLight = Paint()..color = const Color(0xFF64748B); // Top surfaces (slate-500)
    final Paint paintAccent = Paint()..color = const Color(0xFF155E63); // Brand teal phone tray
    final Paint paintPhone = Paint()..color = const Color(0xFFF1F5F9); // Phone back
    final Paint paintLens = Paint()..color = const Color(0xFF0F172A); // Camera lens
    final Paint paintFinger = Paint()..color = const Color(0xFFF3A382); // Finger skin tone
    final Paint paintFingerNail = Paint()..color = const Color(0xFFFDBA74); // Nail color
    final Paint paintHole = Paint()..color = const Color(0xFF090F11); // Dark opening hole

    // 1. Draw the bottom support plate of the L-shape (grey printed part)
    final Path bottomPlate = Path()
      ..moveTo(55, 140)
      ..lineTo(145, 100)
      ..lineTo(195, 120)
      ..lineTo(105, 160)
      ..close();
    canvas.drawPath(bottomPlate, paintMedium);

    // 2. Draw the front-left vertical box column (where finger slot resides)
    // Front-left face
    final Path frontLeftFace = Path()
      ..moveTo(25, 75)
      ..lineTo(75, 95)
      ..lineTo(75, 145)
      ..lineTo(25, 125)
      ..close();
    canvas.drawPath(frontLeftFace, paintDark);

    // Front-right face of the box column
    final Path frontRightFace = Path()
      ..moveTo(75, 95)
      ..lineTo(105, 82)
      ..lineTo(105, 132)
      ..lineTo(75, 145)
      ..close();
    canvas.drawPath(frontRightFace, paintMedium);

    // Top surface of the front box column
    final Path topBoxSurface = Path()
      ..moveTo(25, 75)
      ..lineTo(55, 62)
      ..lineTo(105, 82)
      ..lineTo(75, 95)
      ..close();
    canvas.drawPath(topBoxSurface, paintLight);

    // 3. Draw the finger slot/opening on the front-left face
    final Path slotHole = Path()
      ..moveTo(40, 105)
      ..lineTo(60, 113)
      ..lineTo(60, 133)
      ..lineTo(40, 125)
      ..close();
    canvas.drawPath(slotHole, paintHole);

    // 4. Draw the back vertical support column of the L-shape
    final Path backColumn = Path()
      ..moveTo(145, 60)
      ..lineTo(195, 80)
      ..lineTo(195, 120)
      ..lineTo(145, 100)
      ..close();
    canvas.drawPath(backColumn, paintDark);

    // 5. Draw the smartphone tray platform bridging the top
    final Path phonePlatform = Path()
      ..moveTo(45, 67)
      ..lineTo(175, 9)
      ..lineTo(205, 21)
      ..lineTo(75, 80)
      ..close();
    canvas.drawPath(phonePlatform, paintAccent);

    // 6. Draw the smartphone resting face-down in the tray
    final Path smartphone = Path()
      ..moveTo(52, 62)
      ..lineTo(168, 10)
      ..lineTo(193, 20)
      ..lineTo(77, 72)
      ..close();
    canvas.drawPath(smartphone, paintPhone);

    // Draw camera lens dot on the phone aligning over the viewfinder column
    canvas.drawCircle(const Offset(70, 58), 4.5, paintLens);

    // 7. Draw the animated finger inserting into the slot
    final double fingerX = 5.0 + (45.0 * progress);
    final double fingerY = 142.0 - (22.0 * progress);

    // Draw finger capsule pointing towards the slot direction
    canvas.save();
    canvas.translate(fingerX, fingerY);
    canvas.rotate(-0.35); // Angle aligned with the isometric slot

    // Draw skin tone finger base
    final Paint paintStroke = Paint()
      ..color = const Color(0xFF475569)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final RRect fingerCapsule = RRect.fromRectAndRadius(
      const Rect.fromLTWH(-40, -10, 50, 18),
      const Radius.circular(9),
    );
    canvas.drawRRect(fingerCapsule, paintFinger);
    canvas.drawRRect(fingerCapsule, paintStroke);

    // Draw fingernail on the inserting tip
    final RRect nail = RRect.fromRectAndRadius(
      const Rect.fromLTWH(0, -6, 8, 12),
      const Radius.circular(3),
    );
    canvas.drawRRect(nail, paintFingerNail);

    canvas.restore();

    // 8. Draw a pulsing green guidance arrow pointing to the opening
    if (progress < 0.8) {
      final double arrowAlpha = (1.0 - progress / 0.8).clamp(0.0, 1.0);
      final Paint arrowPaint = Paint()
        ..color = const Color(0xFF14B8A6).withValues(alpha: arrowAlpha)
        ..style = PaintingStyle.fill;

      final Path arrow = Path()
        ..moveTo(12, 120)
        ..lineTo(22, 110)
        ..lineTo(22, 116)
        ..lineTo(32, 116)
        ..lineTo(32, 124)
        ..lineTo(22, 124)
        ..lineTo(22, 130)
        ..close();
      canvas.drawPath(arrow, arrowPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _BoxScannerPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
