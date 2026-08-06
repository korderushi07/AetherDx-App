import 'package:flutter/material.dart';
import '../core/theme/colors.dart';
import '../state/app_state.dart';
import '../core/localization/translations.dart';
import 'dashboard_screen.dart';
import 'scan_nail_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';

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
          onProfilePressed: () {
            setState(() {
              _currentIndex = 3; // Switch to Profile screen (index 3)
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
        body = HistoryScreen(
          onBackPressed: () {
            setState(() {
              _currentIndex = 0; // Go back to Dashboard
            });
          },
        );
        break;
      case 3:
        body = ProfileScreen(
          onBackPressed: () {
            setState(() {
              _currentIndex = 0; // Go back to Dashboard (index 0)
            });
          },
        );
        break;
      default:
        body = const SizedBox.shrink();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: body,
      bottomNavigationBar: ListenableBuilder(
        listenable: AppState(),
        builder: (context, _) {
          return Container(
            padding: EdgeInsets.only(
              top: 6,
              bottom: MediaQuery.of(context).padding.bottom > 0
                  ? MediaQuery.of(context).padding.bottom + 6
                  : 16.0, // Robust spacing fallback to prevent system button overlap
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Color(0xFFE2E8F0), // Light grey line at top
                  width: 1.0,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, _currentIndex == 0 ? Icons.space_dashboard_rounded : Icons.space_dashboard_outlined, 'Dashboard'.tr()),
                _buildNavItem(1, _currentIndex == 1 ? Icons.center_focus_strong_rounded : Icons.center_focus_strong_outlined, 'Scan'.tr()),
                _buildNavItem(2, _currentIndex == 2 ? Icons.analytics_rounded : Icons.analytics_outlined, 'History'.tr()),
                _buildNavItem(3, _currentIndex == 3 ? Icons.person_rounded : Icons.person_outline, 'Profile'.tr()),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final bool isSelected = _currentIndex == index;
    final Color activeColor = AppColors.primary;
    final Color inactiveColor = const Color(0xFF94A3B8);

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? activeColor : inactiveColor,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? activeColor : inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }




}
