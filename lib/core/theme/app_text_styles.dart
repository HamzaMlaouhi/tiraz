import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// IBM Plex Sans Arabic covers both Arabic and Latin glyphs, so it's used
/// for both locales — matching the design canvas exactly.
abstract final class AppTextStyles {
  static TextStyle _base({
    required double size,
    required FontWeight weight,
    Color color = AppColors.textPrimary,
    double? letterSpacing,
    double? height,
  }) =>
      GoogleFonts.ibmPlexSansArabic(
        fontSize: size,
        fontWeight: weight,
        color: color,
        letterSpacing: letterSpacing,
        height: height,
      );

  static TextStyle wordmark = _base(size: 40, weight: FontWeight.w700, letterSpacing: -1);
  static TextStyle wordmarkSmall = _base(size: 26, weight: FontWeight.w700, letterSpacing: -0.5);
  static TextStyle wordmarkLatin = _base(size: 15, weight: FontWeight.w600, color: AppColors.textMuted, letterSpacing: 6);
  static TextStyle splashWordmark = _base(size: 62, weight: FontWeight.w700, letterSpacing: -1);

  static TextStyle h1 = _base(size: 22, weight: FontWeight.w700);
  static TextStyle h2 = _base(size: 20, weight: FontWeight.w700);
  static TextStyle h3 = _base(size: 17, weight: FontWeight.w700);
  static TextStyle sectionTitle = _base(size: 15, weight: FontWeight.w700);

  static TextStyle body = _base(size: 14, weight: FontWeight.w500, height: 1.7);
  static TextStyle bodyMuted = _base(size: 12.5, weight: FontWeight.w400, color: AppColors.textMuted, height: 1.7);
  static TextStyle caption = _base(size: 12, weight: FontWeight.w600, color: AppColors.textMuted);
  static TextStyle label = _base(size: 13, weight: FontWeight.w600);

  static TextStyle buttonPrimary = _base(size: 14.5, weight: FontWeight.w700, color: AppColors.card);
  static TextStyle buttonSecondary = _base(size: 13.5, weight: FontWeight.w600);
  static TextStyle chip = _base(size: 12.5, weight: FontWeight.w600);

  static TextStyle price = _base(size: 18, weight: FontWeight.w700, color: AppColors.teal);
  static TextStyle priceSmall = _base(size: 13, weight: FontWeight.w700, color: AppColors.teal);
}
