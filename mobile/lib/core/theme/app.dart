import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:periodt/core/theme/base/rounding.dart';
import 'package:periodt/core/theme/base/text.dart';

class CyclePalette {
  final Color primary;
  final Color secondary;
  final Color light;

  const CyclePalette({
    required this.primary,
    required this.secondary,
    required this.light,
  });
}

class PeriodtTheme {
  static const rounding = PeriodtRounding();
  static const text = PeriodtText();

  static const period = CyclePalette(
    primary: Color(0xFFF07D8C),
    secondary: Color(0xFFFAD2DA),
    light: Color(0xFFFBF5F3),
  );

  static const follicular = CyclePalette(
    primary: Color(0xFFFFF57C),
    secondary: Color(0xFFFAF5B9),
    light: Color(0xFFFFF7E8),
  );

  static const ovulation = CyclePalette(
    primary: Color(0xFFB7E28E),
    secondary: Color(0xFFD8EEC4),
    light: Color(0xFFF4F8EC),
  );

  static const luteal = CyclePalette(
    primary: Color(0xFF92DCE9),
    secondary: Color(0xFFC5EBF0),
    light: Color(0xFFF3F5F5),
  );
}

final theme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: PeriodtTheme.period.primary)
      .copyWith(
        primary: PeriodtTheme.period.primary,
        secondary: PeriodtTheme.period.secondary,
        tertiary: PeriodtTheme.period.light,

        primaryContainer: PeriodtTheme.period.primary,
        secondaryContainer: PeriodtTheme.period.secondary,
        tertiaryContainer: PeriodtTheme.period.light,

        surface: Colors.white,
        background: Colors.white,

        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: Colors.black,
      ),

  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      // Force Android to use the Cupertino (slide) transition
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      // Keep iOS using its native Cupertino transition
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  ),

  primaryColor: PeriodtTheme.period.primary,

  splashColor: PeriodtTheme.period.primary.withOpacity(0.1),

  fontFamily: GoogleFonts.outfit().fontFamily,
  textTheme: GoogleFonts.outfitTextTheme(),
);
