import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/widgets/main_button.dart';
import '../../../../i18n/strings.g.dart';

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
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Circle with thumb up icon
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                color: Color(0xFFE8F8F2),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.thumb_up_rounded,
                  color: AppColors.success,
                  size: 64,
                ),
              ),
            ),
            const Gap(32),
            // Title
            Text(
              t.appointment.successTitle,
              style: context.bold.copyWith(fontSize: 28, color: AppColors.textPrimary),
              textAlign: TextAlign.center,
            ),
            const Gap(12),
            // Subtitle
            Text(
              t.appointment.successSubtitle,
              style: context.regular.copyWith(fontSize: 16, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const Gap(24),
            // Message
            Text(
              t.appointment.successMessage(
                doctorName: doctorName,
                date: date,
                time: time,
              ),
              style: context.regular.copyWith(fontSize: 12, color: AppColors.textHint, height: 1.5),
              textAlign: TextAlign.center,
            ),
            const Gap(32),
            // Done Button
            MainButton(
              text: t.appointment.doneBtn,
              onPressed: onDone,
            ),
            const Gap(20),
            // Edit Button
            GestureDetector(
              onTap: onEdit,
              child: Text(
                t.appointment.editBtn,
                style: context.regular.copyWith(fontSize: 14, color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
