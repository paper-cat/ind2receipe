import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idg2recipes/theme/color_scheme.dart';
import 'package:idg2recipes/theme/app_theme.dart';
import 'package:idg2recipes/theme/app_typography.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: AppColorScheme.light,
    textTheme: AppTypography.createTextTheme(AppColorScheme.light),

    cardTheme: CardThemeData(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppBorders.cardRadius),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.cardHorizontalMargin,
        vertical: AppSpacing.cardVerticalMargin,
      ),
    ),

    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColorScheme.light.primary,
      foregroundColor: AppColorScheme.light.onPrimary,
    ),

    appBarTheme: AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 2,
      backgroundColor: AppColorScheme.light.surface,
      foregroundColor: AppColorScheme.light.onSurface,
      titleTextStyle: GoogleFonts.notoSansKr(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
        color: AppColorScheme.light.onSurface,
      ),
      iconTheme: IconThemeData(
        color: AppColorScheme.light.onSurfaceVariant,
        size: 24,
      ),
    ),

    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      filled: false,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: AppColorScheme.dark,
    textTheme: AppTypography.createTextTheme(AppColorScheme.dark),

    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppBorders.cardRadius),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.cardHorizontalMargin,
        vertical: AppSpacing.cardVerticalMargin,
      ),
    ),

    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColorScheme.dark.primary,
      foregroundColor: AppColorScheme.dark.onPrimary,
    ),

    appBarTheme: AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 2,
      backgroundColor: AppColorScheme.dark.surface,
      foregroundColor: AppColorScheme.dark.onSurface,
      titleTextStyle: GoogleFonts.notoSansKr(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
        color: AppColorScheme.dark.onSurface,
      ),
      iconTheme: IconThemeData(
        color: AppColorScheme.dark.onSurfaceVariant,
        size: 24,
      ),
    ),

    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      filled: false,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
  );
}
