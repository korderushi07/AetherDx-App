import 'package:flutter/material.dart';
import '../theme/typography.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const SectionTitle({
    super.key,
    required this.title,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    if (trailing != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTypography.sectionHeading),
          trailing!,
        ],
      );
    }
    return Text(title, style: AppTypography.sectionHeading);
  }
}
