import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';

class AppointmentEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const AppointmentEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88.r,
              height: 88.r,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 42.r, color: AppColors.primary),
            ),
            20.verticalSpace,
            Text(
              title,
              style: context.bold18.textPrimary,
              textAlign: TextAlign.center,
            ),
            8.verticalSpace,
            Text(
              subtitle,
              style: context.regular14.textSecondary.copyWith(height: 1.5),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
