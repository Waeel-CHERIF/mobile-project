import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryDark = Color(0xFF5A52D5);
  static const Color primaryLight = Color(0xFF8B85FF);

  static const Color background = Color(0xFF0F0F1A);
  static const Color surface = Color(0xFF1A1A2E);
  static const Color cardBg = Color(0xFF25253D);

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA0A0B0);
  static const Color textHint = Color(0xFF6B6B80);

  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE57373);
  static const Color warning = Color(0xFFFFB74D);
  static const Color info = Color(0xFF64B5F6);

  static const Color progressBg = Color(0xFF333355);
  static const Color progressFilled = primary;

  static const List<Color> chartColors = [
    primary,
    primaryLight,
    Color(0xFF9C97FF),
    Color(0xFFB0ABFF),
    Color(0xFFC4BFFF),
  ];
}
