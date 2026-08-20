import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class AppTextStyles {
  // ── Rate / Price ───────────────────────────────────────────────────────────
  static TextStyle get rateLarge => TextStyle(
        fontSize: 34.sp,
        fontWeight: FontWeight.w900,
        color: AppColors.textPrimary,
        letterSpacing: -0.5,
      );

  static TextStyle get rateMedium => TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        letterSpacing: -0.3,
      );

  static TextStyle get rateSmall => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
      );

  // ── Currency Info ──────────────────────────────────────────────────────────
  static TextStyle get currencyCode => TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static TextStyle get currencyName => TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      );

  static TextStyle get currencyUnit => TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textSecondary,
      );

  // ── Badge / Change Indicator ───────────────────────────────────────────────
  static TextStyle get badgeLarge => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static TextStyle get badgeSmall => TextStyle(
        fontSize: 11.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  // ── AppBar / Titles ────────────────────────────────────────────────────────
  static TextStyle get appBarTitle => TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static TextStyle get appBarSubtitle => TextStyle(
        fontSize: 11.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      );

  static TextStyle get screenTitle => TextStyle(
        fontSize: 22.sp,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
      );

  // ── Section Labels ─────────────────────────────────────────────────────────
  static TextStyle get sectionLabel => TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: AppColors.textMuted,
      );

  static TextStyle get sectionLabelSmall => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: AppColors.textMuted,
      );

  // ── Body / Subtitle ────────────────────────────────────────────────────────
  static TextStyle get bodyPrimary => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  // ── Timestamp / Meta ───────────────────────────────────────────────────────
  static TextStyle get timestamp => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textMuted,
      );

  static TextStyle get timestampSmall => TextStyle(
        fontSize: 11.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textMuted,
      );

  // ── Error ──────────────────────────────────────────────────────────────────
  static TextStyle get errorTitle => TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static TextStyle get errorBody => TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  // ── Button ─────────────────────────────────────────────────────────────────
  static TextStyle get button => TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w700,
      );

  // ── Chart ─────────────────────────────────────────────────────────────────
  static TextStyle get chartAxis => TextStyle(
        fontSize: 10.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textMuted,
      );

  static TextStyle get chartTooltip => TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w800,
        color: AppColors.teal,
      );

  // ── Pill / Tag ────────────────────────────────────────────────────────────
  static TextStyle get pill => TextStyle(
        fontSize: 10.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.teal,
      );

  // ── Emoji flags ───────────────────────────────────────────────────────────
  static TextStyle get flagLarge => TextStyle(fontSize: 32.sp);
  static TextStyle get flagMedium => TextStyle(fontSize: 26.sp);
}

// ─────────────────────────────────────────────────────────────────────────────

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      // ── Color Scheme ────────────────────────────────────────────────────────
      colorScheme: const ColorScheme.dark(
        primary: AppColors.teal,
        secondary: AppColors.gold,
        surface: AppColors.cardSurface,
        onPrimary: AppColors.background,
        onSurface: AppColors.textPrimary,
        error: AppColors.redWeakening,
      ),
      // ── AppBar ───────────────────────────────────────────────────────────────
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
      // ── Card ─────────────────────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: AppColors.cardSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppColors.cardBorder, width: 1),
        ),
      ),
      // ── ElevatedButton ───────────────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.teal,
          foregroundColor: AppColors.background,
          elevation: 0,
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
        ),
      ),
      // ── IconButton ───────────────────────────────────────────────────────────
      iconButtonTheme: const IconButtonThemeData(
        style: ButtonStyle(
          iconColor: WidgetStatePropertyAll(AppColors.textPrimary),
        ),
      ),
      // ── Divider ──────────────────────────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: AppColors.cardBorder,
        thickness: 1,
      ),
      // ── Snackbar ─────────────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.cardSurfaceLight,
        contentTextStyle: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
      // ── Page Transitions (Cupertino on all platforms) ─────────────────────────
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
