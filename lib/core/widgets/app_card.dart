import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/radius.dart';
import '../theme/shadows.dart';
import '../theme/spacing.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.backgroundColor = AppColors.cardBg,
    this.width,
    this.height,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardContent = Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(AppSpacing.cardInternalPadding),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadius.cardBorderRadius,
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [AppShadows.soft],
      ),
      child: child,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: cardContent,
      );
    }
    return cardContent;
  }
}
