import 'package:flutter/material.dart';
import 'package:maroapp/core/theme/colors.dart';
import 'package:maroapp/core/theme/typography.dart';
import 'package:maroapp/core/theme/radius.dart';
import 'package:maroapp/core/theme/spacing.dart';
import 'package:maroapp/core/widgets/app_bar.dart';
import 'package:maroapp/core/widgets/app_button.dart';
import 'package:maroapp/core/widgets/app_card.dart';
import 'package:maroapp/screens/login_screen.dart';
import 'package:maroapp/state/app_state.dart';

class ProfileScreen extends StatelessWidget {
  final VoidCallback onBackPressed;

  const ProfileScreen({
    super.key,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final AppState appState = AppState();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Profile',
        onBackPressed: onBackPressed,
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: appState,
          builder: (context, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),

                  // Profile Avatar: 72px circle with single 2px Indigo border
                  GestureDetector(
                    onTap: () => _showEditProfileSheet(context, appState),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.ai, width: 2.0),
                        ),
                        child: appState.buildAvatarWidget(36), // 36 radius = 72 diameter
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Name & Username
                  Text(
                    appState.name,
                    style: AppTypography.heading2,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '@${appState.username}',
                    style: AppTypography.caption,
                  ),
                  const SizedBox(height: 16),

                  // Edit Profile Button: Centered, Outlined/Secondary
                  Center(
                    child: SizedBox(
                      width: 160,
                      child: AppButton(
                        text: 'Edit Profile',
                        isPrimary: false,
                        onPressed: () => _showEditProfileSheet(context, appState),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Settings Card
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'SETTINGS',
                      style: AppTypography.overline,
                    ),
                  ),
                  const SizedBox(height: 8),
                  AppCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        _buildMenuItem(
                          context,
                          icon: Icons.language,
                          title: 'Language',
                          trailingText: appState.language,
                          onTap: () => _showLanguageSheet(context, appState),
                        ),
                        const Divider(height: 1, color: Color(0xFFF1F5F9)),
                        _buildMenuItem(
                          context,
                          icon: Icons.notifications_none_rounded,
                          title: 'Notifications',
                          trailingText: appState.pushNotifications ? 'On' : 'Off',
                          onTap: () => _showNotificationsSheet(context, appState),
                        ),
                        const Divider(height: 1, color: Color(0xFFF1F5F9)),
                        _buildMenuItem(
                          context,
                          icon: Icons.sync_rounded,
                          title: 'Data Sync',
                          trailingText: appState.lastSync == 'Just now' ? 'Synced' : appState.lastSync,
                          onTap: () => _showSyncSheet(context, appState),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sectionSpace),

                  // Support Card
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'SUPPORT',
                      style: AppTypography.overline,
                    ),
                  ),
                  const SizedBox(height: 8),
                  AppCard(
                    padding: EdgeInsets.zero,
                    child: _buildMenuItem(
                      context,
                      icon: Icons.help_outline_rounded,
                      title: 'Help & Support',
                      onTap: () => _showHelpSheet(context),
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Standalone Log Out Button at the bottom
                  AppButton(
                    text: 'Log Out',
                    isPrimary: false,
                    backgroundColor: Colors.white,
                    textColor: AppColors.error,
                    borderColor: AppColors.error,
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    String? trailingText,
    bool showChevron = true,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
      leading: Icon(icon, color: AppColors.textPrimary, size: 20),
      title: Text(
        title,
        style: AppTypography.cardTitle,
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
    final formKey = GlobalKey<FormState>();
    AvatarType selectedAvatar = appState.avatarType;

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
                padding: const EdgeInsets.all(28),
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
                            style: AppTypography.heading2,
                          ),
                          IconButton(
                            icon: const Icon(Icons.close_rounded),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Avatar Selection
                      const Text(
                        'Choose Avatar',
                        style: AppTypography.cardTitle,
                      ),
                      const SizedBox(height: 12),
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
                                  color: isSelected ? AppColors.ai : Colors.transparent,
                                  width: 2.5,
                                ),
                              ),
                              child: avatarPreview,
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),

                      // Name Field
                      const Text(
                        'Full Name',
                        style: AppTypography.cardTitle,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: nameController,
                        decoration: InputDecoration(
                          hintText: 'Enter your name',
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: AppRadius.inputBorderRadius,
                            borderSide: const BorderSide(color: AppColors.border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: AppRadius.inputBorderRadius,
                            borderSide: const BorderSide(color: AppColors.primary),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: AppRadius.inputBorderRadius,
                            borderSide: const BorderSide(color: AppColors.error),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: AppRadius.inputBorderRadius,
                            borderSide: const BorderSide(color: AppColors.error),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Name cannot be empty';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 18),

                      // Username Field
                      const Text(
                        'Username',
                        style: AppTypography.cardTitle,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          hintText: 'Enter username',
                          fillColor: Colors.white,
                          filled: true,
                          prefixText: '@',
                          prefixStyle: const TextStyle(color: AppColors.placeholder, fontWeight: FontWeight.bold),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: AppRadius.inputBorderRadius,
                            borderSide: const BorderSide(color: AppColors.border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: AppRadius.inputBorderRadius,
                            borderSide: const BorderSide(color: AppColors.primary),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: AppRadius.inputBorderRadius,
                            borderSide: const BorderSide(color: AppColors.error),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: AppRadius.inputBorderRadius,
                            borderSide: const BorderSide(color: AppColors.error),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
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
                      const SizedBox(height: 18),

                      // Email Field
                      const Text(
                        'Email',
                        style: AppTypography.cardTitle,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: 'Enter email address',
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: AppRadius.inputBorderRadius,
                            borderSide: const BorderSide(color: AppColors.border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: AppRadius.inputBorderRadius,
                            borderSide: const BorderSide(color: AppColors.primary),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: AppRadius.inputBorderRadius,
                            borderSide: const BorderSide(color: AppColors.error),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: AppRadius.inputBorderRadius,
                            borderSide: const BorderSide(color: AppColors.error),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
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
                      const SizedBox(height: 28),

                      // Save Button
                      AppButton(
                        text: 'Save Changes',
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            appState.name = nameController.text.trim();
                            appState.username = usernameController.text.trim();
                            appState.email = emailController.text.trim();
                            appState.avatarType = selectedAvatar;

                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Profile updated successfully!'),
                                backgroundColor: AppColors.success,
                                duration: Duration(seconds: 2),
                              ),
                            );
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
    final List<String> languages = ['English', 'Spanish', 'French', 'German', 'Japanese'];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
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
                    'Select Language',
                    style: AppTypography.heading2,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...languages.map((lang) {
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
                        content: Text('Language changed to $lang'),
                        backgroundColor: AppColors.success,
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                );
              }),
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
                        style: AppTypography.heading2,
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
                        style: AppTypography.heading2,
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
                  AppButton(
                    text: appState.isSyncing ? 'Syncing...' : 'Sync Now',
                    onPressed: appState.isSyncing
                        ? () {}
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
            style: AppTypography.overline,
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
                          style: AppTypography.heading2,
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
                              style: AppTypography.body,
                            ),
                            const SizedBox(height: 14),
                            TextField(
                              controller: supportController,
                              maxLines: 4,
                              decoration: InputDecoration(
                                hintText: 'Describe your issue or feedback...',
                                hintStyle: const TextStyle(color: AppColors.placeholder, fontSize: 14),
                                fillColor: Colors.white,
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: AppRadius.inputBorderRadius,
                                  borderSide: const BorderSide(color: AppColors.border),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: AppRadius.inputBorderRadius,
                                  borderSide: const BorderSide(color: AppColors.primary),
                                ),
                                contentPadding: const EdgeInsets.all(16),
                              ),
                            ),
                            const SizedBox(height: 18),
                            AppButton(
                              text: isSubmitting ? 'Submitting...' : 'Submit Ticket',
                              onPressed: isSubmitting
                                  ? () {}
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
              style: AppTypography.cardTitle,
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
                style: AppTypography.body.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
