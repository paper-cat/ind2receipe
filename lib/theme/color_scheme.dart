import 'package:flutter/material.dart';

class AppColorScheme {
  // Seed Color - 밝은 치즈 옐로우
  static const Color seedColor = Color(0xFFFFC107); // Amber 500

  // Light/Dark ColorScheme
  static final ColorScheme light = ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: Brightness.light,
  );

  static final ColorScheme dark = ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: Brightness.dark,
  );

  // 시맨틱 색상
  static const Color successLight = Color(0xFF2E7D32); // Green 800
  static const Color successDark = Color(0xFF66BB6A);  // Green 400

  static const Color warningLight = Color(0xFFF57C00); // Orange 700
  static const Color warningDark = Color(0xFFFFB74D);  // Orange 300

  static const Color errorLight = Color(0xFFC62828);   // Red 800
  static const Color errorDark = Color(0xFFEF5350);    // Red 400

  // 헬퍼 메서드
  static Color success(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? successLight
        : successDark;
  }

  static Color warning(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? warningLight
        : warningDark;
  }

  static Color error(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? errorLight
        : errorDark;
  }
}
