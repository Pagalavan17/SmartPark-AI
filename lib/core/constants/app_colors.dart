import 'package:flutter/material.dart';

/// App Core Color Palette following Material Design 3 guidelines.
class AppColors {
  AppColors._();

  // Primary Theme Colors (Specified by Design Specs)
  static const Color primary = Color(0xFF1565C0);
  static const Color secondary = Color(0xFF42A5F5);
  static const Color background = Color(0xFFF8FAFC);
  static const Color card = Color(0xFFFFFFFF);

  // Dark Theme Palette Tokens (True Black AMOLED Style)
  static const Color darkBackground = Color(0xFF000000);
  static const Color darkCard = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF121212);
  static const Color darkElevatedSurface = Color(0xFF1A1A1A);
  static const Color darkInputSurface = Color(0xFF151515);
  static const Color darkSecondarySurface = Color(0xFF181818);
  static const Color darkBorder = Color(0xFF2A2A2A);
  static const Color darkDivider = Color(0xFF2A2A2A);
  static const Color darkSurfaceVariant = Color(0xFF1A1A1A);

  // Accent & Status Colors
  static const Color accent = Color(0xFF00E676);
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFED6C02);
  static const Color error = Color(0xFFD32F2F);
  static const Color info = Color(0xFF0288D1);

  // Light Neutral Grays
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textLight = Color(0xFF64748B);
  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFF1F5F9);

  // Dark Neutral Tokens
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFBDBDBD);
  static const Color darkTextDisabled = Color(0xFF777777);
  static const Color darkTextLight = Color(0xFFBDBDBD);

  // Glassmorphism & Shadow Effects
  static const Color shadow = Color(0x0A000000);
  static const Color overlay = Color(0x33000000);
}
