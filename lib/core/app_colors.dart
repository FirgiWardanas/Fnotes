import 'package:flutter/material.dart';

class AppColors {
  // Brand & Accent
  static const Color primary = Color(0xFF0D9488);
  static const Color primaryDark = Color(0xFF00685F);
  static const Color primaryContainer = Color(0xFF008378);
  static const Color secondary = Color(0xFF10B981);
  static const Color secondaryContainer = Color(0xFF6CF8BB);
  static const Color tertiary = Color(0xFFCCFBF1);

  // Background & Surfaces
  static const Color background = Color(0xFFFAF8FF);
  static const Color surface = Color(0xFFFAF8FF);
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF2F3FF);

  // Text & Borders
  static const Color onSurface = Color(0xFF131B2E);
  static const Color onSurfaceVariant = Color(0xFF64748B);
  static const Color outline = Color(0xFFE2E8F0);
  static const Color outlineVariant = Color(0xFFCBD5E1);

  // ponytail: constant palette fixed. Upgrade path: ThemeData ColorScheme dynamic switching if dark mode needed.
}
