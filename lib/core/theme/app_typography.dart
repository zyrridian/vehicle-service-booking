import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  static TextTheme get textTheme {
    return GoogleFonts.plusJakartaSansTextTheme().copyWith(
      displayLarge: GoogleFonts.plusJakartaSans(
          fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: -0.5),
      displayMedium: GoogleFonts.plusJakartaSans(
          fontSize: 22, fontWeight: FontWeight.w800, letterSpacing: -0.5),
      displaySmall: GoogleFonts.plusJakartaSans(
          fontSize: 20, fontWeight: FontWeight.bold),
      headlineMedium: GoogleFonts.plusJakartaSans(
          fontSize: 19, fontWeight: FontWeight.bold),
      titleLarge: GoogleFonts.plusJakartaSans(
          fontSize: 16, fontWeight: FontWeight.bold),
      titleMedium: GoogleFonts.plusJakartaSans(
          fontSize: 14, fontWeight: FontWeight.bold),
      titleSmall: GoogleFonts.plusJakartaSans(
          fontSize: 13, fontWeight: FontWeight.w600),
      bodyLarge: GoogleFonts.plusJakartaSans(
          fontSize: 14, fontWeight: FontWeight.normal),
      bodyMedium: GoogleFonts.plusJakartaSans(
          fontSize: 13, fontWeight: FontWeight.normal),
      bodySmall: GoogleFonts.plusJakartaSans(
          fontSize: 12, fontWeight: FontWeight.normal),
      labelLarge: GoogleFonts.plusJakartaSans(
          fontSize: 13, fontWeight: FontWeight.w600),
      labelSmall: GoogleFonts.plusJakartaSans(
          fontSize: 11, fontWeight: FontWeight.w600),
    );
  }
}
