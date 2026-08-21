import 'package:flutter/material.dart';

class AppColors {
  // Theme Backgrounds
  static const Color background = Color(0xFF0A0E17);
  static const Color cardSurface = Color(0xFF121824);
  static const Color cardSurfaceLight = Color(0xFF1A2234);
  static const Color cardBorder = Color(0xFF1E293B);
  static const Color cardBorderGlow = Color(0xFF334155);

  // Brand Colors & Gradient Accents (#10CDA8 & #14B8D1)
  static const Color brandPrimary = Color(0xFF10CDA8);
  static const Color brandSecondary = Color(0xFF14B8D1);

  static const Color gold = Color(0xFF14B8D1);
  static const Color goldDark = Color(0xFF10CDA8);
  static const Color teal = Color(0xFF10CDA8);
  static const Color cyan = Color(0xFF14B8D1);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [brandPrimary, brandSecondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGlowGradient = LinearGradient(
    colors: [Color(0x2010CDA8), Color(0x2014B8D1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Currency Strengthening / Weakening indicators
  // EGP Strengthening: #00E676 (Green)
  static const Color greenStrengthening = Color(0xFF00E676);
  // EGP Weakening: #FF5252 (Coral Red)
  static const Color redWeakening = Color(0xFFFF5252);

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  // Offline Banner
  static const Color amberOffline = Color(0xFFF59E0B);
  static const Color amberOfflineDark = Color(0xFF78350F);
}
