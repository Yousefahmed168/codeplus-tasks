import 'package:flutter/material.dart';

/// Doctor Hunt — Design System Colors
/// Extracted from the official Figma design.
class AppColors {
  AppColors._();

  //  Brand / Primary

  /// Main CTA green — buttons, selected states, onboarding arc
  static const Color primary = Color(0xFF0EBE7E);

  /// Lighter tint for hover / pressed states
  static const Color primaryLight = Color(0xFF38D49A);

  /// Darker shade for pressed states / shadows
  static const Color primaryDark = Color(0xFF0A9664);

  //  Accent / Glow

  /// Teal neon — active dots, decorative blobs center
  static const Color accent = Color(0xFF19FFCC);

  /// Blob glow / box-shadow color (teal tint matching accent)
  static const Color blobGlow = Color(0xFF0EBE7E);

  //  Background

  /// Default screen background
  static const Color background = Color(0xFFFFFFFF);

  /// Dark mode scaffold background
  static const Color backgroundDark = Color(0xFF0D1B2A);

  /// Card / input field surface
  static const Color surface = Color(0xFFFFFFFF);

  /// Dark mode card / surface background
  static const Color surfaceDark = Color(0xFF162537);

  /// Light gray surface — icon containers, shimmer base
  static const Color surfaceVariant = Color(0xFFF5F5F5);

  /// Subtle off-white used behind list rows
  static const Color surfaceDim = Color(0xFFF9F9F9);

  //  Secondary

  /// Secondary brand color (used in ColorScheme)
  static const Color secondary = Color(0xFF0A9664);

  //  Text

  /// Headings and primary content
  static const Color textPrimary = Color(0xFF1A1A1A);

  /// Body text, labels
  static const Color textBody = Color(0xFF2D2D2D);

  /// Placeholder, captions, secondary info
  static const Color textSecondary = Color(0xFF888888);

  /// Hint text inside inputs
  static const Color textHint = Color(0xFFB0B0B0);

  /// Light text — used on dark backgrounds
  static const Color textLight = Color(0xFFE0E0E0);

  /// Text on colored (green) backgrounds
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  //  Border & Divider

  /// Default card / input border
  static const Color border = Color(0xFFE8E8E8);

  /// Divider lines between list items
  static const Color divider = Color(0xFFF0F0F0);

  /// Selected / focused border — same as primary
  static const Color borderSelected = primary;

  //  Status

  static const Color success = Color(0xFF0EBE7E);
  static const Color warning = Color(0xFFFDAA5D);
  static const Color error = Color(0xFFE74C3C);
  static const Color info = Color(0xFF74B9FF);

  //  Star / Rating

  static const Color star = Color(0xFFFFC107);

  //  Gradients

  /// Hero / primary gradient (top-left → bottom-right green)
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );

  /// Decorative blob radial gradient
  static const RadialGradient blobGradient = RadialGradient(
    colors: [accent, Color(0x22C6E6D9)],
  );

  /// Subtle background gradient used on some screens
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFEFFBF7), Color(0xFFFFFFFF)],
  );
}
