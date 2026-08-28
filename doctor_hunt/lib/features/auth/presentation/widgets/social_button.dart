import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SocialButton extends StatelessWidget {
  const SocialButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final Widget icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.textHint.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const Gap(8),
            Text(label, style: context.regular14),
          ],
        ),
      ),
    );
  }
}
