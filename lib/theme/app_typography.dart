import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  static TextTheme createTextTheme(ColorScheme colorScheme) {
    return TextTheme(
      // 큰 제목 (예: 상세 화면 제목)
      displayLarge: GoogleFonts.notoSansKr(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        height: 1.2,
        color: colorScheme.onSurface,
      ),
      displayMedium: GoogleFonts.notoSansKr(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
        height: 1.3,
        color: colorScheme.onSurface,
      ),

      // 중간 제목 (예: AppBar, 카드 제목)
      titleLarge: GoogleFonts.notoSansKr(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
        height: 1.4,
        color: colorScheme.onSurface,
      ),
      titleMedium: GoogleFonts.notoSansKr(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        height: 1.4,
        color: colorScheme.onSurface,
      ),
      titleSmall: GoogleFonts.notoSansKr(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.1,
        height: 1.4,
        color: colorScheme.onSurface,
      ),

      // 본문 텍스트
      bodyLarge: GoogleFonts.notoSansKr(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.6,
        color: colorScheme.onSurface,
      ),
      bodyMedium: GoogleFonts.notoSansKr(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.6,
        color: colorScheme.onSurfaceVariant,
      ),
      bodySmall: GoogleFonts.notoSansKr(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.5,
        color: colorScheme.onSurfaceVariant,
      ),

      // 레이블 (예: 버튼, 칩, 작은 텍스트)
      labelLarge: GoogleFonts.notoSansKr(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.4,
        color: colorScheme.onSurface,
      ),
      labelMedium: GoogleFonts.notoSansKr(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.4,
        color: colorScheme.onSurfaceVariant,
      ),
      labelSmall: GoogleFonts.notoSansKr(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.3,
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }
}
