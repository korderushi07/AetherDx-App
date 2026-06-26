import 'package:flutter/material.dart';

class AetherMotion {
  // Durations
  static const fast   = Duration(milliseconds: 150);
  static const normal = Duration(milliseconds: 220);
  static const slow   = Duration(milliseconds: 300);
  static const max    = Duration(milliseconds: 350); // Hard ceiling. Never exceed.

  // Curves
  static const standard  = Curves.easeInOut;
  static const enter     = Curves.easeOutCubic;
  static const exit      = Curves.easeInCubic;
  static const emphasis  = Curves.fastOutSlowIn;

  // Stagger
  static const staggerStep = Duration(milliseconds: 50);

  // Spatial offsets
  static const slideDistanceSmall  = 8.0;   // cards, list items
  static const slideDistanceNormal = 14.0;  // screen transitions
  static const slideDistanceLarge  = 20.0;  // page entry

  // Accessibility helper to dynamically check Reduced Motion settings
  static Duration duration(BuildContext context, Duration baseDuration) {
    final reduced = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    return reduced ? Duration.zero : baseDuration;
  }
}
