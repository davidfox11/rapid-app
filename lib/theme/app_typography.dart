import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTypography {
  // DM Serif Display — headings, display text, wordmark
  static TextStyle serifH({double fontSize = 28}) =>
      GoogleFonts.dmSerifDisplay(
        fontSize: fontSize,
        color: AppColors.textPrimary,
      );

  // Mono — data labels, scores, timestamps
  // JetBrains Mono stands in for Geist Mono (not yet in google_fonts catalog).
  static TextStyle dataLabel = GoogleFonts.jetBrainsMono(
    fontSize: 9,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.5,
    color: AppColors.textSecondary,
  );

  static TextStyle scoreDisplay({double fontSize = 24}) =>
      GoogleFonts.jetBrainsMono(
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      );

  // Bricolage Grotesque — body text, buttons, labels
  static TextStyle body({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    Color color = AppColors.textPrimary,
  }) =>
      GoogleFonts.bricolageGrotesque(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      );

  static TextStyle bodySmall =
      body(fontSize: 12, color: AppColors.textSecondary);

  static TextStyle bodyMedium = body(fontSize: 14);

  static TextStyle bodyLarge = body(fontSize: 16);

  static TextStyle bodySemiBold =
      body(fontSize: 14, fontWeight: FontWeight.w600);

  static TextStyle button = GoogleFonts.bricolageGrotesque(
    fontSize: 14,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.5,
    color: AppColors.textPrimary,
  );
}
