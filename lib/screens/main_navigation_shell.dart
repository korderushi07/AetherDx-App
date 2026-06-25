import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'scan_nail_screen.dart';

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Construct the active body content
    Widget body;
    switch (_currentIndex) {
      case 0:
        body = DashboardScreen(
          onUploadNailImagePressed: () {
            setState(() {
              _currentIndex = 1; // Switch to Scan Nail screen (index 1)
            });
          },
        );
        break;
      case 1:
        body = ScanNailScreen(
          onBackPressed: () {
            setState(() {
              _currentIndex = 0; // Go back to Dashboard (index 0)
            });
          },
        );
        break;
      case 2:
        body = _buildCalendarPlaceholder();
        break;
      case 3:
        body = _buildProfilePlaceholder();
        break;
      default:
        body = const SizedBox.shrink();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFCFDFF),
      body: body,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF22252A),
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.home_filled),
            _buildNavItem(1, Icons.all_inbox_outlined),
            _buildNavItem(2, Icons.calendar_today_outlined),
            _buildNavItem(3, Icons.person_outline),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon) {
    final bool isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF49C3DF) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isSelected ? const Color(0xFF22252A) : const Color(0xFF90A4AE),
          size: 24,
        ),
      ),
    );
  }

  Widget _buildCalendarPlaceholder() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Appointments',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1F484C),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Manage your checkups and analysis history',
              style: TextStyle(fontSize: 14, color: Color(0xFF718096)),
            ),
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 64,
                      color: Color(0xFF94A3B8),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No Upcoming Appointments',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F484C),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Schedule medical consults and tracking times.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Color(0xFF718096)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePlaceholder() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 48,
              backgroundImage: AssetImage('assets/images/profile_avatar.png'),
              backgroundColor: Colors.transparent,
            ),
            const SizedBox(height: 16),
            const Text(
              'Valentina',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1F484C),
              ),
            ),
            const Text(
              'valentina@medcare.com',
              style: TextStyle(fontSize: 13, color: Color(0xFF718096)),
            ),
            const SizedBox(height: 32),
            _buildProfileMenuItem(Icons.person_outline, 'Personal Details'),
            _buildProfileMenuItem(Icons.history_toggle_off_rounded, 'Analysis History'),
            _buildProfileMenuItem(Icons.settings_outlined, 'Account Settings'),
            _buildProfileMenuItem(Icons.help_outline_rounded, 'Help Center'),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Log Out'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFE53E3E),
                  side: const BorderSide(color: Color(0xFFFED7D7), width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileMenuItem(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF1F484C), size: 22),
              const SizedBox(width: 14),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8)),
        ],
      ),
    );
  }
}
