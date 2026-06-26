import 'package:flutter/material.dart';
import 'colors.dart';

class AppTypography {
  // New 2026-R2 Typographic Scale
  static const TextStyle display = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w300, // Light
    color: AppColors.textPrimary,
    height: 1.1,
    letterSpacing: -1.0,
  );

  static const TextStyle heading1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600, // SemiBold
    color: AppColors.textPrimary,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500, // Medium
    color: AppColors.textPrimary,
    height: 1.3,
    letterSpacing: 0.0,
  );

  static const TextStyle cardTitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600, // SemiBold
    color: AppColors.textPrimary,
    height: 1.3,
    letterSpacing: 0.0,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400, // Regular
    color: AppColors.textPrimary,
    height: 1.5,
    letterSpacing: 0.0,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500, // Medium
    color: AppColors.textSecondary,
    height: 1.2,
    letterSpacing: 0.0,
  );

  static const TextStyle overline = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w700, // Bold
    color: AppColors.textTertiary,
    height: 1.1,
    letterSpacing: 1.2,
  );

  // Backward compatibility mappings
  static TextStyle get screenTitle => heading1;
  static TextStyle get sectionHeading => heading2;
}
