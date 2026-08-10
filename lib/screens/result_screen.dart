import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aetherdx/core/theme/colors.dart';
import 'package:aetherdx/core/theme/typography.dart';
import 'package:aetherdx/core/theme/radius.dart';
import 'package:aetherdx/core/localization/translations.dart';
import 'package:aetherdx/core/theme/shadows.dart';
import 'package:aetherdx/core/widgets/app_button.dart';
import 'package:aetherdx/core/widgets/app_card.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'finding_specialists_screen.dart';
import 'educational_screen.dart';
import 'nutrition_lifestyle_screen.dart';

class ResultScreen extends StatelessWidget {
  final String conditionName;
  final int matchPercentage;
  final String confidenceLabel;
  final String description;
  final String keySigns;
  final String nextSteps;
  final String careTips;

  const ResultScreen({
    super.key,
    this.conditionName = 'Nail Psoriasis',
    this.matchPercentage = 78,
    this.confidenceLabel = 'High confidence',
    this.description = 'A chronic autoimmune condition that affects nail cells, causing changes in appearance.',
    this.keySigns = 'Pitting, discoloration, rough texture, and nail thickening',
    this.nextSteps = 'Consult a dermatologist for proper diagnosis and treatment',
    this.careTips = 'Keep nails moisturized, avoid trauma, and manage stress',
  });

  @override
  Widget build(BuildContext context) {
    final String nameLower = conditionName.toLowerCase();
    
    // Dynamic colors based on predicted condition
    Color boxBgColor = AppColors.secondaryBg;
    Color textColor = AppColors.primary;
    Color subtextColor = AppColors.textSecondary;
    Color badgeColor = AppColors.primary;
    IconData badgeIcon = Icons.verified_user_rounded;

    if (nameLower.contains('healthy')) {
      boxBgColor = const Color(0xFFDCFCE7);
      textColor = const Color(0xFF15803D);
      subtextColor = const Color(0xFF166534);
      badgeColor = const Color(0xFF16A34A);
    } else if (nameLower.contains('psoriasis')) {
      boxBgColor = const Color(0xFFFEF9C3);
      textColor = const Color(0xFF854D0E);
      subtextColor = const Color(0xFF713F12);
      badgeColor = const Color(0xFFD97706);
    } else if (nameLower.contains('liver') || nameLower.contains('terry')) {
      boxBgColor = const Color(0xFFFEE2E2);
      textColor = const Color(0xFF991B1B);
      subtextColor = const Color(0xFF7F1D1D);
      badgeColor = const Color(0xFFDC2626);
      badgeIcon = Icons.report_problem_rounded;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // 1. Top Right Abstract Pattern Image Overlay
          Positioned(
            top: -20,
            right: -20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.asset(
                'assets/images/result_header_pattern.png',
                width: 190,
                height: 190,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 2. Main Content Stack
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header actions & titles
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back Button
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
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
                      const SizedBox(height: 28),
                      // Results upper text
                      Text(
                        'RESULTS'.tr(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Your Results header
                      Text(
                        'Your Results'.tr(),
                        style: AppTypography.screenTitle,
                      ),
                      const SizedBox(height: 4),
                      // Analysis complete subtitle
                      Text(
                        'AI analysis complete'.tr(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // White Sheet Container
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 24.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: AppRadius.cardBorderRadius,
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [AppShadows.soft],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Match Card Banner with dynamic coloring based on condition
                                AppCard(
                                  backgroundColor: boxBgColor,
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '$matchPercentage% match'.tr(),
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w800,
                                              color: textColor,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            confidenceLabel.tr(),
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: subtextColor,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Icon circular badge
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: badgeColor,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          badgeIcon,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Diagnosis title & description
                                Text(
                                  conditionName.tr(),
                                  style: AppTypography.sectionHeading,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  description.tr(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    const Icon(Icons.menu_book_rounded, color: AppColors.primary, size: 16),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(builder: (_) => const EducationalScreen()),
                                          );
                                        },
                                        style: TextButton.styleFrom(
                                          alignment: Alignment.centerLeft,
                                          padding: EdgeInsets.zero,
                                          minimumSize: Size.zero,
                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        child: Text(
                                          'Read Health Guide'.tr(),
                                          style: const TextStyle(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                  child: Divider(color: Color(0xFFF1F5F9), thickness: 1.5),
                                ),

                                // Detailed list of symptoms and guides
                                _buildDetailsRow(
                                  icon: Icons.gps_fixed_rounded,
                                  title: 'Key Signs Detected'.tr(),
                                  description: keySigns.tr(),
                                ),
                                const SizedBox(height: 20),
                                _buildDetailsRow(
                                  icon: Icons.gpp_maybe_outlined,
                                  title: 'Recommended Next Steps'.tr(),
                                  description: nextSteps.tr(),
                                ),
                                const SizedBox(height: 20),
                                _buildDetailsRow(
                                  icon: Icons.description_outlined,
                                  title: 'General Care Tips'.tr(),
                                  description: careTips.tr(),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    const SizedBox(width: 44),
                                    const Icon(Icons.spa_outlined, color: AppColors.primary, size: 16),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(builder: (_) => NutritionLifestyleScreen(conditionName: conditionName)),
                                          );
                                        },
                                        style: TextButton.styleFrom(
                                          alignment: Alignment.centerLeft,
                                          padding: EdgeInsets.zero,
                                          minimumSize: Size.zero,
                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        child: Text(
                                          'Nutrition & Lifestyle Tips'.tr(),
                                          style: const TextStyle(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withOpacity(0.08),
                                        borderRadius: BorderRadius.circular(100),
                                      ),
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () => _showPatientDetailsSheet(context),
                                          borderRadius: BorderRadius.circular(100),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(
                                                  Icons.picture_as_pdf_rounded,
                                                  color: AppColors.primary,
                                                  size: 18,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  'Download Medical Report'.tr(),
                                                  style: GoogleFonts.outfit(
                                                    color: AppColors.primary,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 0.1,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Fixed Bottom Button Area
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 24.0),
                          child: AppButton(
                            text: 'Consult a Specialist'.tr(),
                            icon: Icons.calendar_today_outlined,
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => FindingSpecialistsScreen(
                                    conditionName: conditionName,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsRow({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: AppColors.secondaryBg,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.tr(),
                style: AppTypography.cardTitle,
              ),
              const SizedBox(height: 4),
              Text(
                description.tr(),
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
    );
  }

  void _showPatientDetailsSheet(BuildContext context) {
    final nameController = TextEditingController();
    final dobController = TextEditingController();
    final genderController = TextEditingController();
    final phoneController = TextEditingController();
    final bloodGroupController = TextEditingController();
    final conditionsController = TextEditingController();
    final medicationsController = TextEditingController();
    final allergiesController = TextEditingController();
    final doctorController = TextEditingController(text: 'AetherDx Clinical Lab');
    final notesController = TextEditingController(text: 'Patient requested nail scan analysis report.');
    final formKey = GlobalKey<FormState>();
    bool isGenerating = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setSheetState) {
            InputDecoration buildInputDecoration(String hint, {Widget? suffixIcon}) {
              return InputDecoration(
                hintText: hint.tr(),
                hintStyle: const TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                suffixIcon: suffixIcon,
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
              );
            }

            Widget buildFieldLabel(String label) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6.0, top: 12.0),
                child: Text(
                  label.tr(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              );
            }

            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.85,
              ),
              padding: EdgeInsets.fromLTRB(28, 20, 28, MediaQuery.of(context).viewInsets.bottom + 24),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Generate Medical Report'.tr(),
                            style: GoogleFonts.outfit(
                              fontSize: 20,
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
                      const SizedBox(height: 8),
                      Text(
                        'Enter the patient details and history to include in the generated medical PDF report.'.tr(),
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 12),

                      buildFieldLabel('Patient Name'),
                      TextFormField(
                        controller: nameController,
                        decoration: buildInputDecoration('Patient Full Name'),
                        validator: (value) => value == null || value.trim().isEmpty ? 'Name is required'.tr() : null,
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildFieldLabel('Date of Birth'),
                                TextFormField(
                                  controller: dobController,
                                  readOnly: true,
                                  decoration: buildInputDecoration(
                                    'YYYY-MM-DD',
                                    suffixIcon: const Icon(Icons.calendar_today_rounded, color: Color(0xFF94A3B8), size: 18),
                                  ),
                                  onTap: () async {
                                    final DateTime? picked = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime(2000, 1, 1),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime.now(),
                                    );
                                    if (picked != null) {
                                      setSheetState(() {
                                        dobController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                                      });
                                    }
                                  },
                                  validator: (value) => value == null || value.trim().isEmpty ? 'DOB is required'.tr() : null,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildFieldLabel('Gender'),
                                DropdownButtonFormField<String>(
                                  value: genderController.text.isEmpty ? null : genderController.text,
                                  isExpanded: true,
                                  decoration: buildInputDecoration('Select Gender'),
                                  dropdownColor: Colors.white,
                                  items: ['Male', 'Female', 'Other', 'Prefer not to say'].map((String val) {
                                    return DropdownMenuItem<String>(
                                      value: val,
                                      child: Text(
                                        val,
                                        style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (val) {
                                    setSheetState(() {
                                      genderController.text = val ?? '';
                                    });
                                  },
                                  validator: (value) => value == null || value.trim().isEmpty ? 'Gender is required'.tr() : null,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      buildFieldLabel('Phone Number'),
                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: buildInputDecoration('Enter 10-digit phone number'),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Phone number is required'.tr();
                          }
                          final regExp = RegExp(r'^[0-9]{10}$');
                          if (!regExp.hasMatch(value.trim())) {
                            return 'Enter a valid 10-digit phone number'.tr();
                          }
                          return null;
                        },
                      ),

                      buildFieldLabel('Blood Group'),
                      DropdownButtonFormField<String>(
                        value: bloodGroupController.text.isEmpty ? null : bloodGroupController.text,
                        isExpanded: true,
                        decoration: buildInputDecoration('Select Blood Group'),
                        dropdownColor: Colors.white,
                        items: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-', 'Not Specified', 'I don\'t know'].map((String val) {
                          return DropdownMenuItem<String>(
                            value: val,
                            child: Text(
                              val,
                              style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setSheetState(() {
                            bloodGroupController.text = val ?? '';
                          });
                        },
                      ),

                      buildFieldLabel('Medical Conditions'),
                      TextFormField(
                        controller: conditionsController,
                        decoration: buildInputDecoration('e.g. Asthma, Diabetes'),
                      ),

                      buildFieldLabel('Current Medications'),
                      TextFormField(
                        controller: medicationsController,
                        decoration: buildInputDecoration('e.g. Insulin, Metformin'),
                      ),

                      buildFieldLabel('Known Allergies'),
                      TextFormField(
                        controller: allergiesController,
                        decoration: buildInputDecoration('e.g. Penicillin, Peanuts'),
                      ),

                      buildFieldLabel('Doctor / Clinic Name'),
                      TextFormField(
                        controller: doctorController,
                        decoration: buildInputDecoration('Clinic or Doctor Name'),
                        validator: (value) => value == null || value.trim().isEmpty ? 'Clinic name is required'.tr() : null,
                      ),

                      buildFieldLabel('Clinical Notes & Symptoms'),
                      TextFormField(
                        controller: notesController,
                        maxLines: 2,
                        decoration: buildInputDecoration('Add symptoms or clinical observations...'),
                      ),

                      const SizedBox(height: 24),

                      AppButton(
                        text: isGenerating ? 'Generating PDF...'.tr() : 'Generate Report'.tr(),
                        icon: Icons.picture_as_pdf_rounded,
                        onPressed: () async {
                          if (isGenerating) return;
                          if (formKey.currentState!.validate()) {
                            setSheetState(() => isGenerating = true);
                            try {
                              await _generateAndOpenPdf(
                                patientName: nameController.text.trim(),
                                patientDob: dobController.text.trim(),
                                patientGender: genderController.text.trim(),
                                patientPhone: phoneController.text.trim(),
                                bloodGroup: bloodGroupController.text.trim(),
                                medicalConditions: conditionsController.text.trim(),
                                medications: medicationsController.text.trim(),
                                allergies: allergiesController.text.trim(),
                                clinicName: doctorController.text.trim(),
                                notes: notesController.text.trim(),
                              );
                              if (context.mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Report generated successfully!'.tr()),
                                    backgroundColor: AppColors.success,
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error generating PDF: $e'.tr()),
                                    backgroundColor: AppColors.error,
                                  ),
                                );
                              }
                            } finally {
                              setSheetState(() => isGenerating = false);
                            }
                          }
                        },
                      ),
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

  Future<void> _generateAndOpenPdf({
    required String patientName,
    required String patientDob,
    required String patientGender,
    required String patientPhone,
    required String bloodGroup,
    required String medicalConditions,
    required String medications,
    required String allergies,
    required String clinicName,
    required String notes,
  }) async {
    final pdf = pw.Document();
    final fontNormal = pw.Font.helvetica();
    final fontBold = pw.Font.helveticaBold();

    pw.Widget buildCell(pw.Widget child, {double padding = 6}) {
      return pw.Padding(
        padding: pw.EdgeInsets.all(padding),
        child: child,
      );
    }

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        clinicName,
                        style: pw.TextStyle(font: fontBold, fontSize: 20, color: PdfColors.teal800),
                      ),
                      pw.SizedBox(height: 2),
                      pw.Text(
                        'AI-Assisted Diagnostic Lab Report',
                        style: pw.TextStyle(font: fontNormal, fontSize: 9, color: PdfColors.grey600),
                      ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'Report ID: ADX-${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}',
                        style: pw.TextStyle(font: fontBold, fontSize: 9),
                      ),
                      pw.SizedBox(height: 2),
                      pw.Text(
                        'Date: ${DateTime.now().toString().substring(0, 10)}',
                        style: pw.TextStyle(font: fontNormal, fontSize: 9),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Divider(thickness: 1.5, color: PdfColors.teal800),
              pw.SizedBox(height: 14),

              // Patient Details
              pw.Text(
                'PATIENT DETAILS',
                style: pw.TextStyle(font: fontBold, fontSize: 11, color: PdfColors.teal900, letterSpacing: 0.5),
              ),
              pw.SizedBox(height: 6),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
                children: [
                  pw.TableRow(
                    children: [
                      buildCell(pw.Text('Name:', style: pw.TextStyle(font: fontBold, fontSize: 9))),
                      buildCell(pw.Text(patientName, style: pw.TextStyle(font: fontNormal, fontSize: 9))),
                      buildCell(pw.Text('Gender:', style: pw.TextStyle(font: fontBold, fontSize: 9))),
                      buildCell(pw.Text(patientGender, style: pw.TextStyle(font: fontNormal, fontSize: 9))),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      buildCell(pw.Text('Date of Birth:', style: pw.TextStyle(font: fontBold, fontSize: 9))),
                      buildCell(pw.Text(patientDob, style: pw.TextStyle(font: fontNormal, fontSize: 9))),
                      buildCell(pw.Text('Phone Number:', style: pw.TextStyle(font: fontBold, fontSize: 9))),
                      buildCell(pw.Text(patientPhone.isEmpty ? 'Not Specified' : patientPhone, style: pw.TextStyle(font: fontNormal, fontSize: 9))),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 14),

              // Systemic Profile
              pw.Text(
                'PATIENT HEALTH PROFILE (SYSTEMIC)',
                style: pw.TextStyle(font: fontBold, fontSize: 11, color: PdfColors.teal900, letterSpacing: 0.5),
              ),
              pw.SizedBox(height: 6),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
                children: [
                  pw.TableRow(
                    children: [
                      buildCell(pw.Text('Blood Group:', style: pw.TextStyle(font: fontBold, fontSize: 9))),
                      buildCell(pw.Text(bloodGroup.isEmpty ? 'Not Specified' : bloodGroup, style: pw.TextStyle(font: fontNormal, fontSize: 9))),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 6),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
                children: [
                  pw.TableRow(
                    children: [
                      buildCell(pw.Text('Medical Conditions:', style: pw.TextStyle(font: fontBold, fontSize: 9))),
                      buildCell(pw.Text(medicalConditions.isEmpty ? 'None Specified' : medicalConditions, style: pw.TextStyle(font: fontNormal, fontSize: 9))),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      buildCell(pw.Text('Medications:', style: pw.TextStyle(font: fontBold, fontSize: 9))),
                      buildCell(pw.Text(medications.isEmpty ? 'None Specified' : medications, style: pw.TextStyle(font: fontNormal, fontSize: 9))),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      buildCell(pw.Text('Allergies:', style: pw.TextStyle(font: fontBold, fontSize: 9))),
                      buildCell(pw.Text(allergies.isEmpty ? 'None Specified' : allergies, style: pw.TextStyle(font: fontNormal, fontSize: 9))),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 16),

              // AI Diagnosis Box
              pw.Container(
                decoration: pw.BoxDecoration(
                  color: PdfColors.teal50,
                  border: pw.Border.all(color: PdfColors.teal200, width: 1),
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                padding: const pw.EdgeInsets.all(12),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'AI DIAGNOSIS RESULT',
                          style: pw.TextStyle(font: fontBold, fontSize: 10, color: PdfColors.teal900),
                        ),
                        pw.Text(
                          '$matchPercentage% Match ($confidenceLabel)',
                          style: pw.TextStyle(font: fontBold, fontSize: 10, color: PdfColors.teal900),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 6),
                    pw.Text(
                      conditionName,
                      style: pw.TextStyle(font: fontBold, fontSize: 15, color: PdfColors.black),
                    ),
                    pw.SizedBox(height: 6),
                    pw.Text(
                      description,
                      style: pw.TextStyle(font: fontNormal, fontSize: 9.5, color: PdfColors.grey800, height: 1.3),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 14),

              // Clinical Findings
              pw.Text(
                'CLINICAL FINDINGS & NEXT STEPS',
                style: pw.TextStyle(font: fontBold, fontSize: 11, color: PdfColors.teal900, letterSpacing: 0.5),
              ),
              pw.SizedBox(height: 6),
              pw.Bullet(
                text: 'Key Signs: $keySigns',
                style: pw.TextStyle(font: fontNormal, fontSize: 9),
              ),
              pw.SizedBox(height: 4),
              pw.Bullet(
                text: 'Recommended Action: $nextSteps',
                style: pw.TextStyle(font: fontNormal, fontSize: 9),
              ),
              pw.SizedBox(height: 4),
              pw.Bullet(
                text: 'General Care Tips: $careTips',
                style: pw.TextStyle(font: fontNormal, fontSize: 9),
              ),
              if (notes.isNotEmpty) ...[
                pw.SizedBox(height: 10),
                pw.Text(
                  'Doctor / Clinical Notes:',
                  style: pw.TextStyle(font: fontBold, fontSize: 9),
                ),
                pw.SizedBox(height: 2),
                pw.Text(
                  notes,
                  style: pw.TextStyle(font: fontNormal, fontSize: 9, color: PdfColors.grey700),
                ),
              ],
              pw.Spacer(),

              // Signature Area
              pw.Divider(thickness: 0.5, color: PdfColors.grey300),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Disclaimer:',
                        style: pw.TextStyle(font: fontBold, fontSize: 8, color: PdfColors.grey800),
                      ),
                      pw.SizedBox(height: 2),
                      pw.Container(
                        width: 250,
                        child: pw.Text(
                          'This report is generated by an artificial intelligence model for educational and informational purposes. It does not constitute formal medical diagnosis or advice. Please consult with a qualified dermatologist or medical practitioner for actual clinical assessment.',
                          style: pw.TextStyle(font: fontNormal, fontSize: 7, color: PdfColors.grey600, height: 1.3),
                        ),
                      ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Container(
                        width: 100,
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(
                            bottom: pw.BorderSide(color: PdfColors.grey400, width: 0.5),
                          ),
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        'Authorized Signature',
                        style: pw.TextStyle(font: fontNormal, fontSize: 8, color: PdfColors.grey700),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    final output = await getApplicationDocumentsDirectory();
    final file = File('${output.path}/AetherDx_Report_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await pdf.save());
    await OpenFile.open(file.path);
  }
}
