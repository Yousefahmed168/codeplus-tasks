import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/widgets/main_button.dart';
import '../../../../i18n/strings.g.dart';
import '../../../../core/constants/my_icons.dart';

class AppointmentSuccessDialog extends StatelessWidget {
  final String doctorName;
  final String date;
  final String time;
  final VoidCallback onDone;
  final VoidCallback onEdit;

  const AppointmentSuccessDialog({
    super.key,
    required this.doctorName,
    required this.date,
    required this.time,
    required this.onDone,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
      ),
      backgroundColor: AppColors.surface,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Circle with thumb up icon
            Container(
              width: 120.r,
              height: 120.r,
              decoration: BoxDecoration(
                color: AppColors.background,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  MyIcons.thumbUpRounded,
                  color: AppColors.success,
                  size: 64.r,
                ),
              ),
            ),
            32.verticalSpace,
            // Title
            Text(
              t.appointment.successTitle,
              style: context.bold28.textPrimary,
              textAlign: TextAlign.center,
            ),
            12.verticalSpace,
            // Subtitle
            Text(
              t.appointment.successSubtitle,
              style: context.regular16.textSecondary,
              textAlign: TextAlign.center,
            ),
            24.verticalSpace,
            // Message
            Text(
              t.appointment.successMessage(
                doctorName: doctorName,
                date: date,
                time: time,
              ),
              style: context.regular12.textHint,
              textAlign: TextAlign.center,
            ),
            32.verticalSpace,
            // Done Button
            MainButton(
              text: t.appointment.doneBtn,
              onPressed: onDone,
            ),
            20.verticalSpace,
            // Edit Button
            GestureDetector(
              onTap: onEdit,
              child: Text(
                t.appointment.editBtn,
                style: context.regular14.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
