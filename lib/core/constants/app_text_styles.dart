import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Standard Typography System using Google Fonts Poppins.
/// Does NOT hardcode light-mode colors so styles adapt dynamically to active ThemeData.
class AppTextStyles {
  AppTextStyles._();

  static TextStyle get headingLarge => GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get headingMedium => GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get headingSmall => GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get bodyLarge => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.normal,
      );

  static TextStyle get bodyMedium => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.normal,
      );

  static TextStyle get bodySmall => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.normal,
      );

  static TextStyle get buttonText => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      );

  static TextStyle get caption => GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w500,
      );
}
