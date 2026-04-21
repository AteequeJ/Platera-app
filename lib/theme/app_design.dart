import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Brand Colors
  static const Color primary = Color(
    0xFF1A1C1E,
  ); // Deep Black/Grey for text and primary buttons
  static const Color accent = Color.fromARGB(
    255,
    178,
    217,
    110,
  ); // signature Electric Sage for small accents
  static const Color surfaceGreen = Color(
    0xFFE8F5E9,
  ); // Light Green for sections/accordions
  static const Color surfaceGrey = Color(
    0xFFF5F5F5,
  ); // Ultra Light Grey for search bar/chips

  static Color background(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? const Color(0xFF0E1116)
      : const Color(0xFFFFFFFF);

  static Color surface(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? const Color(0xFF1A1F26)
      : const Color(0xFFFFFFFF);

  static Color textBody(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? const Color(0xFFB0B3B8)
      : const Color(0xFF4A4A4A);

  static Color textHeading(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? const Color(0xFFF0FDF4)
      : const Color(0xFF1A1C1E);

  static LinearGradient accentGradient = const LinearGradient(
    colors: [Color(0xFFD1FF82), Color(0xFF3BCEAC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppDesign {
  static double borderRadiusLarge = 32.0;
  static double borderRadiusMedium = 20.0;
  static double borderRadiusSmall = 12.0;
  static double padding = 24.0;

  static TextStyle headingLarge(BuildContext context) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        height: 1.2,
        color: AppColors.textHeading(context),
        letterSpacing: -0.5,
      );

  static TextStyle headingMedium(BuildContext context) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.textHeading(context),
        letterSpacing: -0.2,
      );

  static TextStyle bodyMedium(BuildContext context) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.textBody(context),
      );

  static TextStyle bodySmall(BuildContext context) =>
      GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textBody(context).withOpacity(0.6),
      );

  static BoxDecoration cardDecoration(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(borderRadiusLarge),
      boxShadow: isDark
          ? []
          : [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
    );
  }

  static BoxDecoration glassDecoration(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return BoxDecoration(
      color: isDark
          ? Colors.white.withOpacity(0.05)
          : Colors.black.withOpacity(0.02),
      borderRadius: BorderRadius.circular(borderRadiusMedium),
      border: Border.all(
        color: isDark
            ? Colors.white.withOpacity(0.1)
            : Colors.black.withOpacity(0.05),
      ),
    );
  }
}
