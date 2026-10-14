import 'package:flutter/material.dart';

/// Single source of truth: exact fill from Home "Start Planning" [`ElevatedButton.backgroundColor`].
class AppColors {
  AppColors._();

  static const Color primaryGold = Color(0xFFE0B57C);

  /// Text / icons on primary gold (dark neutral, no blue).
  static const Color onPrimaryGold = Color(0xFF2A2A2A);

  static const Color background = Color(0xFFF8F7F3);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceSoft = Color(0xFFFAF9F7);

  /// Same as [primaryGold] — app-wide accent.
  static const Color accent = primaryGold;
  /// Existing warm cream used for day headers (same hue family as [primaryGold]).
  static const Color accentSoft = Color(0xFFF9F1E7);

  static const Color textPrimary = Color(0xFF2A2A2A);
  static const Color textSecondary = Color(0xFF6E6E6E);
  static const Color textMuted = Color(0xFF9A9A9A);

  static const Color borderSubtle = Color(0xFFE8E4DF);
  static const Color borderGoldLight = Color(0x40E0B57C);

  static const Color success = Color(0xFF3DD598);
  static const Color danger = Color(0xFFFF6B6B);

  static Color primaryGoldOverlay(double opacity) => primaryGold.withValues(alpha: opacity);
}
