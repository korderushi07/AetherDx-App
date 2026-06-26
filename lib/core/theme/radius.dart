import 'package:flutter/material.dart';

class AppRadius {
  static const double card = 20.0;
  static const double button = 12.0;
  static const double inputField = 12.0;
  static const double image = 12.0;
  static const double badge = 8.0;
  static const double bottomSheet = 28.0;

  static BorderRadius get cardBorderRadius => BorderRadius.circular(card);
  static BorderRadius get buttonBorderRadius => BorderRadius.circular(button);
  static BorderRadius get inputBorderRadius => BorderRadius.circular(inputField);
  static BorderRadius get imageBorderRadius => BorderRadius.circular(image);
  static BorderRadius get badgeBorderRadius => BorderRadius.circular(badge);
  static BorderRadius get bottomSheetBorderRadius => BorderRadius.circular(bottomSheet);
}
