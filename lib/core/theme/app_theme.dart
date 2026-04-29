import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color brandPurple = Color(0xFF8B5CF6);
  static const Color brandLightPurple = Color(0xFFA78BFA);
  static const Color brandPalePurple = Color(0xFFE0E7FF);
  static const Color brandOrange = Color(0xFFFFB27D);
  static const Color brandYellow = Color(0xFFFFD166);
  static const Color brandDark = Color(0xFF1A1A2E);
  static const Color brandGray = Color(0xFFF1F5F9);
  static const Color brandBlue50 = Color(0xFFEFF6FF);
  static const Color brandText = Color(0xFF334155);
  static const Color brandTextLight = Color(0xFF64748B);
  static const Color bgGray = Color(0xFFF5F7FA);
  static const Color bgBluePattern = Color(0xFFE2EBF5);
}

final ThemeData appTheme = ThemeData(
  primaryColor: AppColors.brandPurple,
  scaffoldBackgroundColor: AppColors.bgGray,
  textTheme: GoogleFonts.nunitoTextTheme().apply(
    bodyColor: AppColors.brandText,
    displayColor: AppColors.brandDark,
  ),
  fontFamily: GoogleFonts.nunito().fontFamily,
);
