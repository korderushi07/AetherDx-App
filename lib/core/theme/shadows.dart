import 'package:flutter/material.dart';

class AppShadows {
  static final BoxShadow soft = BoxShadow(
    color: Colors.black.withValues(alpha: 0.04),
    blurRadius: 16,
    offset: const Offset(0, 4),
  );
}
