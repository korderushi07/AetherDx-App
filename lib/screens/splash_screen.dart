import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aetherdx/state/app_state.dart';
import 'package:aetherdx/core/network/api_service.dart';
import 'get_started_screen.dart';
import 'main_navigation_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _puzzleAnimation;
  late Animation<double> _logoAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // Staggered puzzle assembly curve
    _puzzleAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.70, curve: Curves.easeOutCubic),
    );

    // Fade-in curve for the medical icons and bottom logo
    _logoAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.70, 1.00, curve: Curves.easeIn),
    );

    // Start animation slightly after first frame to avoid native transition drops
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) {
          _controller.forward().then((_) {
            // Hold completed visual so that the total splash screen time is exactly 5 seconds
            // (400ms mount delay + 2000ms animation + 2600ms hold = 5000ms)
            Future.delayed(const Duration(milliseconds: 2600), () {
              _checkAuthAndNavigate();
            });
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkAuthAndNavigate() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString('app_language');
    if (savedLanguage != null) {
      AppState().language = savedLanguage;
    }
    
    final token = prefs.getString('auth_token');
    final email = prefs.getString('user_email');

    if (mounted) {
      if (token != null && email != null) {
        // Restore user details into AppState
        final appState = AppState();
        appState.email = email;
        final emailPrefix = email.split('@')[0];
        appState.username = emailPrefix;
        appState.name = emailPrefix[0].toUpperCase() + emailPrefix.substring(1);

        try {
          final profile = await ApiService.getUserProfile();
          if (profile != null) {
            appState.updateFromMap(profile);
          }
        } catch (e) {
          debugPrint("Error fetching profile during splash load: $e");
        }

        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const MainNavigationShell()),
          );
        }
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const GetStartedScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color darkBg = Color(0xFF2C4A4C);
    const Color greenAccent = Color(0xFF309B9E);
    const Color darkText = Color(0xFF1E293B);

    return Scaffold(
      backgroundColor: darkBg,
      body: Column(
        children: [
          // Top Illustration Section
          Expanded(
            flex: 75,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double w = constraints.maxWidth;
                final double h = constraints.maxHeight;
                final double leftW = w * 0.34;

                return Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _SplashIllustrationPainter(
                          animation: _puzzleAnimation,
                        ),
                      ),
                    ),
                    // Plus Icon (centered in Middle Left Box) - Fades in at the end
                    Positioned(
                      left: w * 0.05,
                      top: h * 0.43,
                      width: leftW * 0.92 - w * 0.05,
                      height: h * 0.22,
                      child: Center(
                        child: FadeTransition(
                          opacity: _logoAnimation,
                          child: const Icon(
                            Icons.add,
                            color: greenAccent,
                            size: 40,
                            weight: 800,
                          ),
                        ),
                      ),
                    ),
                    // Heart Icon (centered in Lower Left Box) - Fades in at the end
                    Positioned(
                      left: w * 0.05,
                      top: h * 0.65,
                      width: leftW * 0.92 - w * 0.05,
                      height: h * 0.27,
                      child: Center(
                        child: FadeTransition(
                          opacity: _logoAnimation,
                          child: const Icon(
                            Icons.favorite,
                            color: greenAccent,
                            size: 42,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // Bottom White Section
          Expanded(
            flex: 25,
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeTransition(
                    opacity: _logoAnimation,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Brand Logo (Image replaced as requested)
                        Image.asset(
                          'assets/images/app_logo.png',
                          width: 34,
                          height: 34,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'AetherDx',
                          style: GoogleFonts.outfit(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: darkText,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SplashIllustrationPainter extends CustomPainter {
  final Animation<double> animation;

  _SplashIllustrationPainter({
    required this.animation,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final double progress = animation.value;
    final double offset = 1.0 - progress;

    final Paint paintDarkBg = Paint()..color = const Color(0xFF2C4A4C);
    final Paint paintGreen = Paint()..color = const Color(0xFF309B9E);
    final Paint paintPeach = Paint()..color = const Color(0xFFFCE1DB);
    final Paint paintWhite = Paint()..color = Colors.white;

    // Fill background
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), paintDarkBg);

    // ==================== TOP HEADER STRIP (y: 0 to h*0.18) ====================
    final double topH = h * 0.18;
    final double colW = w * 0.25;

    // Col 0: Peach background + Green ribbon/tooth arch
    canvas.save();
    canvas.translate(0, -topH * offset); // slides down from top
    canvas.drawRect(Rect.fromLTWH(0, 0, colW, topH), paintPeach);
    canvas.restore();

    final Path ribbonPath = Path()
      ..moveTo(0, topH)
      ..lineTo(0, topH * 0.3)
      ..quadraticBezierTo(colW * 0.125, 0, colW * 0.25, topH * 0.3)
      ..quadraticBezierTo(colW * 0.375, topH * 0.6, colW * 0.5, topH * 0.3)
      ..quadraticBezierTo(colW * 0.625, 0, colW * 0.75, topH * 0.3)
      ..quadraticBezierTo(colW * 0.875, topH * 0.6, colW, topH * 0.3)
      ..lineTo(colW, topH)
      ..close();
    canvas.drawPath(ribbonPath, paintGreen);

    // Col 1: Diagonal split (Top-left Peach, Bottom-right Green + Dark circle)
    canvas.save();
    canvas.translate(0, -topH * offset); // slides down from top
    final Path col1Peach = Path()
      ..moveTo(colW, 0)
      ..lineTo(colW * 2, 0)
      ..lineTo(colW, topH)
      ..close();
    canvas.drawPath(col1Peach, paintPeach);
    canvas.restore();

    final Path col1Green = Path()
      ..moveTo(colW * 2, 0)
      ..lineTo(colW * 2, topH)
      ..lineTo(colW, topH)
      ..close();
    canvas.drawPath(col1Green, paintGreen);
    canvas.drawCircle(Offset(colW * 1.65, topH * 0.45), colW * 0.22, paintDarkBg);

    // Col 2: Green bg + Dark circle on left + Peach teardrop on right
    canvas.drawRect(Rect.fromLTWH(colW * 2, 0, colW, topH), paintGreen);
    canvas.drawCircle(Offset(colW * 2.35, topH * 0.45), colW * 0.22, paintDarkBg);

    canvas.save();
    canvas.translate(0, -topH * offset); // slides down from top
    final Path teardrop = Path()
      ..moveTo(colW * 3, topH)
      ..arcTo(
        Rect.fromCircle(center: Offset(colW * 3, topH), radius: colW * 0.85),
        -3.14159,
        1.5708,
        false,
      )
      ..close();
    canvas.drawPath(teardrop, paintPeach);
    canvas.restore();

    // Col 3: Dark bg + Peach triangle
    canvas.save();
    canvas.translate((w - colW * 3) * offset, 0); // slides from right
    final Path col3Peach = Path()
      ..moveTo(colW * 3.25, topH * 0.85)
      ..lineTo(w * 0.95, topH * 0.1)
      ..lineTo(w * 0.95, topH * 0.85)
      ..close();
    canvas.drawPath(col3Peach, paintPeach);
    canvas.restore();

    // ==================== LEFT VERTICAL COLUMN ====================
    final double leftW = w * 0.34;

    // Upper Left Shard
    canvas.save();
    canvas.translate(-leftW * offset, 0); // slides from left
    final Path upperShard = Path()
      ..moveTo(0, topH)
      ..lineTo(leftW * 0.85, topH)
      ..lineTo(leftW * 0.4, h * 0.43)
      ..lineTo(0, h * 0.43)
      ..close();
    canvas.drawPath(upperShard, paintPeach);
    canvas.restore();

    // Middle Left Plus Box (White/Light bg behind plus - remains static)
    final Rect plusBox = Rect.fromLTRB(w * 0.05, h * 0.43, leftW * 0.92, h * 0.65);
    canvas.drawRect(plusBox, Paint()..color = const Color(0xFFF4F6F6));

    // Lower Left Heart Box (Peach bg)
    canvas.save();
    canvas.translate(0, (h - h * 0.65) * offset); // slides from bottom
    final RRect heartBox = RRect.fromRectAndCorners(
      Rect.fromLTRB(w * 0.05, h * 0.65, leftW * 0.92, h * 0.92),
      bottomLeft: Radius.circular(w * 0.12),
      bottomRight: Radius.circular(w * 0.12),
    );
    canvas.drawRRect(heartBox, paintPeach);
    canvas.restore();

    // ==================== CENTRAL & RIGHT PROFILE FIGURE ====================
    final double cx = w * 0.60;
    final double cy = h * 0.44;
    final double yCut = cy + h * 0.02;

    // Concentric Green Headset/Hair (remains static)
    canvas.save();
    canvas.clipRect(Rect.fromLTRB(leftW * 0.8, topH, w, yCut));

    final double rOut = w * 0.38;
    final double rMid = w * 0.28;
    final double rIn = w * 0.20;

    canvas.drawCircle(Offset(cx, cy), rOut, paintGreen);
    canvas.drawCircle(Offset(cx, cy), rMid, paintDarkBg);
    canvas.drawCircle(Offset(cx, cy), rIn, paintGreen);

    canvas.restore();

    // Hair continuing down behind neck on right (remains static)
    final Path rightHair = Path()
      ..moveTo(cx + rMid, yCut)
      ..lineTo(cx + rOut, yCut)
      ..lineTo(cx + rOut, h * 0.72)
      ..lineTo(cx + rMid, h * 0.72)
      ..close();
    canvas.drawPath(rightHair, paintGreen);

    // Bottom right decorative element (White box/semicircle with green semicircle - remains static)
    final double brLeft = w * 0.76;
    final double brBottom = h * 0.94;
    final double brTop = h * 0.78;
    final Path whiteBead = Path()
      ..moveTo(brLeft, brBottom)
      ..lineTo(w, brBottom)
      ..lineTo(w, brTop)
      ..arcToPoint(Offset(brLeft, brTop), radius: Radius.circular((w - brLeft) / 2))
      ..close();
    canvas.drawPath(whiteBead, paintWhite);

    final double gRadius = (w - brLeft) * 0.35;
    canvas.drawCircle(Offset(brLeft + (w - brLeft) / 2, brBottom), gRadius, paintGreen);

    // Peach Face & Neck (slides from right)
    canvas.save();
    canvas.translate((w - cx) * 0.8 * offset, 0); // slides from right

    final Path facePath = Path()
      ..moveTo(cx + rMid, yCut)
      ..lineTo(w * 0.38, yCut) // Forehead / brow
      ..lineTo(w * 0.38, h * 0.55) // Nose bridge down
      ..lineTo(w * 0.26, h * 0.55) // Nose tip left
      ..lineTo(w * 0.26, h * 0.62) // Nose front down
      ..lineTo(w * 0.38, h * 0.62) // Under nose right
      ..lineTo(w * 0.38, h * 0.68) // Upper lip down
      ..lineTo(w * 0.44, h * 0.68) // Chin step right
      ..lineTo(w * 0.44, h * 0.88) // Neck front down
      ..lineTo(cx + w * 0.10, h * 0.88) // Neck bottom right
      ..lineTo(cx + w * 0.10, yCut) // Neck back up
      ..close();
    canvas.drawPath(facePath, paintPeach);

    // Eye (sitting just below yCut)
    final double eyeX = cx - w * 0.04;
    final double eyeY = yCut;
    final double eyeW = w * 0.12;
    final double eyeH = h * 0.07;

    final Path eyeWhite = Path()
      ..moveTo(eyeX - eyeW / 2, eyeY)
      ..lineTo(eyeX + eyeW / 2, eyeY)
      ..arcToPoint(
        Offset(eyeX - eyeW / 2, eyeY),
        radius: Radius.circular(eyeW / 2),
        clockwise: true,
      )
      ..close();
    canvas.drawPath(eyeWhite, paintWhite);

    // Green pupil
    canvas.drawCircle(Offset(eyeX, eyeY + eyeH * 0.45), eyeW * 0.28, paintGreen);
    // White eye highlight
    canvas.drawCircle(Offset(eyeX, eyeY + eyeH * 0.45), eyeW * 0.1, paintWhite);

    canvas.restore();

    // ==================== BOTTOM WHITE SHIRT / SHOULDERS ====================
    canvas.save();
    canvas.translate(0, (h - h * 0.85) * offset); // slides up from bottom
    final Path shirtPath = Path()
      ..moveTo(w * 0.32, h)
      ..lineTo(w * 0.32, h * 0.88)
      ..quadraticBezierTo(w * 0.32, h * 0.85, w * 0.40, h * 0.85)
      ..lineTo(cx + w * 0.15, h * 0.85)
      ..quadraticBezierTo(cx + w * 0.28, h * 0.85, cx + w * 0.28, h)
      ..lineTo(w * 0.32, h)
      ..close();
    canvas.drawPath(shirtPath, paintWhite);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SplashIllustrationPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}
