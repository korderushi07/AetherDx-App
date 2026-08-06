import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aetherdx/core/theme/colors.dart';
import 'package:aetherdx/core/widgets/app_button.dart';
import 'analyzing_nail_screen.dart';

class ImageAdjustScreen extends StatefulWidget {
  final String imagePath;
  final Uint8List imageBytes;

  const ImageAdjustScreen({
    super.key,
    required this.imagePath,
    required this.imageBytes,
  });

  @override
  State<ImageAdjustScreen> createState() => _ImageAdjustScreenState();
}

class _ImageAdjustScreenState extends State<ImageAdjustScreen> {
  final GlobalKey _repaintKey = GlobalKey();
  final TransformationController _transformationController = TransformationController();
  
  int _rotationTurns = 0;
  bool _isProcessing = false;
  
  // Tabs: 0 = Crop/Rotate, 1 = Adjust Lighting
  int _activeTab = 0;

  // Lighting adjustments
  double _brightness = 1.0; // range: 0.8 to 1.2
  double _contrast = 1.0;   // range: 0.8 to 1.2

  void _rotateImage() {
    setState(() {
      _rotationTurns = (_rotationTurns + 1) % 4;
    });
  }

  void _resetImage() {
    setState(() {
      _rotationTurns = 0;
      _brightness = 1.0;
      _contrast = 1.0;
      _transformationController.value = Matrix4.identity();
    });
  }

  // Generates a standard brightness/contrast color filter matrix
  List<double> _getColorMatrix(double brightness, double contrast) {
    double b = (brightness - 1.0) * 255;
    double c = contrast;
    double translate = b + 128 * (1.0 - c);
    return [
      c, 0, 0, 0, translate,
      0, c, 0, 0, translate,
      0, 0, c, 0, translate,
      0, 0, 0, 1, 0,
    ];
  }

  Future<void> _proceedToScan() async {
    if (_isProcessing) return;
    setState(() {
      _isProcessing = true;
    });

    try {
      await Future.delayed(const Duration(milliseconds: 100));

      final boundary = _repaintKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        throw Exception("RepaintBoundary rendering context not found.");
      }

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final croppedBytes = byteData?.buffer.asUint8List();

      if (croppedBytes != null && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => AnalyzingNailScreen(
              imagePath: widget.imagePath,
              imageBytes: croppedBytes,
            ),
          ),
        );
      } else {
        throw Exception("Failed to encode adjusted image.");
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adjusting photo: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color lightBg = AppColors.background;
    final Color activeTeal = AppColors.primary;
    
    return Scaffold(
      backgroundColor: lightBg,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Header Toolbar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: AppColors.textPrimary,
                        size: 20,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        'Adjust & Frame',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Fit nail within grid to scan',
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: _resetImage,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        'Reset',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // 2. Viewport crop frame with grid lines
            Stack(
              alignment: Alignment.center,
              children: [
                // 300x300 Crop box with repaint boundary constraints
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: activeTeal, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: activeTeal.withValues(alpha: 0.08),
                        blurRadius: 30,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Stack(
                      children: [
                        // Repaintboundary capturing exact square contents
                        Positioned.fill(
                          child: RepaintBoundary(
                            key: _repaintKey,
                            child: Container(
                              color: const Color(0xFFF8FAFC),
                              child: RotatedBox(
                                quarterTurns: _rotationTurns,
                                child: ColorFiltered(
                                  colorFilter: ColorFilter.matrix(_getColorMatrix(_brightness, _contrast)),
                                  child: InteractiveViewer(
                                    transformationController: _transformationController,
                                    minScale: 0.6,
                                    maxScale: 4.0,
                                    boundaryMargin: const EdgeInsets.all(180),
                                    child: Image.memory(
                                      widget.imageBytes,
                                      fit: BoxFit.contain,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Alignment 3x3 crop grid overlay
                        Positioned.fill(
                          child: IgnorePointer(
                            child: CustomPaint(
                              painter: _CropGridPainter(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            Text(
              'Pinch to zoom • Drag to pan inside frame',
              style: GoogleFonts.outfit(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),

            const Spacer(),

            // 3. Tab Specific Custom Adjustment Controls
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              margin: const EdgeInsets.symmetric(horizontal: 24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: _activeTab == 0
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Rotate 90 degrees Button
                        GestureDetector(
                          onTap: _rotateImage,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.01),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.rotate_right_rounded, color: activeTeal, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Rotate 90°',
                                  style: GoogleFonts.outfit(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Brightness slider
                        Row(
                          children: [
                            const Icon(Icons.wb_sunny_rounded, color: AppColors.textSecondary, size: 18),
                            const SizedBox(width: 12),
                            Expanded(
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: activeTeal,
                                  inactiveTrackColor: const Color(0xFFE2E8F0),
                                  thumbColor: activeTeal,
                                  trackHeight: 3,
                                ),
                                child: Slider(
                                  value: _brightness,
                                  min: 0.8,
                                  max: 1.2,
                                  onChanged: (val) {
                                    setState(() {
                                      _brightness = val;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 32,
                              child: Text(
                                '${((_brightness - 1.0) * 100).round() > 0 ? "+" : ""}${((_brightness - 1.0) * 100).round()}%',
                                style: GoogleFonts.outfit(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Contrast slider
                        Row(
                          children: [
                            const Icon(Icons.contrast_rounded, color: AppColors.textSecondary, size: 18),
                            const SizedBox(width: 12),
                            Expanded(
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: activeTeal,
                                  inactiveTrackColor: const Color(0xFFE2E8F0),
                                  thumbColor: activeTeal,
                                  trackHeight: 3,
                                ),
                                child: Slider(
                                  value: _contrast,
                                  min: 0.8,
                                  max: 1.2,
                                  onChanged: (val) {
                                    setState(() {
                                      _contrast = val;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 32,
                              child: Text(
                                '${((_contrast - 1.0) * 100).round() > 0 ? "+" : ""}${((_contrast - 1.0) * 100).round()}%',
                                style: GoogleFonts.outfit(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),

            const SizedBox(height: 16),

            // 4. Tab selection icons (Crop/Rotate vs Lighting sliders)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => setState(() => _activeTab = 0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    decoration: BoxDecoration(
                      color: _activeTab == 0 ? const Color(0xFFEDF8F9) : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.crop_rotate_rounded,
                          color: _activeTab == 0 ? activeTeal : AppColors.textSecondary,
                          size: 20,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Crop & Rotate',
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _activeTab == 0 ? AppColors.textPrimary : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 32),
                GestureDetector(
                  onTap: () => setState(() => _activeTab = 1),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    decoration: BoxDecoration(
                      color: _activeTab == 1 ? const Color(0xFFEDF8F9) : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.tune_rounded,
                          color: _activeTab == 1 ? activeTeal : AppColors.textSecondary,
                          size: 20,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Adjust Light',
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _activeTab == 1 ? AppColors.textPrimary : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const Spacer(),

            // 5. Proceed scan button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: _isProcessing
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(activeTeal),
                      ),
                    )
                  : AppButton(
                      text: 'Proceed to Scan',
                      icon: Icons.check_rounded,
                      onPressed: _proceedToScan,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter drawing standard 3x3 crop alignment grid lines
class _CropGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.15)
      ..strokeWidth = 1.0;

    final double w = size.width;
    final double h = size.height;

    // Vertical lines
    canvas.drawLine(Offset(w / 3, 0), Offset(w / 3, h), paint);
    canvas.drawLine(Offset(2 * w / 3, 0), Offset(2 * w / 3, h), paint);

    // Horizontal lines
    canvas.drawLine(Offset(0, h / 3), Offset(w, h / 3), paint);
    canvas.drawLine(Offset(0, 2 * h / 3), Offset(w, 2 * h / 3), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
