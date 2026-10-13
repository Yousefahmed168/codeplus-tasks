import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/colors.dart';
import '../theme/style_atoms.dart';
import '../../i18n/strings.g.dart';

/// Wraps root screens with a "Tap back again to exit" behavior.
/// Uses Flutter Material 3 [PopScope].
class DoubleBackToExit extends StatefulWidget {
  final Widget child;
  /// Optional interceptor callback. Return `true` if back press was consumed
  /// (for example: closing a drawer or switching to the first tab).
  final bool Function()? onPopIntercept;
  final Duration timeout;
  final String? exitMessage;

  const DoubleBackToExit({
    super.key,
    required this.child,
    this.onPopIntercept,
    this.timeout = const Duration(seconds: 2),
    this.exitMessage,
  });

  @override
  State<DoubleBackToExit> createState() => _DoubleBackToExitState();
}

class _DoubleBackToExitState extends State<DoubleBackToExit> {
  DateTime? _lastBackPressTime;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        // Custom interceptor (e.g. close drawer or switch to initial tab)
        if (widget.onPopIntercept != null && widget.onPopIntercept!()) {
          return;
        }

        final now = DateTime.now();
        if (_lastBackPressTime == null ||
            now.difference(_lastBackPressTime!) > widget.timeout) {
          _lastBackPressTime = now;
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.exitMessage ?? t.common.tapBackAgainToExit,
                style: context.medium14.copyWith(color: AppColors.surface),
              ),
              backgroundColor: AppColors.textPrimary,
              duration: widget.timeout,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
              margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).clearSnackBars();
          SystemNavigator.pop();
        }
      },
      child: widget.child,
    );
  }
}
