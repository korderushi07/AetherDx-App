import 'package:flutter/material.dart';
import 'dart:ui';
import '../core/theme/colors.dart';
import '../core/theme/shadows.dart';
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
    Widget body;
    switch (_currentIndex) {
      case 0:
        body = DashboardScreen(
          onUploadNailImagePressed: () {
            setState(() {
              _currentIndex = 1;
            });
          },
        );
        break;
      case 1:
        body = ScanNailScreen(
          onBackPressed: () {
            setState(() {
              _currentIndex = 0;
            });
          },
        );
        break;
      case 2:
        body = HistoryScreen(
          onBackPressed: () {
            setState(() {
              _currentIndex = 0;
            });
          },
        );
        break;
      case 3:
        body = ProfileScreen(
          onBackPressed: () {
            setState(() {
              _currentIndex = 0;
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35),
            boxShadow: [AppShadows.soft],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(35),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(35),
                  border: Border.all(color: AppColors.border, width: 0.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(0, _currentIndex == 0 ? Icons.home_rounded : Icons.home_outlined),
                    _buildNavItem(1, _currentIndex == 1 ? Icons.qr_code_scanner_rounded : Icons.qr_code_scanner_outlined),
                    _buildNavItem(2, _currentIndex == 2 ? Icons.assignment_rounded : Icons.assignment_outlined),
                    _buildNavItem(3, _currentIndex == 3 ? Icons.person_rounded : Icons.person_outline),
                  ],
                ),
              ),
            ),
          ),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.placeholder,
              size: 24,
            ),
          ),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeInOut,
            opacity: isSelected ? 1.0 : 0.0,
            child: Container(
              width: 16,
              height: 3,
              decoration: BoxDecoration(
                color: AppColors.ai,
                borderRadius: BorderRadius.circular(1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
