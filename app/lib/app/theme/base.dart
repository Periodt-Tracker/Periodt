import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PeriodtTheme {
  PeriodtTheme._();

  // ─────────────────────────────────────────────
  // Colors
  // ─────────────────────────────────────────────

  static const Color periodPrimaryLight = Color(0xFFFF9E9E);
  static const Color periodPrimary = Color(0xFFFF8888);
  static const Color periodPrimaryDark = Color(0xFFEE7474);

  static const Color follicularPrimaryLight = Color(0xFF9EFF9E);
  static const Color follicularPrimary = Color(0xFF88FF88);
  static const Color follicularPrimaryDark = Color(0xFF74EE74);

  static const Color ovulationPrimaryLight = Color(0xFF9E9EFF);
  static const Color ovulationPrimary = Color(0xFF8888FF);
  static const Color ovulationPrimaryDark = Color(0xFF7474EE);

  static const Color lutealPrimaryLight = Color(0xFFFF9EFF);
  static const Color lutealPrimary = Color(0xFFFF88FF);
  static const Color lutealPrimaryDark = Color(0xFFEE74EE);

  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF4F7FF);

  static const Color text = Color(0xFF444444);
  static const Color textSecondary = Color(0xFF777777);

  static const Color blueAccent = Color(0xFF5A9BC8);

  static const Color error = Color(0xFFE57373);

  // ─────────────────────────────────────────────
  // Color Scheme
  // ─────────────────────────────────────────────

  static const ColorScheme colorScheme = ColorScheme(
    brightness: Brightness.light,

    primary: periodPrimary,
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

    surfaceContainerHighest: surface,

    error: error,
    onError: Colors.white,

    outline: Color(0xFFFFCCCC),
    outlineVariant: Color(0xFFFFE0E0),

    shadow: Colors.black12,
    scrim: Colors.black54,
  );

  static final ColorScheme periodColorScheme = colorScheme.copyWith(
    primary: periodPrimary,
  );

  static final ColorScheme follicularColorScheme = colorScheme.copyWith(
    primary: follicularPrimary,
  );

  static final ColorScheme ovulationColorScheme = colorScheme.copyWith(
    primary: ovulationPrimary,
  );

  static final ColorScheme lutealColorScheme = colorScheme.copyWith(
    primary: lutealPrimary,
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
          backgroundColor: periodPrimary,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: Colors.black26,

          minimumSize: const Size(double.infinity, 64),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(36),
          ),

          textStyle: GoogleFonts.outfit(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ─────────────────────────────────────────
      // Filled Buttons
      // ─────────────────────────────────────────
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: periodPrimary,
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
          foregroundColor: periodPrimaryDark,
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
        fillColor: surface,

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
            return periodPrimary;
          }
          return surface;
        }),

        checkColor: WidgetStateProperty.all(Colors.white),
      ),

      // ─────────────────────────────────────────
      // Radio
      // ─────────────────────────────────────────
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return periodPrimary;
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
            return periodPrimary;
          }
          return const Color(0xFFE8DCDC);
        }),

        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),

      // ─────────────────────────────────────────
      // Progress Indicators
      // ─────────────────────────────────────────
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: periodPrimary,
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
        backgroundColor: periodPrimary,
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
            return const IconThemeData(color: periodPrimaryDark);
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
