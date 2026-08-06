import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aetherdx/core/localization/translations.dart';
import 'package:aetherdx/core/theme/colors.dart';
import 'package:aetherdx/core/theme/radius.dart';
import 'package:aetherdx/core/theme/shadows.dart';
import 'package:aetherdx/core/widgets/app_button.dart';
import 'package:aetherdx/core/network/api_service.dart';
import 'package:aetherdx/state/app_state.dart';
import 'main_navigation_shell.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = true;
  final bool _isSignUp = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleAuthAction() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both email and password.'.tr())),
      );
      return;
    }

    if (_isSignUp && password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password must be at least 6 characters.'.tr())),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (_isSignUp) {
        // Register user
        final success = await ApiService.register(email, password);
        if (success) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Account created successfully! Logging you in...'.tr()),
                backgroundColor: AppColors.primary,
              ),
            );
          }
          // Login automatically
          final token = await ApiService.login(email, password);
          if (token != null) {
            _completeAuthFlow(email);
          }
        }
      } else {
        // Log in user
        final token = await ApiService.login(email, password);
        if (token != null) {
          _completeAuthFlow(email);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _completeAuthFlow(String email) async {
    // Populate AppState
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
      debugPrint("Error fetching profile during login auth flow: $e");
    }

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainNavigationShell()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 36),
              // Brand Logo Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/app_logo.png',
                    width: 38,
                    height: 38,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'AetherDx',
                    style: GoogleFonts.outfit(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF000000),
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),

              // Email Input
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Email'.tr(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppRadius.inputBorderRadius,
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [AppShadows.soft],
                ),
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(fontSize: 15, color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Enter your email'.tr(),
                    hintStyle: const TextStyle(color: AppColors.placeholder, fontSize: 15),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Password Input
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Password'.tr(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: AppRadius.inputBorderRadius,
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [AppShadows.soft],
                ),
                child: TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: const TextStyle(fontSize: 15, color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Enter your password'.tr(),
                    hintStyle: const TextStyle(color: AppColors.placeholder, fontSize: 15),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Remember Me & Forgot Password
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _rememberMe = !_rememberMe;
                      });
                    },
                    child: Row(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: _rememberMe ? AppColors.primary : Colors.transparent,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: _rememberMe ? AppColors.primary : const Color(0xFFCBD5E0),
                              width: 2,
                            ),
                          ),
                          child: _rememberMe
                              ? const Icon(Icons.check, size: 16, color: Colors.white)
                              : null,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Remember me'.tr(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => _showForgotPasswordSheet(context),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Forgot password?'.tr(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Sign In / Sign Up Button
              AppButton(
                text: _isLoading
                    ? (_isSignUp ? 'Creating account...'.tr() : 'Signing in...'.tr())
                    : (_isSignUp ? 'Sign up'.tr() : 'Login'.tr()),
                onPressed: () {
                  if (!_isLoading) {
                    _handleAuthAction();
                  }
                },
              ),
              const SizedBox(height: 28),

              // Divider
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey[200], thickness: 1.5)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'OR'.tr(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.placeholder,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey[200], thickness: 1.5)),
                ],
              ),
              const SizedBox(height: 24),

              // Continue with Google
              _buildSocialButton(
                iconWidget: _buildGoogleLogo(),
                label: 'Continue with Google'.tr(),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Google Sign In is unavailable now'.tr()),
                      backgroundColor: AppColors.primary,
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
              const SizedBox(height: 14),

              // Continue with Apple
              _buildSocialButton(
                iconWidget: const Icon(Icons.apple, size: 24, color: Colors.black),
                label: 'Continue with Apple'.tr(),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Apple Sign In is unavailable now'.tr()),
                      backgroundColor: Colors.black,
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
              const SizedBox(height: 36),

              // Footer Sign Up / Sign In toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ".tr(),
                    style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const SignupScreen()),
                      );
                    },
                    child: Text(
                      'Sign up'.tr(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showForgotPasswordSheet(BuildContext context) {
    final emailController = TextEditingController(text: _emailController.text.trim());
    final otpController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final sheetFormKey = GlobalKey<FormState>();

    bool isRequestingOtp = false;
    bool isResetting = false;
    bool otpSent = false;
    String? generatedOtp;
    bool obscurePassword = true;
    bool obscureConfirmPassword = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setSheetState) {
            InputDecoration buildInputDecoration(String hint, {Widget? suffixIcon}) {
              return InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.error),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.error, width: 1.5),
                ),
                suffixIcon: suffixIcon,
              );
            }

            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding: EdgeInsets.fromLTRB(28, 20, 28, MediaQuery.of(context).viewInsets.bottom + 24),
              child: SingleChildScrollView(
                child: Form(
                  key: sheetFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Reset Password'.tr(),
                            style: GoogleFonts.outfit(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      if (!otpSent) ...[
                        Text(
                          'Enter your registered email address below, and we will generate a password reset verification code.'.tr(),
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Email Field
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: buildInputDecoration('Email Address'.tr()),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Email is required'.tr();
                            }
                            if (!RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(value.trim())) {
                              return 'Enter a valid email address'.tr();
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Action Button
                        AppButton(
                          text: isRequestingOtp ? 'Generating Code...'.tr() : 'Send Reset Code'.tr(),
                          onPressed: () async {
                            if (isRequestingOtp) return;
                            if (sheetFormKey.currentState!.validate()) {
                              setSheetState(() => isRequestingOtp = true);
                              try {
                                final otp = await ApiService.forgotPassword(emailController.text.trim());
                                setSheetState(() {
                                  generatedOtp = otp;
                                  otpSent = true;
                                });
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(e.toString().replaceAll('Exception: ', '')),
                                      backgroundColor: AppColors.error,
                                    ),
                                  );
                                }
                              } finally {
                                setSheetState(() => isRequestingOtp = false);
                              }
                            }
                          },
                        ),
                      ] else ...[
                        // OTP generated info box
                        if (generatedOtp != null)
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 20),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFBFDBFE)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.info_outline_rounded, color: Color(0xFF2563EB), size: 18),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Verification Code (OTP)'.tr(),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1E3A8A),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'A code has been generated. Use the code below to reset your password:'.tr(),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF1E3A8A),
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: const Color(0xFF93C5FD)),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        generatedOtp!,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 4.0,
                                          color: Color(0xFF1E3A8A),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.copy_rounded, color: Color(0xFF2563EB)),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        onPressed: () {
                                          Clipboard.setData(ClipboardData(text: generatedOtp!));
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Code copied to clipboard!'.tr()),
                                              duration: const Duration(seconds: 1),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                        Text(
                          'Verification Code'.tr(),
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: otpController,
                          keyboardType: TextInputType.number,
                          decoration: buildInputDecoration('Enter 6-digit code'.tr()),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Verification code is required'.tr();
                            }
                            if (value.trim().length != 6) {
                              return 'Enter the 6-digit code'.tr();
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        Text(
                          'New Password'.tr(),
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: passwordController,
                          obscureText: obscurePassword,
                          decoration: buildInputDecoration(
                            'Enter new password'.tr(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscurePassword ? Icons.visibility_off : Icons.visibility,
                                color: const Color(0xFF64748B),
                                size: 20,
                              ),
                              onPressed: () {
                                setSheetState(() => obscurePassword = !obscurePassword);
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'New password is required'.tr();
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters'.tr();
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        Text(
                          'Confirm New Password'.tr(),
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: confirmPasswordController,
                          obscureText: obscureConfirmPassword,
                          decoration: buildInputDecoration(
                            'Confirm new password'.tr(),
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                                color: const Color(0xFF64748B),
                                size: 20,
                              ),
                              onPressed: () {
                                setSheetState(() => obscureConfirmPassword = !obscureConfirmPassword);
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please confirm your new password'.tr();
                            }
                            if (value != passwordController.text) {
                              return 'Passwords do not match'.tr();
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        AppButton(
                          text: isResetting ? 'Resetting Password...'.tr() : 'Reset Password'.tr(),
                          onPressed: () async {
                            if (isResetting) return;
                            if (sheetFormKey.currentState!.validate()) {
                              setSheetState(() => isResetting = true);
                              try {
                                final success = await ApiService.resetPassword(
                                  emailController.text.trim(),
                                  otpController.text.trim(),
                                  passwordController.text.trim(),
                                );
                                if (success) {
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Password reset successfully! Log in now.'.tr()),
                                        backgroundColor: AppColors.success,
                                        duration: const Duration(seconds: 3),
                                      ),
                                    );
                                  }
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(e.toString().replaceAll('Exception: ', '')),
                                      backgroundColor: AppColors.error,
                                    ),
                                  );
                                }
                              } finally {
                                setSheetState(() => isResetting = false);
                              }
                            }
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSocialButton({
    required Widget iconWidget,
    required String label,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.buttonBorderRadius,
          side: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.buttonBorderRadius,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconWidget,
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleLogo() {
    return SizedBox(
      width: 22,
      height: 22,
      child: CustomPaint(painter: _GoogleLogoPainter()),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double center = size.width / 2;
    final double strokeWidth = size.width * 0.22;
    final double radius = (size.width - strokeWidth) / 2;
    final Rect arcRect = Rect.fromCircle(
      center: Offset(center, center),
      radius: radius,
    );

    final Paint bluePaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    final Paint greenPaint = Paint()
      ..color = const Color(0xFF34A853)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    final Paint yellowPaint = Paint()
      ..color = const Color(0xFFFBBC05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    final Paint redPaint = Paint()
      ..color = const Color(0xFFEA4335)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    // Blue: 0 deg (0.0 rad) to ~46 deg (0.80 rad)
    canvas.drawArc(arcRect, 0.0, 0.80, false, bluePaint);
    // Green: 46 deg (0.80 rad) to 135 deg (2.35 rad) -> sweep = 1.55
    canvas.drawArc(arcRect, 0.80, 1.55, false, greenPaint);
    // Yellow: 135 deg (2.35 rad) to 225 deg (3.93 rad) -> sweep = 1.58
    canvas.drawArc(arcRect, 2.35, 1.58, false, yellowPaint);
    // Red: 225 deg (3.93 rad) to ~324 deg (5.65 rad) -> sweep = 1.72
    canvas.drawArc(arcRect, 3.93, 1.72, false, redPaint);

    // Blue horizontal bar
    canvas.drawLine(
      Offset(center, center),
      Offset(center + radius + strokeWidth / 2, center),
      Paint()
        ..color = const Color(0xFF4285F4)
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
