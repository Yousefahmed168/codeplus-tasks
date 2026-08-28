import '../theme/colors.dart';
import '../theme/style_atoms.dart';
import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  const MainButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.bgColor = AppColors.primaryLight,
    this.borderColor,
    this.minWidth = double.infinity,
    this.minHeight = 56,
    this.textColor = AppColors.background,
  });
  final String text;
  final Function()? onPressed;
  final Color bgColor;
  final Color? borderColor;
  final double minWidth;
  final double minHeight;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        padding: EdgeInsets.zero,
        minimumSize: Size(minWidth, minHeight),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        side: borderColor != null ? BorderSide(color: borderColor!) : null,
      ),
      onPressed: onPressed,
      child: Text(text, style: context.bold18.copyWith(color: textColor)),
    );
  }
}
