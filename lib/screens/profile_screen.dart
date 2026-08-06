import 'package:flutter/material.dart';
import 'package:aetherdx/core/theme/colors.dart';
import 'package:aetherdx/core/theme/typography.dart';
import 'package:aetherdx/core/theme/radius.dart';
import 'package:aetherdx/core/widgets/app_bar.dart';
import 'package:aetherdx/core/widgets/app_button.dart';
import 'package:aetherdx/core/widgets/app_card.dart';
import 'package:aetherdx/screens/login_screen.dart';
import 'package:aetherdx/state/app_state.dart';
import 'package:aetherdx/core/network/api_service.dart';
import 'package:aetherdx/core/localization/translations.dart';

class ProfileScreen extends StatelessWidget {
  final VoidCallback onBackPressed;

  const ProfileScreen({
    super.key,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final AppState appState = AppState();

    return ListenableBuilder(
      listenable: appState,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: CustomAppBar(
            title: 'Profile'.tr(),
            onBackPressed: onBackPressed,
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),

                  // 2. Double-ring Profile Avatar
                  GestureDetector(
                    onTap: () => _showEditProfileSheet(context, appState),
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primary, width: 2),
                        ),
                        child: appState.buildAvatarWidget(50),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 3. Name & Username
                  Text(
                    appState.name,
                    style: AppTypography.screenTitle.copyWith(fontSize: 22),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '@${appState.username}',
                    style: AppTypography.caption,
                  ),
                  const SizedBox(height: 24),

                  // 4. Edit Profile Button
                  AppButton(
                    text: 'Edit Profile'.tr(),
                    onPressed: () => _showEditProfileSheet(context, appState),
                  ),
                  const SizedBox(height: 24),

                  // Health Summary Profile Card
                  _buildHealthProfileCard(context, appState),

                  const SizedBox(height: 24),

                  // 5. Settings List Card Container
                  AppCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        _buildMenuItem(
                          context,
                          icon: Icons.language,
                          title: 'Language'.tr(),
                          trailingText: appState.language,
                          onTap: () => _showLanguageSheet(context, appState),
                        ),
                        _buildMenuItem(
                          context,
                          icon: Icons.notifications_none_rounded,
                          title: 'Notifications',
                          trailingText: appState.pushNotifications ? 'On' : 'Off',
                          onTap: () => _showNotificationsSheet(context, appState),
                        ),
                        _buildMenuItem(
                          context,
                          icon: Icons.sync_rounded,
                          title: 'Offline Data & Sync',
                          trailingText: appState.lastSync == 'Just now' ? 'Synced' : appState.lastSync,
                          onTap: () => _showSyncSheet(context, appState),
                        ),
                        const Divider(
                          color: Color(0xFFF1F5F9),
                          thickness: 1.5,
                          height: 1,
                          indent: 16,
                          endIndent: 16,
                        ),
                        _buildMenuItem(
                          context,
                          icon: Icons.help_outline_rounded,
                          title: 'Help & Support',
                          onTap: () => _showHelpSheet(context),
                        ),
                        _buildMenuItem(
                          context,
                          icon: Icons.logout_rounded,
                          title: 'Log Out'.tr(),
                          textColor: AppColors.error,
                          iconColor: AppColors.error,
                          showChevron: false,
                          onTap: () async {
                            debugPrint("LOGOUT: Initiating logout flow...");
                            // Clear stored session tokens
                            await ApiService.logout();
                            debugPrint("LOGOUT: Session tokens removed from SharedPreferences.");
                            // Clear in-memory AppState
                            appState.clear();
                            debugPrint("LOGOUT: AppState cleared. Navigating to LoginScreen...");
                            if (context.mounted) {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (_) => const LoginScreen()),
                                (route) => false,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHealthProfileCard(BuildContext context, AppState appState) {
    return AppCard(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Profile Details'.tr(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Row of key metrics
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetricItem(Icons.wc_rounded, 'Gender'.tr(), appState.gender.isEmpty ? '-' : appState.gender),
              _buildMetricItem(Icons.cake_rounded, 'DOB'.tr(), appState.dob.isEmpty ? '-' : appState.dob),
              _buildMetricItem(Icons.phone_rounded, 'Phone'.tr(), appState.phoneNumber.isEmpty ? '-' : appState.phoneNumber),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(IconData icon, String label, String value) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF94A3B8)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF94A3B8),
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    String? trailingText,
    Color textColor = AppColors.textPrimary,
    Color iconColor = AppColors.textPrimary,
    bool showChevron = true,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
      leading: Icon(icon, color: iconColor, size: 22),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(
              trailingText,
              style: AppTypography.caption,
            ),
          if (showChevron) ...[
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.placeholder,
              size: 20,
            ),
          ],
        ],
      ),
      onTap: onTap,
    );
  }

  // --- Bottom Sheet Implementations ---
  void _showEditProfileSheet(BuildContext context, AppState appState) {
    final nameController = TextEditingController(text: appState.name);
    final usernameController = TextEditingController(text: appState.username);
    final emailController = TextEditingController(text: appState.email);
    final phoneController = TextEditingController(text: appState.phoneNumber);
    
    DateTime? dobValue = appState.dob.isNotEmpty ? DateTime.tryParse(appState.dob) : null;
    final dobController = TextEditingController(text: appState.dob);
    
    String? selectedGender = appState.gender.isEmpty ? null : appState.gender;
    if (selectedGender != null && !['Male', 'Female', 'Other', 'Prefer not to say'].contains(selectedGender)) {
      selectedGender = null;
    }

    final formKey = GlobalKey<FormState>();
    AvatarType selectedAvatar = appState.avatarType;
    bool isSaving = false;

    InputDecoration buildInputDecoration(String hintText, {Widget? suffixIcon, String? prefixText, String? suffixText}) {
      return InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.placeholder, fontSize: 14),
        fillColor: AppColors.background,
        filled: true,
        prefixText: prefixText,
        prefixStyle: const TextStyle(color: AppColors.placeholder, fontWeight: FontWeight.bold),
        suffixText: suffixText,
        suffixStyle: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold, fontSize: 13),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: AppRadius.inputBorderRadius,
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      );
    }

    Widget buildSectionHeader(String title) {
      return Padding(
        padding: const EdgeInsets.only(top: 24, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 6),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
          ],
        ),
      );
    }

    Widget buildFieldLabel(String label) {
      return Padding(
        padding: const EdgeInsets.only(top: 14, bottom: 6),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      );
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.85,
                ),
                padding: const EdgeInsets.fromLTRB(28, 28, 28, 16),
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
                          const Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Scrollable content
                      Flexible(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Avatar Selection
                              buildFieldLabel('Choose Avatar'),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: AvatarType.values.map((type) {
                                  final isSelected = selectedAvatar == type;
                                  Widget avatarPreview;

                                  if (type == AvatarType.asset) {
                                    avatarPreview = const CircleAvatar(
                                      radius: 24,
                                      backgroundImage: AssetImage('assets/images/profile_avatar.png'),
                                    );
                                  } else {
                                    List<Color> colors;
                                    String label;
                                    switch (type) {
                                      case AvatarType.ocean:
                                        colors = const [Color(0xFF06B6D4), Color(0xFF0EA5E9)];
                                        label = 'O';
                                        break;
                                      case AvatarType.sunset:
                                        colors = const [Color(0xFFF97316), Color(0xFFEF4444)];
                                        label = 'S';
                                        break;
                                      case AvatarType.amethyst:
                                        colors = const [Color(0xFFD946EF), Color(0xFF8B5CF6)];
                                        label = 'A';
                                        break;
                                      case AvatarType.emerald:
                                        colors = const [Color(0xFF10B981), Color(0xFF059669)];
                                        label = 'E';
                                        break;
                                      default:
                                        colors = const [Colors.grey, Colors.blueGrey];
                                        label = 'U';
                                    }
                                    avatarPreview = Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(colors: colors),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        label,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    );
                                  }

                                  return GestureDetector(
                                    onTap: () {
                                      setSheetState(() {
                                        selectedAvatar = type;
                                      });
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 150),
                                      padding: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isSelected ? AppColors.primary : Colors.transparent,
                                          width: 2.5,
                                        ),
                                      ),
                                      child: avatarPreview,
                                    ),
                                  );
                                }).toList(),
                              ),

                              // Section: Account Details
                              buildSectionHeader('Account Details'),
                              
                              buildFieldLabel('Full Name'),
                              TextFormField(
                                controller: nameController,
                                decoration: buildInputDecoration('Enter your name'),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Name cannot be empty';
                                  }
                                  return null;
                                },
                              ),

                              buildFieldLabel('Username'),
                              TextFormField(
                                controller: usernameController,
                                decoration: buildInputDecoration('Enter username', prefixText: '@'),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Username cannot be empty';
                                  }
                                  if (value.contains(' ')) {
                                    return 'Username cannot contain spaces';
                                  }
                                  return null;
                                },
                              ),

                              buildFieldLabel('Email'),
                              TextFormField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: buildInputDecoration('Enter email address'),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Email cannot be empty';
                                  }
                                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                    return 'Enter a valid email address';
                                  }
                                  return null;
                                },
                              ),

                              buildFieldLabel('Mobile Number'),
                              TextFormField(
                                controller: phoneController,
                                keyboardType: TextInputType.phone,
                                decoration: buildInputDecoration('Enter mobile number'),
                              ),

                              // Section: Personal Info
                              buildSectionHeader('Personal Info'),

                              buildFieldLabel('Date of Birth'),
                              TextFormField(
                                controller: dobController,
                                readOnly: true,
                                decoration: buildInputDecoration(
                                  'Select Date of Birth',
                                  suffixIcon: const Icon(Icons.calendar_today_rounded, color: Color(0xFF94A3B8), size: 20),
                                ),
                                onTap: () async {
                                  final DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: dobValue ?? DateTime(2000, 1, 1),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now(),
                                  );
                                  if (picked != null) {
                                    setSheetState(() {
                                      dobValue = picked;
                                      dobController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                                    });
                                  }
                                },
                              ),

                              buildFieldLabel('Gender'),
                              DropdownButtonFormField<String>(
                                initialValue: selectedGender,
                                decoration: buildInputDecoration('Select Gender'),
                                dropdownColor: Colors.white,
                                items: ['Male', 'Female', 'Other', 'Prefer not to say'].map((String val) {
                                  return DropdownMenuItem<String>(
                                    value: val,
                                    child: Text(val, style: const TextStyle(fontSize: 14, color: AppColors.textPrimary)),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  setSheetState(() {
                                    selectedGender = val;
                                  });
                                },
                              ),
                              
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),

                      // Save Button
                      AppButton(
                        text: isSaving ? 'Saving Changes...' : 'Save Changes',
                        onPressed: () {
                          if (isSaving) return;
                          if (formKey.currentState!.validate()) {
                            () async {
                              setSheetState(() => isSaving = true);
                              try {
                                final profilePayload = {
                                  'full_name': nameController.text.trim(),
                                  'mobile_number': phoneController.text.trim().isEmpty ? 'Not Specified' : phoneController.text.trim(),
                                  'dob': dobController.text.trim().isEmpty ? '2000-01-01' : dobController.text.trim(),
                                  'gender': selectedGender ?? 'Not Specified',
                                  'blood_group': 'Not Specified',
                                  'height': 'Not Specified',
                                  'weight': 'Not Specified',
                                  'medical_conditions': null,
                                  'medications': null,
                                  'allergies': null,
                                  'emergency_contact_name': 'Not Specified',
                                  'emergency_contact_relationship': 'Not Specified',
                                  'emergency_contact_number': 'Not Specified',
                                  'consent_terms': true,
                                  'consent_storage': true,
                                  'consent_medical': true,
                                };

                                final success = await ApiService.saveUserProfile(profilePayload);
                                if (!success) throw Exception('Failed to save profile changes.');

                                // Sync locally (notifies listeners automatically!)
                                appState.name = nameController.text.trim();
                                appState.username = usernameController.text.trim();
                                appState.email = emailController.text.trim();
                                appState.phoneNumber = phoneController.text.trim();
                                appState.dob = dobController.text.trim();
                                appState.gender = selectedGender ?? '';
                                appState.bloodGroup = 'Not Specified';
                                appState.height = 'Not Specified';
                                appState.weight = 'Not Specified';
                                appState.medicalConditions = '';
                                appState.medications = '';
                                appState.allergies = '';
                                appState.emergencyContactName = 'Not Specified';
                                appState.emergencyContactRelationship = 'Not Specified';
                                appState.emergencyContactNumber = 'Not Specified';
                                appState.avatarType = selectedAvatar;

                                if (context.mounted) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Profile updated successfully!'),
                                      backgroundColor: AppColors.success,
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
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
                                setSheetState(() => isSaving = false);
                              }
                            }();
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

  void _showLanguageSheet(BuildContext context, AppState appState) {
    final List<String> languages = [
      'English',
      'Hindi (हिन्दी)',
      'Marathi (मराठी)',
      'Bengali (বাংলা)',
      'Telugu (తెలుగు)',
      'Tamil (தமிழ்)',
      'Gujarati (ગુજરાતી)',
      'Kannada (ಕನ್ನಡ)',
      'Malayalam (മലയാളം)',
      'Punjabi (ਪੰਜਾਬੀ)',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.card)),
          ),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.55,
          ),
          padding: const EdgeInsets.fromLTRB(28, 20, 28, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Select Language'.tr(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
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
              Flexible(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: languages.map((lang) {
                      final isSelected = appState.language == lang;
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          lang,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                            color: isSelected ? AppColors.primary : AppColors.textPrimary,
                          ),
                        ),
                        trailing: isSelected
                            ? const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 22)
                            : null,
                        onTap: () {
                          appState.language = lang;
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Language changed to '.trWith(lang)),
                              backgroundColor: AppColors.success,
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showNotificationsSheet(BuildContext context, AppState appState) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ListenableBuilder(
          listenable: appState,
          builder: (context, _) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.card)),
              ),
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Notification Settings',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    activeColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Push Notifications',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    ),
                    subtitle: const Text('Receive instant alerts about reports and sync status'),
                    value: appState.pushNotifications,
                    onChanged: (val) => appState.pushNotifications = val,
                  ),
                  SwitchListTile(
                    activeColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Email Notifications',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    ),
                    subtitle: const Text('Receive report summaries in your inbox'),
                    value: appState.emailNotifications,
                    onChanged: (val) => appState.emailNotifications = val,
                  ),
                  SwitchListTile(
                    activeColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Weekly Analysis Reports',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    ),
                    subtitle: const Text('Get weekly breakdowns of your nail scan metrics'),
                    value: appState.weeklyReports,
                    onChanged: (val) => appState.weeklyReports = val,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showSyncSheet(BuildContext context, AppState appState) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ListenableBuilder(
          listenable: appState,
          builder: (context, _) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.card)),
              ),
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Offline Data & Sync',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSyncStat('DB Type', 'SQLite (Encrypted)'),
                      _buildSyncStat('Database Size', '12.4 MB'),
                      _buildSyncStat('Last Synced', appState.lastSync),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: AppColors.secondaryBg, thickness: 1.5),

                  SwitchListTile(
                    activeColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Auto-Sync on Wi-Fi',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    ),
                    subtitle: const Text('Keep local scans synchronized automatically'),
                    value: appState.autoSync,
                    onChanged: (val) => appState.autoSync = val,
                  ),
                  const SizedBox(height: 24),

                  // Sync Now Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: appState.isSyncing
                          ? null
                          : () async {
                              await appState.performSync();
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Database synchronized successfully!'),
                                    backgroundColor: AppColors.success,
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.buttonBorderRadius,
                        ),
                        disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
                      ),
                      child: appState.isSyncing
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text(
                              'Sync Now',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSyncStat(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: AppColors.placeholder,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  void _showHelpSheet(BuildContext context) {
    final supportController = TextEditingController();
    bool isSubmitting = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.card)),
                ),
                padding: const EdgeInsets.all(28),
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.85,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Help & Support',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Frequently Asked Questions',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const FAQTile(
                              question: 'How does the AI nail scanner work?',
                              answer:
                                  'Our AI model scans uploaded or captured photos of nails and identifies potential abnormalities like fungal infections, psoriasis, or structural damage. It cross-references images with classified clinical datasets.',
                            ),
                            const FAQTile(
                              question: 'Is my health data private and safe?',
                              answer:
                                  'Absolutely. Your security is our highest priority. All photos and scan results are locally stored on your device and synchronized via industry-standard secure HTTPS connections. We never distribute patient data.',
                            ),
                            const FAQTile(
                              question: 'Can the AI scanner replace a medical diagnosis?',
                              answer:
                                  'No. The AI nail scanner provides clinical probability and educational guidance. It is designed to encourage early consultation, not replace a professional evaluation by a qualified dermatologist.',
                            ),
                            const SizedBox(height: 24),
                            const Divider(color: AppColors.secondaryBg, thickness: 1.5),
                            const SizedBox(height: 16),
                            const Text(
                              'Need additional assistance?',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Send a query directly to our support crew, and we will get back to you within 24 hours.',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 14),
                            TextField(
                              controller: supportController,
                              maxLines: 4,
                              decoration: InputDecoration(
                                hintText: 'Describe your issue or feedback...',
                                hintStyle: const TextStyle(color: AppColors.placeholder, fontSize: 14),
                                fillColor: AppColors.background,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: AppRadius.inputBorderRadius,
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.all(16),
                              ),
                            ),
                            const SizedBox(height: 18),
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                onPressed: isSubmitting
                                    ? null
                                    : () async {
                                        if (supportController.text.trim().isEmpty) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Please write a message before sending.'),
                                              backgroundColor: AppColors.error,
                                            ),
                                          );
                                          return;
                                        }

                                        setSheetState(() {
                                          isSubmitting = true;
                                        });

                                        // Simulate submitting support ticket
                                        await Future.delayed(const Duration(seconds: 1));

                                        if (context.mounted) {
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Support query sent! Check your inbox soon.'),
                                              backgroundColor: AppColors.success,
                                              duration: Duration(milliseconds: 2500),
                                            ),
                                          );
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: AppRadius.buttonBorderRadius,
                                  ),
                                  disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
                                ),
                                child: isSubmitting
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                    : const Text(
                                        'Submit Ticket',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// Custom Accordion Widget for FAQs
class FAQTile extends StatefulWidget {
  final String question;
  final String answer;

  const FAQTile({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  State<FAQTile> createState() => _FAQTileState();
}

class _FAQTileState extends State<FAQTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      decoration: BoxDecoration(
        color: AppColors.secondaryBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              widget.question,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            trailing: Icon(
              _isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
              color: AppColors.textSecondary,
            ),
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
              child: Text(
                widget.answer,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
