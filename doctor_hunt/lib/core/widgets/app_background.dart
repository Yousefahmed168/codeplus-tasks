import '../theme/colors.dart';
import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  const AppBackground({
    super.key,
    required this.child,
    this.backgroundColor = AppColors.background,
    this.resizeToAvoidBottomInset = true,
  });

  final Widget child;

  final Color backgroundColor;

  /// Forwarded to the internal [Scaffold].
  ///
  /// Shells that need to keep their own bottom navigation bar behind the
  /// keyboard pass `false` here; otherwise this wrapping Scaffold shrinks its
  /// body first and pushes the whole shell above the keyboard.
  final bool resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: Stack(
        children: [
          //  Top-left blob
          Positioned(top: -80, left: -120, child: GradientBlob()),

          //  Bottom-right blob
          Positioned(bottom: -80, right: -120, child: GradientBlob()),

          child,
        ],
      ),
    );
  }
}

class GradientBlob extends StatelessWidget {
  const GradientBlob({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 216,
      height: 210,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.info.withValues(alpha: 0.5),
            blurRadius: 150,
            spreadRadius: 5,
          ),
        ],
        shape: BoxShape.circle,
        gradient: AppColors.blobGradient,
      ),
    );
  }
}
