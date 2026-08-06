import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aetherdx/core/localization/translations.dart';
import 'package:aetherdx/core/theme/colors.dart';
import 'package:aetherdx/core/theme/radius.dart';
import 'package:aetherdx/core/theme/shadows.dart';
import 'package:aetherdx/core/theme/typography.dart';
import 'package:aetherdx/core/widgets/app_button.dart';
import 'package:aetherdx/core/widgets/app_bar.dart';
import 'package:aetherdx/core/network/api_service.dart';
import 'package:aetherdx/state/app_state.dart';
import 'login_screen.dart';
import 'main_navigation_shell.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  int _currentStep = 0;
  bool _isLoading = false;

  // Global Keys for Forms
  final _step1FormKey = GlobalKey<FormState>();
  final _step2FormKey = GlobalKey<FormState>();
  final _step3FormKey = GlobalKey<FormState>();

  // Step 1: Account Details Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String _selectedCountryCode = '+91';

  // Step 2: Personal Info State
  DateTime? _selectedDob;
  String? _selectedGender;

  final List<String> _genders = ['Male', 'Female', 'Other', 'Prefer not to say'];

  // Step 3: Consent State
  bool _consentTerms = false;
  bool _consentStorage = false;
  bool _consentMedical = false;

  @override
  void dispose() {
    // Step 1
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  // --- Step Navigation Functions ---
  void _nextStep() {
    if (_currentStep == 0) {
      if (_step1FormKey.currentState!.validate()) {
        setState(() => _currentStep = 1);
      }
    } else if (_currentStep == 1) {
      if (_step2FormKey.currentState!.validate()) {
        setState(() => _currentStep = 2);
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  void _showSnackBar(String message, {Color color = AppColors.error}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  Future<void> _handleRegister() async {
    if (!_step3FormKey.currentState!.validate()) return;

    if (!_consentTerms || !_consentStorage || !_consentMedical) {
      _showSnackBar('Please agree to all terms and consents to proceed.'.tr());
      return;
    }

    setState(() => _isLoading = true);

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text;

      // 1. Backend: Register standard user
      final registered = await ApiService.register(email, password);
      if (!registered) throw Exception('Registration failed.'.tr());

      // 2. Backend: Log in automatically to get token
      final token = await ApiService.login(email, password);
      if (token == null) throw Exception('Authentication failed.'.tr());

      // 3. Backend: Save Profile Details
      final profilePayload = {
        'full_name': '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}'.trim(),
        'mobile_number': '$_selectedCountryCode${_phoneController.text.trim()}',
        'dob': _selectedDob == null ? '2000-01-01' : _selectedDob!.toIso8601String().substring(0, 10), // YYYY-MM-DD
        'gender': _selectedGender ?? 'Not Specified',
        'blood_group': 'Not Specified',
        'height': 'Not Specified',
        'weight': 'Not Specified',
        'medical_conditions': null,
        'medications': null,
        'allergies': null,
        'emergency_contact_name': 'Not Specified',
        'emergency_contact_relationship': 'Not Specified',
        'emergency_contact_number': 'Not Specified',
        'consent_terms': _consentTerms,
        'consent_storage': _consentStorage,
        'consent_medical': _consentMedical,
      };

      final profileSaved = await ApiService.saveUserProfile(profilePayload);
      if (!profileSaved) throw Exception('Failed to save health profile.'.tr());

      // 4. Update AppState
      final appState = AppState();
      appState.email = email;
      appState.name = '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}'.trim();
      final emailPrefix = email.split('@')[0];
      appState.username = emailPrefix;

      // Populate health metrics from form values
      appState.phoneNumber = '$_selectedCountryCode${_phoneController.text.trim()}';
      if (_selectedDob != null) {
        appState.dob = _selectedDob!.toIso8601String().substring(0, 10);
      }
      if (_selectedGender != null) {
        appState.gender = _selectedGender!;
      }
      appState.bloodGroup = 'Not Specified';
      appState.height = 'Not Specified';
      appState.weight = 'Not Specified';
      appState.medicalConditions = '';
      appState.medications = '';
      appState.allergies = '';
      appState.emergencyContactName = 'Not Specified';
      appState.emergencyContactRelationship = 'Not Specified';
      appState.emergencyContactNumber = 'Not Specified';

      if (mounted) {
        // Show Success dialog
        _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar(e.toString().replaceAll('Exception: ', ''));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: AppRadius.cardBorderRadius),
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFFDFF3F6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.primary,
                    size: 54,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Account Created!'.tr(),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Your profile and health account have been set up successfully. Welcome to AetherDx!'.tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 28),
                AppButton(
                  text: 'Get Started'.tr(),
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const MainNavigationShell()),
                      (route) => false,
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

  // --- Date Picker Helper ---
  Future<void> _selectDateOfBirth() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDob ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDob) {
      setState(() {
        _selectedDob = picked;
      });
    }
  }

  // --- Validation Helpers ---

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required'.tr();
    final emailRegex = RegExp(r'^[\w\.\-]+@([\w\-]+\.)+[\w\-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) return 'Enter a valid email address'.tr();
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) return 'Mobile number is required'.tr();
    final phoneRegex = RegExp(r'^[0-9]{7,15}$');
    if (!phoneRegex.hasMatch(value.trim())) return 'Enter a valid mobile number'.tr();
    return null;
  }



  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required'.tr();
    if (value.length < 8) return 'Password must be at least 8 characters'.tr();
    if (!value.contains(RegExp(r'[A-Z]'))) return 'Must contain at least one uppercase letter'.tr();
    if (!value.contains(RegExp(r'[a-z]'))) return 'Must contain at least one lowercase letter'.tr();
    if (!value.contains(RegExp(r'[0-9]'))) return 'Must contain at least one digit'.tr();
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return 'Confirm password is required'.tr();
    if (value != _passwordController.text) return 'Passwords do not match'.tr();
    return null;
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) return '${fieldName.tr()} ' + 'is required'.tr();
    return null;
  }

  String _getFormattedDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  // --- Progress Stepper Header ---
  Widget _buildProgressHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          Row(
            children: [
              _buildStepIndicator(0, 'Account'.tr()),
              _buildStepConnector(0),
              _buildStepIndicator(1, 'Profile'.tr()),
              _buildStepConnector(1),
              _buildStepIndicator(2, 'Finish'.tr()),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _currentStep == 0
                    ? 'Step 1: Credentials'.tr()
                    : _currentStep == 1
                        ? 'Step 2: Personal Profile'.tr()
                        : 'Step 3: Consent & Terms'.tr(),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                '${_currentStep + 1} ' + 'of'.tr() + ' 3',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int stepIndex, String title) {
    final isActive = _currentStep == stepIndex;
    final isCompleted = _currentStep > stepIndex;

    return Expanded(
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isCompleted
                  ? AppColors.primary
                  : isActive
                      ? AppColors.primary
                      : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: (isActive || isCompleted)
                    ? AppColors.primary
                    : const Color(0xFFE2E8F0),
                width: 2,
              ),
              boxShadow: isActive ? [AppShadows.soft] : null,
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 18)
                  : Text(
                      '${stepIndex + 1}',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: (isActive || isCompleted)
                            ? Colors.white
                            : AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
              color: isActive ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepConnector(int afterStep) {
    final isCompleted = _currentStep > afterStep;
    return Container(
      width: 30,
      height: 2,
      margin: const EdgeInsets.only(bottom: 20),
      color: isCompleted ? AppColors.primary : const Color(0xFFE2E8F0),
    );
  }

  // --- Step 1 Layout ---
  Widget _buildStep1() {
    return Form(
      key: _step1FormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Create your account'.tr(),
            style: AppTypography.screenTitle,
          ),
          const SizedBox(height: 8),
          Text(
            'Start your health journey with Medcare'.tr(),
            style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('First Name'),
                    _buildTextField(
                      controller: _firstNameController,
                      hint: 'John',
                      icon: Icons.person_outline,
                      autofillHints: [AutofillHints.givenName],
                      validator: (v) => _validateRequired(v, 'First name'),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Last Name'),
                    _buildTextField(
                      controller: _lastNameController,
                      hint: 'Doe',
                      icon: Icons.person_outline,
                      autofillHints: [AutofillHints.familyName],
                      validator: (v) => _validateRequired(v, 'Last name'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          _buildLabel('Email Address'),
          _buildTextField(
            controller: _emailController,
            hint: 'name@example.com',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            autofillHints: [AutofillHints.email],
            validator: _validateEmail,
          ),
          const SizedBox(height: 18),

          _buildLabel('Mobile Number'),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCountryCodeDropdown(
                value: _selectedCountryCode,
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedCountryCode = val);
                  }
                },
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  controller: _phoneController,
                  hint: 'Mobile number',
                  icon: Icons.phone_android_outlined,
                  keyboardType: TextInputType.phone,
                  autofillHints: [AutofillHints.telephoneNumber],
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9\-]'))],
                  validator: _validatePhone,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          _buildLabel('Create Password'),
          _buildTextField(
            controller: _passwordController,
            hint: 'Min 8 chars, uppercase & digit',
            icon: Icons.lock_outline_rounded,
            obscure: _obscurePassword,
            autofillHints: [AutofillHints.newPassword],
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: AppColors.textSecondary,
              ),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
            validator: _validatePassword,
          ),
          const SizedBox(height: 18),

          _buildLabel('Confirm Password'),
          _buildTextField(
            controller: _confirmPasswordController,
            hint: 'Re-enter your password',
            icon: Icons.lock_outline_rounded,
            obscure: _obscureConfirmPassword,
            autofillHints: [AutofillHints.newPassword],
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                color: AppColors.textSecondary,
              ),
              onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
            ),
            validator: _validateConfirmPassword,
          ),
        ],
      ),
    );
  }

  // --- Step 2 Layout ---
  Widget _buildStep2() {
    return Form(
      key: _step2FormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Personal Details'.tr(),
            style: AppTypography.screenTitle,
          ),
          const SizedBox(height: 8),
          Text(
            'Enter your date of birth and gender to complete your basic profile.'.tr(),
            style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),

          _buildLabel('Date of Birth'),
          GestureDetector(
            onTap: _selectDateOfBirth,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppRadius.inputBorderRadius,
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [AppShadows.soft],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedDob == null
                        ? 'Select date of birth'.tr()
                        : _getFormattedDate(_selectedDob!),
                    style: TextStyle(
                      fontSize: 15,
                      color: _selectedDob == null ? AppColors.placeholder : AppColors.textPrimary,
                    ),
                  ),
                  const Icon(Icons.calendar_today_outlined, color: AppColors.primary, size: 20),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),

          _buildLabel('Gender'),
          DropdownButtonFormField<String>(
            value: _selectedGender,
            onChanged: (val) => setState(() => _selectedGender = val),
            items: _genders.map((gender) {
              return DropdownMenuItem(value: gender, child: Text(gender.tr()));
            }).toList(),
            decoration: InputDecoration(
              hintText: 'Select gender'.tr(),
              hintStyle: const TextStyle(color: AppColors.placeholder, fontSize: 15),
              filled: true,
              fillColor: Colors.white,
              prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.primary),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              border: OutlineInputBorder(
                borderRadius: AppRadius.inputBorderRadius,
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.inputBorderRadius,
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppRadius.inputBorderRadius,
                borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Step 3 Layout ---
  Widget _buildStep3() {
    return Form(
      key: _step3FormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Consent & Terms'.tr(),
            style: AppTypography.screenTitle,
          ),
          const SizedBox(height: 8),
          Text(
            'Please review and agree to the terms below to proceed.'.tr(),
            style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),

          _buildConsentTile(
            value: _consentTerms,
            onChanged: (val) => setState(() => _consentTerms = val ?? false),
            text: 'I agree to the Terms of Service and Privacy Policy.',
          ),
          const SizedBox(height: 12),
          _buildConsentTile(
            value: _consentStorage,
            onChanged: (val) => setState(() => _consentStorage = val ?? false),
            text: 'I consent to the secure storage and processing of my health information for providing AetherDx services.',
          ),
          const SizedBox(height: 12),
          _buildConsentTile(
            value: _consentMedical,
            onChanged: (val) => setState(() => _consentMedical = val ?? false),
            text: 'I understand that AetherDx does not replace professional medical diagnosis or emergency medical care.',
          ),
        ],
      ),
    );
  }

  Widget _buildConsentTile({
    required bool value,
    required ValueChanged<bool?> onChanged,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 8.0),
            child: Text(
              text.tr(),
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCountryCodeDropdown({
    required String value,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 52, // Matches standard input textfield height
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.inputBorderRadius,
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [AppShadows.soft],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary, size: 20),
          onChanged: onChanged,
          items: const [
            DropdownMenuItem(value: '+1', child: Text('+1 (US)')),
            DropdownMenuItem(value: '+91', child: Text('+91 (IN)')),
            DropdownMenuItem(value: '+44', child: Text('+44 (UK)')),
            DropdownMenuItem(value: '+61', child: Text('+61 (AU)')),
            DropdownMenuItem(value: '+81', child: Text('+81 (JP)')),
            DropdownMenuItem(value: '+49', child: Text('+49 (DE)')),
            DropdownMenuItem(value: '+33', child: Text('+33 (FR)')),
            DropdownMenuItem(value: '+971', child: Text('+971 (AE)')),
            DropdownMenuItem(value: '+65', child: Text('+65 (SG)')),
            DropdownMenuItem(value: '+55', child: Text('+55 (BR)')),
            DropdownMenuItem(value: '+52', child: Text('+52 (MX)')),
            DropdownMenuItem(value: '+27', child: Text('+27 (ZA)')),
          ],
        ),
      ),
    );
  }

  // --- Utility Widgets ---
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 2.0),
      child: Text(
        text.tr(),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
    Widget? suffixIcon,
    String? suffixText,
    List<TextInputFormatter>? inputFormatters,
    FormFieldValidator<String>? validator,
    Iterable<String>? autofillHints,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.inputBorderRadius,
        boxShadow: [AppShadows.soft],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        validator: validator,
        inputFormatters: inputFormatters,
        autofillHints: autofillHints,
        style: const TextStyle(fontSize: 15, color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hint.tr(),
          hintStyle: const TextStyle(color: AppColors.placeholder, fontSize: 15),
          prefixIcon: Icon(icon, color: AppColors.primary),
          suffixIcon: suffixIcon,
          suffixText: suffixText?.tr(),
          suffixStyle: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold, fontSize: 14),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: AppRadius.inputBorderRadius,
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppRadius.inputBorderRadius,
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppRadius.inputBorderRadius,
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: AppRadius.inputBorderRadius,
            borderSide: const BorderSide(color: AppColors.error, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: AppRadius.inputBorderRadius,
            borderSide: const BorderSide(color: AppColors.error, width: 1.5),
          ),
          errorStyle: const TextStyle(color: AppColors.error, fontSize: 12),
        ),
      ),
    );
  }

  // --- Main Build ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Sign Up'.tr(),
        onBackPressed: () {
          if (_currentStep > 0) {
            _previousStep();
          } else {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          }
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                child: Column(
                  children: [
                    _buildProgressHeader(),
                    const SizedBox(height: 12),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _currentStep == 0
                          ? _buildStep1()
                          : _currentStep == 1
                              ? _buildStep2()
                              : _buildStep3(),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // Sticky Bottom Actions
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFF1F5F9), width: 1.5)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      if (_currentStep > 0) ...[
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _isLoading ? null : _previousStep,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: const BorderSide(color: AppColors.primary, width: 1.5),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: AppRadius.buttonBorderRadius,
                              ),
                            ),
                            child: Text(
                              'Back'.tr(),
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                      if (_currentStep == 1) ...[
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _isLoading ? null : () {
                              setState(() => _currentStep = 2);
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.textSecondary,
                              side: const BorderSide(color: Color(0xFFCBD5E1), width: 1.5),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: AppRadius.buttonBorderRadius,
                              ),
                            ),
                            child: Text(
                              'Skip'.tr(),
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                      Expanded(
                        flex: 2,
                        child: _isLoading
                            ? const Center(
                                child: CircularProgressIndicator(color: AppColors.primary),
                              )
                            : AppButton(
                                text: _currentStep == 2 ? 'Create My Account'.tr() : 'Continue'.tr(),
                                onPressed: _currentStep == 2 ? _handleRegister : _nextStep,
                              ),
                      ),
                    ],
                  ),
                  if (_currentStep == 0) ...[
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? '.tr(),
                          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (_) => const LoginScreen()),
                            );
                          },
                          child: Text(
                            'Log In'.tr(),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
