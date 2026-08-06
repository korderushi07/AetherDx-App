import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/typography.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final bool showNotification;
  final Widget? trailing;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onBackPressed,
    this.showNotification = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      child: NavigationToolbar(
        leading: onBackPressed != null
            ? Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: onBackPressed,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: AppColors.textPrimary,
                      size: 20,
                    ),
                  ),
                ),
              )
            : const SizedBox(width: 44),
        middle: Text(
          title,
          style: AppTypography.screenTitle.copyWith(fontSize: 22),
          textAlign: TextAlign.center,
        ),
        trailing: trailing ?? const SizedBox(width: 44),
        centerMiddle: true,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}
