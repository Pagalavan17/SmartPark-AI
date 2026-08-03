import 'package:flutter/material.dart';

/// App Core Color Palette following Material Design 3 guidelines.
class AppColors {
  AppColors._();

  // Primary Theme Colors (Specified by Design Specs)
  static const Color primary = Color(0xFF1565C0);
  static const Color secondary = Color(0xFF42A5F5);
  static const Color background = Color(0xFFF5F7FA);
  static const Color card = Color(0xFFFFFFFF);

  // Dark Theme Palette Placeholders
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkCard = Color(0xFF1E293B);
  static const Color darkSurface = Color(0xFF334155);

  // Accent & Status Colors
  static const Color accent = Color(0xFF00E676);
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFED6C02);
  static const Color error = Color(0xFFD32F2F);
  static const Color info = Color(0xFF0288D1);

  // Neutral Grays
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textLight = Color(0xFF94A3B8);
  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFF1F5F9);

  // Glassmorphism & Shadow Effects
  static const Color shadow = Color(0x0A000000);
  static const Color overlay = Color(0x33000000);
}
