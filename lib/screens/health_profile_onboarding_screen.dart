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

class HealthProfileOnboardingScreen extends StatefulWidget {
  final String? initialEmail;
  final String? initialName;

  const HealthProfileOnboardingScreen({
    super.key,
    this.initialEmail,
    this.initialName,
  });

  @override
  State<HealthProfileOnboardingScreen> createState() => _HealthProfileOnboardingScreenState();
}

class _HealthProfileOnboardingScreenState extends State<HealthProfileOnboardingScreen> {
  final _formKey = GlobalKey<FormState>();

  final _phoneController = TextEditingController();

  String _selectedCountryCode = '+91';
  DateTime? _selectedDob;
  String? _selectedGender;
  String? _selectedBloodGroup;

  bool _consentTerms = false;
  bool _consentStorage = false;
  bool _consentMedical = false;

  bool _isLoading = false;

  final List<String> _countryCodes = ['+91', '+1', '+44', '+61', '+86', '+49', '+33', '+81', '+971'];
  final List<String> _genders = ['Male', 'Female', 'Other', 'Prefer not to say'];
  final List<String> _bloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-', 'Not Specified'];

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

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
    if (picked != null) {
      setState(() {
        _selectedDob = picked;
      });
    }
  }

  String _getFormattedDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Future<void> _submitOnboarding() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDob == null) {
      _showSnackBar('Please select your date of birth.'.tr());
      return;
    }

    if (!_consentTerms || !_consentStorage || !_consentMedical) {
      _showSnackBar('Please agree to all terms and medical consents to proceed.'.tr());
      return;
    }

    setState(() => _isLoading = true);

    try {
      final phone = '$_selectedCountryCode${_phoneController.text.trim()}';
      final dobStr = _selectedDob!.toIso8601String().substring(0, 10);
      final heightVal = 'Not Specified';
      final weightVal = 'Not Specified';

      final appState = AppState();
      final nameToUse = widget.initialName ?? appState.name;
      final emailToUse = widget.initialEmail ?? appState.email;

      final profileData = {
        'full_name': nameToUse.isNotEmpty ? nameToUse : 'User',
        'mobile_number': phone,
        'dob': dobStr,
        'gender': _selectedGender ?? 'Not Specified',
        'blood_group': _selectedBloodGroup ?? 'Not Specified',
        'height': heightVal,
        'weight': weightVal,
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

      final success = await ApiService.saveUserProfile(profileData);
      if (!success) {
        throw Exception('Failed to save profile information. Please try again.');
      }

      // Update AppState
      if (emailToUse.isNotEmpty) appState.email = emailToUse;
      appState.phoneNumber = phone;
      appState.dob = dobStr;
      if (_selectedGender != null) appState.gender = _selectedGender!;
      if (_selectedBloodGroup != null) appState.bloodGroup = _selectedBloodGroup!;
      appState.height = heightVal;
      appState.weight = weightVal;

      if (mounted) {
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

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
      ),
    );
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
                  'Profile Completed!'.tr(),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Your health profile has been saved successfully. Welcome to AetherDx!'.tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 28),
                AppButton(
                  text: 'Go to Dashboard'.tr(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Health Profile'.tr(),
          style: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Info Box
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFBBF7D0)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.favorite_rounded, color: Color(0xFF16A34A), size: 28),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Almost there!'.tr(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF14532D),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Please complete your health profile to personalize your diagnostics & care experience.'.tr(),
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF166534),
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Mobile Number
                _buildLabel('Mobile Number'),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: AppRadius.inputBorderRadius,
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [AppShadows.soft],
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedCountryCode,
                          items: _countryCodes.map((code) {
                            return DropdownMenuItem(
                              value: code,
                              child: Text(code, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedCountryCode = val);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: AppRadius.inputBorderRadius,
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          boxShadow: [AppShadows.soft],
                        ),
                        child: TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          style: const TextStyle(fontSize: 15, color: AppColors.textPrimary),
                          decoration: InputDecoration(
                            hintText: 'Enter mobile number'.tr(),
                            hintStyle: const TextStyle(color: AppColors.placeholder, fontSize: 14),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            prefixIcon: const Icon(Icons.phone_android_outlined, color: AppColors.primary),
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) return 'Mobile number is required'.tr();
                            if (val.trim().length != 10) return 'Enter exactly 10 digits'.tr();
                            return null;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Date of Birth
                _buildLabel('Date of Birth'),
                GestureDetector(
                  onTap: _selectDateOfBirth,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: AppRadius.inputBorderRadius,
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [AppShadows.soft],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_outlined, color: AppColors.primary, size: 20),
                            const SizedBox(width: 12),
                            Text(
                              _selectedDob == null
                                  ? 'Select Date of Birth'.tr()
                                  : _getFormattedDate(_selectedDob!),
                              style: TextStyle(
                                fontSize: 15,
                                color: _selectedDob == null ? AppColors.placeholder : AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondary),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Gender & Blood Group Row
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Gender'),
                          DropdownButtonFormField<String>(
                            isExpanded: true,
                            value: _selectedGender,
                            onChanged: (val) => setState(() => _selectedGender = val),
                            validator: (v) => v == null ? 'Required'.tr() : null,
                            items: _genders.map((g) {
                              return DropdownMenuItem(value: g, child: Text(g.tr(), style: const TextStyle(fontSize: 14)));
                            }).toList(),
                            decoration: InputDecoration(
                              hintText: 'Gender'.tr(),
                              hintStyle: const TextStyle(color: AppColors.placeholder, fontSize: 14),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                              border: OutlineInputBorder(
                                borderRadius: AppRadius.inputBorderRadius,
                                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: AppRadius.inputBorderRadius,
                                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabel('Blood Group'),
                          DropdownButtonFormField<String>(
                            isExpanded: true,
                            value: _selectedBloodGroup,
                            onChanged: (val) => setState(() => _selectedBloodGroup = val),
                            validator: (v) => v == null ? 'Required'.tr() : null,
                            items: _bloodGroups.map((bg) {
                              return DropdownMenuItem(value: bg, child: Text(bg, style: const TextStyle(fontSize: 14)));
                            }).toList(),
                            decoration: InputDecoration(
                              hintText: 'Blood Group'.tr(),
                              hintStyle: const TextStyle(color: AppColors.placeholder, fontSize: 14),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                              border: OutlineInputBorder(
                                borderRadius: AppRadius.inputBorderRadius,
                                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: AppRadius.inputBorderRadius,
                                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Height & Weight Row


                // Consents Section
                Text(
                  'Consents & Agreement'.tr(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),

                _buildConsentTile(
                  value: _consentTerms,
                  onChanged: (val) => setState(() => _consentTerms = val ?? false),
                  text: 'I agree to the Terms of Service and Privacy Policy.',
                ),
                const SizedBox(height: 10),
                _buildConsentTile(
                  value: _consentStorage,
                  onChanged: (val) => setState(() => _consentStorage = val ?? false),
                  text: 'I consent to the secure storage and processing of my health information.',
                ),
                const SizedBox(height: 10),
                _buildConsentTile(
                  value: _consentMedical,
                  onChanged: (val) => setState(() => _consentMedical = val ?? false),
                  text: 'I understand that AetherDx does not replace professional medical diagnosis.',
                ),
                const SizedBox(height: 32),

                // Submit Button
                AppButton(
                  text: _isLoading ? 'Saving profile...'.tr() : 'Complete Profile & Continue'.tr(),
                  onPressed: () {
                    if (!_isLoading) {
                      _submitOnboarding();
                    }
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Text(
        title.tr(),
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
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
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text.tr(),
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}
