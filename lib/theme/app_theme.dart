import 'package:flutter/material.dart';

class AppTextStyles {
  // 카드용
  static TextStyle cardTitle(BuildContext context) =>
      Theme.of(context).textTheme.titleMedium!;

  static TextStyle cardDescription(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!;

  static TextStyle cardMetadata(BuildContext context) =>
      Theme.of(context).textTheme.labelMedium!;

  // 상세 화면용
  static TextStyle detailTitle(BuildContext context) =>
      Theme.of(context).textTheme.displayMedium!;

  static TextStyle stepText(BuildContext context) =>
      Theme.of(context).textTheme.bodyLarge!;

  // 빈 화면용
  static TextStyle emptyTitle(BuildContext context) =>
      Theme.of(context).textTheme.titleLarge!;

  static TextStyle emptySubtitle(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium!;
}

class AppSpacing {
  // 8pt Grid System
  static const double unit = 8.0;

  // 기본 간격
  static const double xs = 4.0;   // unit * 0.5
  static const double sm = 8.0;   // unit
  static const double md = 16.0;  // unit * 2
  static const double lg = 24.0;  // unit * 3
  static const double xl = 32.0;  // unit * 4
  static const double xxl = 48.0; // unit * 6

  // 컴포넌트별 간격 (기존 호환 + 정규화)
  static const double cardHorizontalMargin = md;     // 16 (유지)
  static const double cardVerticalMargin = sm;       // 8 (유지)
  static const double cardInternalPadding = lg;      // 24 (20→24)
  static const double listPadding = md;              // 16 (12→16)
  static const double screenPadding = lg;            // 24 (20→24)

  // 기존 호환성 유지
  static const double small = sm;
  static const double medium = md;
  static const double large = lg;
  static const double xLarge = xl;
}

class AppBorders {
  static const cardRadius = 16.0;
}
