import 'package:doctor_hunt/core/theme/colors.dart';
import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  const AppBackground({
    super.key,
    required this.child,
    this.backgroundColor = AppColors.background,
  });

  final Widget child;

  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
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
