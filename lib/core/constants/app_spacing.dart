import 'package:flutter/material.dart';

abstract final class AppSpacing {
  static const double xxs = 4.0;
  static const double xs = 8.0;
  static const double sm = 12.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;

  // ─── Common edge insets ───────────────────────────────────────────────────
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets cardPadding = EdgeInsets.all(md);
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(horizontal: lg, vertical: 14);
  static const EdgeInsets inputPadding = EdgeInsets.symmetric(horizontal: md, vertical: sm);

  // ─── Gaps ─────────────────────────────────────────────────────────────────
  static const SizedBox gapXXS = SizedBox(height: xxs);
  static const SizedBox gapXS = SizedBox(height: xs);
  static const SizedBox gapSM = SizedBox(height: sm);
  static const SizedBox gapMD = SizedBox(height: md);
  static const SizedBox gapLG = SizedBox(height: lg);
  static const SizedBox gapXL = SizedBox(height: xl);

  static const SizedBox hGapXXS = SizedBox(width: xxs);
  static const SizedBox hGapXS = SizedBox(width: xs);
  static const SizedBox hGapSM = SizedBox(width: sm);
  static const SizedBox hGapMD = SizedBox(width: md);
  static const SizedBox hGapLG = SizedBox(width: lg);
}
