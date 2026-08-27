import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PeriodtTheme {
  PeriodtTheme._();

  // ─────────────────────────────────────────────
  // Colors
  // ─────────────────────────────────────────────

  static const Color primary = Color(0xFFFF8888);
  static const Color primaryDark = Color(0xFFFF7070);

  static const Color background = Color(0xFFFFF8F8);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfacePink = Color(0xFFFFF0F0);

  static const Color text = Color(0xFF444444);
  static const Color textSecondary = Color(0xFF777777);

  static const Color blueAccent = Color(0xFF5A9BC8);

  static const Color error = Color(0xFFE57373);

  // ─────────────────────────────────────────────
  // Color Scheme
  // ─────────────────────────────────────────────

  static const ColorScheme colorScheme = ColorScheme(
    brightness: Brightness.light,

    primary: primary,
    onPrimary: Colors.white,

    primaryContainer: Color(0xFFFFDADA),
    onPrimaryContainer: Color(0xFF6B3030),

    secondary: blueAccent,
    onSecondary: Colors.white,

    secondaryContainer: Color(0xFFDDEEFF),
    onSecondaryContainer: Color(0xFF234A65),

    tertiary: Color(0xFFFFB6B6),
    onTertiary: text,

    surface: surface,
    onSurface: text,

    surfaceContainerHighest: surfacePink,

    error: error,
    onError: Colors.white,

    outline: Color(0xFFFFCCCC),
    outlineVariant: Color(0xFFFFE0E0),

    shadow: Colors.black12,
    scrim: Colors.black54,
  );

  // ─────────────────────────────────────────────
  // Theme
  // ─────────────────────────────────────────────

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      brightness: Brightness.light,
    );

    return base.copyWith(
      scaffoldBackgroundColor: background,

      // ─────────────────────────────────────────
      // Typography
      // ─────────────────────────────────────────
      textTheme: GoogleFonts.outfitTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.outfit(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: text,
        ),
        displayMedium: GoogleFonts.outfit(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: text,
        ),
        headlineLarge: GoogleFonts.outfit(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: text,
        ),
        headlineMedium: GoogleFonts.outfit(
          fontSize: 21,
          fontWeight: FontWeight.w700,
          color: text,
        ),
        titleLarge: GoogleFonts.outfit(
          fontSize: 19,
          fontWeight: FontWeight.w700,
          color: text,
        ),
        titleMedium: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: text,
        ),
        bodyLarge: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: text,
        ),
        bodyMedium: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textSecondary,
        ),
        bodySmall: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textSecondary,
        ),
        labelLarge: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: text,
        ),
      ),

      // ─────────────────────────────────────────
      // App Bar
      // ─────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: text,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: text,
        ),
      ),

      // ─────────────────────────────────────────
      // Elevated Buttons
      // ─────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: Colors.black26,

          minimumSize: const Size(double.infinity, 54),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),

          textStyle: GoogleFonts.outfit(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ─────────────────────────────────────────
      // Filled Buttons
      // ─────────────────────────────────────────
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 54),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),

          textStyle: GoogleFonts.outfit(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ─────────────────────────────────────────
      // Text Buttons
      // ─────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryDark,
          textStyle: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ─────────────────────────────────────────
      // Input Fields
      // ─────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfacePink,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),

        hintStyle: GoogleFonts.outfit(color: Color(0xFFB8A8A8), fontSize: 13),

        labelStyle: GoogleFonts.outfit(color: textSecondary),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: error),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: error, width: 1.5),
        ),
      ),

      // ─────────────────────────────────────────
      // Cards
      // ─────────────────────────────────────────
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),

        surfaceTintColor: Colors.transparent,
      ),

      // ─────────────────────────────────────────
      // Checkboxes
      // ─────────────────────────────────────────
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),

        side: const BorderSide(color: Color(0xFFFFBABA), width: 1.5),

        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primary;
          }
          return surfacePink;
        }),

        checkColor: WidgetStateProperty.all(Colors.white),
      ),

      // ─────────────────────────────────────────
      // Radio
      // ─────────────────────────────────────────
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primary;
          }
          return textSecondary;
        }),
      ),

      // ─────────────────────────────────────────
      // Switch
      // ─────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return Colors.white;
        }),

        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primary;
          }
          return const Color(0xFFE8DCDC);
        }),

        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),

      // ─────────────────────────────────────────
      // Progress Indicators
      // ─────────────────────────────────────────
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primary,
        linearTrackColor: Color(0xFFFFE8E8),
        linearMinHeight: 12,
      ),

      // ─────────────────────────────────────────
      // Divider
      // ─────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: Color(0xFFFFE2E2),
        thickness: 1,
      ),

      // ─────────────────────────────────────────
      // Floating Action Button
      // ─────────────────────────────────────────
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 3,
      ),

      // ─────────────────────────────────────────
      // Navigation Bar
      // ─────────────────────────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFFFDCDC),

        elevation: 0,

        labelTextStyle: WidgetStateProperty.all(
          GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.w600),
        ),

        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: primaryDark);
          }

          return const IconThemeData(color: textSecondary);
        }),
      ),

      // ─────────────────────────────────────────
      // Snackbars
      // ─────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: text,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentTextStyle: GoogleFonts.outfit(color: Colors.white, fontSize: 14),
      ),
    );
  }
}
