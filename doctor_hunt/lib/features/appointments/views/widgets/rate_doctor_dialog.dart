import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/my_icons.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/widgets/custom_text_form_field.dart';
import '../../../../core/widgets/main_button.dart';
import '../../../../i18n/strings.g.dart';

/// Rating dialog for a completed appointment: a 1-5 star selector plus an
/// optional comment.
class RateDoctorDialog extends StatefulWidget {
  const RateDoctorDialog({
    super.key,
    required this.doctorName,
    required this.onSubmit,
  });

  final String doctorName;
  final Future<void> Function(double rating, String comment) onSubmit;

  static Future<void> show(
    BuildContext context, {
    required String doctorName,
    required Future<void> Function(double rating, String comment) onSubmit,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          RateDoctorDialog(doctorName: doctorName, onSubmit: onSubmit),
    );
  }

  @override
  State<RateDoctorDialog> createState() => _RateDoctorDialogState();
}

class _RateDoctorDialogState extends State<RateDoctorDialog> {
  final TextEditingController _commentController = TextEditingController();
  double _rating = 0;
  bool _submitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_rating == 0 || _submitting) return;
    setState(() => _submitting = true);
    try {
      await widget.onSubmit(_rating, _commentController.text.trim());
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      backgroundColor: AppColors.surface,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                t.appointments.rateDialogTitle,
                style: context.bold18.textPrimary,
                textAlign: TextAlign.center,
              ),
            ),
            8.verticalSpace,
            Center(
              child: Text(
                widget.doctorName,
                style: context.regular14.textSecondary,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            16.verticalSpace,
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (index) {
                  final value = index + 1.0;
                  return GestureDetector(
                    onTap: () => setState(() => _rating = value),
                    child: Padding(
                      padding: EdgeInsets.only(right: 6.w),
                      child: Icon(
                        _rating >= value
                            ? MyIcons.starRounded
                            : MyIcons.starOutlineRounded,
                        size: 34.r,
                        color: AppColors.star,
                      ),
                    ),
                  );
                }),
              ),
            ),
            16.verticalSpace,
            Text(
              t.appointments.reviewCommentLabel,
              style: context.regular12.textSecondary,
            ),
            8.verticalSpace,
            CustomTextFormField(
              controller: _commentController,
              hintText: t.appointments.reviewCommentHint,
              maxLines: 3,
              borderEnabled: true,
            ),
            20.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: MainButton(
                    text: t.common.cancel,
                    minHeight: 48,
                    onPressed: () => Navigator.of(context).pop(),
                    bgColor: AppColors.surface,
                    textColor: AppColors.textPrimary,
                    borderColor: AppColors.border,
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: MainButton(
                    text: t.appointments.submit,
                    minHeight: 48,
                    onPressed: (_rating > 0 && !_submitting) ? _submit : null,
                    bgColor: _rating > 0
                        ? AppColors.primary
                        : AppColors.textHint,
                    textColor: AppColors.textOnPrimary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
