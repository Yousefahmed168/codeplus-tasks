import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/colors.dart';

/// Single entry point for every in-app snackbar.
///
/// Screens used to build the same `SnackBar` (floating, 12.r corners, coloured
/// by outcome) inline in ~35 places, which drifted — the same success looked
/// different from screen to screen, and some messages were plain while others
/// floated. Route new snackbars through here instead.
class SnackBarHelper {
  SnackBarHelper._();

  /// Shows a message with the app's default snackbar styling.
  ///
  /// Pass [color] for outcomes that do not map onto error/success/warning, and
  /// [action] for an undo-style affordance.
  static void show(
    BuildContext context,
    String message, {
    Color? color,
    SnackBarAction? action,
    Duration? duration,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        action: action,
        duration: duration ?? const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      ),
    );
  }

  static void showError(
    BuildContext context,
    String message, {
    SnackBarAction? action,
    Duration? duration,
  }) => show(
    context,
    message,
    color: AppColors.error,
    action: action,
    duration: duration,
  );

  static void showSuccess(
    BuildContext context,
    String message, {
    SnackBarAction? action,
    Duration? duration,
  }) => show(
    context,
    message,
    color: AppColors.success,
    action: action,
    duration: duration,
  );

  static void showWarning(
    BuildContext context,
    String message, {
    SnackBarAction? action,
    Duration? duration,
  }) => show(
    context,
    message,
    color: AppColors.warning,
    action: action,
    duration: duration,
  );
}
