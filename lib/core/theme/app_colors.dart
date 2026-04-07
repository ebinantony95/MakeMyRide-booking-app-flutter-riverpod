import 'package:flutter/material.dart';

abstract final class AppColors {
  // ─── Primary Brand ───────────────────────────────────────────────────────
  static const Color primary = Color(0xFF37d058);
  static const Color primaryDark = Color(0xFF2AB548);
  static const Color primaryLight = Color(0xFFEAF9EE);
  static const Color primaryDisabled = Color(0xFFAADFB8);

  // ─── Neutrals ────────────────────────────────────────────────────────────
  static const Color background = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFF8F9FA);
  static const Color surfaceVariant = Color(0xFFF1F3F5);

  // ─── Text ────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color textHint = Color(0xFFADB5BD);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ─── Borders ─────────────────────────────────────────────────────────────
  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFF1F3F5);

  // ─── Semantic ────────────────────────────────────────────────────────────
  static const Color error = Color(0xFFFF4D4F);
  static const Color errorLight = Color(0xFFFFF1F0);
  static const Color warning = Color(0xFFFFA940);
  static const Color warningLight = Color(0xFFFFF7E6);
  static const Color success = Color(0xFF10D83A);
  static const Color successLight = Color(0xFFE6FCEB);
  static const Color info = Color(0xFF4096FF);
  static const Color infoLight = Color(0xFFE6F4FF);

  // ─── Map / Tracking ──────────────────────────────────────────────────────
  static const Color mapOverlay = Color(0x1A000000);
  static const Color routeColor = Color(0xFF10D83A);
  static const Color markerPrimary = Color(0xFF10D83A);
  static const Color markerDestination = Color(0xFFFF4D4F);

  // ─── Ride Status ─────────────────────────────────────────────────────────
  static const Color statusPending = Color(0xFFFFA940);
  static const Color statusActive = Color(0xFF10D83A);
  static const Color statusCompleted = Color(0xFF4096FF);
  static const Color statusCancelled = Color(0xFFFF4D4F);

  // ─── Shadows ─────────────────────────────────────────────────────────────
  static const Color shadowLight = Color(0x0D000000);
  static const Color shadowMedium = Color(0x1A000000);

  // ─── Gradients ───────────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF37D058), Color(0xFF2AB548)],
  );

  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFFFFF), Color(0xFFEAF9EE)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFFFFF), Color(0xFFF8F9FA)],
  );
}
