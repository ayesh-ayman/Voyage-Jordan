import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voyage_jordan2/shared/theme/app_colors.dart';

class AppTheme {
  static ThemeData _baseTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final textTheme = GoogleFonts.poppinsTextTheme().apply(
      bodyColor: isDark ? Colors.white : AppColors.textPrimary,
      displayColor: isDark ? Colors.white : AppColors.textPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: isDark ? const Color(0xFF121212) : AppColors.background,
      colorScheme: isDark
          ? ColorScheme.dark(
              primary: AppColors.primaryGold,
              onPrimary: AppColors.onPrimaryGold,
              secondary: AppColors.accentSoft,
              surface: const Color(0xFF1E1E1E),
              onSurface: Colors.white,
            )
          : ColorScheme.light(
              primary: AppColors.primaryGold,
              onPrimary: AppColors.onPrimaryGold,
              secondary: AppColors.accentSoft,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
      textTheme: textTheme.copyWith(
        displayLarge: textTheme.displayLarge?.copyWith(fontWeight: FontWeight.w700),
        titleLarge: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        titleMedium: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: false,
        foregroundColor: AppColors.textPrimary,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: textTheme.titleLarge?.fontFamily,
        ),
        shape: Border(
          bottom: BorderSide(color: AppColors.primaryGold.withValues(alpha: 0.35), width: 1),
        ),
      ),
      cardTheme: CardThemeData(
        color: isDark ? const Color(0xFF1E1E1E) : AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: isDark ? const Color(0xFF2A2A2A) : AppColors.surfaceSoft,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(color: isDark ? AppColors.textMuted : AppColors.textSecondary),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primaryGold.withValues(alpha: 0.15),
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.06),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primaryGold);
          }
          return const IconThemeData(color: AppColors.textSecondary);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            );
          }
          return const TextStyle(color: AppColors.textSecondary, fontSize: 12);
        }),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGold,
          foregroundColor: AppColors.onPrimaryGold,
          elevation: 0,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primaryGold,
          foregroundColor: AppColors.onPrimaryGold,
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryGold,
          side: const BorderSide(color: AppColors.primaryGold, width: 1.2),
        ),
      ),
    );
  }

  static ThemeData get light => _baseTheme(Brightness.light);

  static ThemeData get dark => _baseTheme(Brightness.dark);
}
