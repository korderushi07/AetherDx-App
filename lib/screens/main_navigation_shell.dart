import 'package:flutter/material.dart';
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
            _buildNavItem(0, _currentIndex == 0 ? Icons.home : Icons.home_outlined),
            _buildNavItem(1, Icons.history),
            _buildNavItem(2, _currentIndex == 2 ? Icons.calendar_today : Icons.calendar_today_outlined),
            _buildNavItem(3, _currentIndex == 3 ? Icons.person : Icons.person_outline),
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




}
