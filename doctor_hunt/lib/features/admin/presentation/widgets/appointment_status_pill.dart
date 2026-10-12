import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/models/appointment_model.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../i18n/strings.g.dart';

class AppointmentStatusPill extends StatelessWidget {
  const AppointmentStatusPill({super.key, required this.status});

  final AppointmentStatus status;

  @override
  Widget build(BuildContext context) {
    final Color pillBg;
    final Color pillColor;
    final String label;

    switch (status) {
      case AppointmentStatus.upcoming:
        pillBg = AppColors.mintTileBackground;
        pillColor = AppColors.emeraldGreen;
        label = t.admin.appointments.upcoming;
        break;
      case AppointmentStatus.completed:
        pillBg = AppColors.primary.withValues(alpha: 0.12);
        pillColor = AppColors.primary;
        label = t.admin.appointments.completed;
        break;
      case AppointmentStatus.cancelled:
        pillBg = AppColors.destructiveRedLight;
        pillColor = AppColors.destructiveRed;
        label = t.admin.appointments.cancelled;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: pillBg,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.w,
            height: 6.h,
            decoration: BoxDecoration(color: pillColor, shape: BoxShape.circle),
          ),
          6.w.horizontalSpace,
          Text(label, style: context.semiBold12.copyWith(color: pillColor)),
        ],
      ),
    );
  }
}
