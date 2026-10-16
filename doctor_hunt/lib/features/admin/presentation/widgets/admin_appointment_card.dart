import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/models/appointment_model.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../i18n/strings.g.dart';
import 'appointment_status_pill.dart';
import '../../../../core/constants/my_icons.dart';

class AdminAppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;
  final VoidCallback? onCancel;
  final VoidCallback? onComplete;
  final VoidCallback? onViewDetails;

  const AdminAppointmentCard({
    super.key,
    required this.appointment,
    this.onCancel,
    this.onComplete,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('dd MMM yyyy').format(appointment.date);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.05),
            blurRadius: 10.r,
            offset: Offset(0, 3.h),
          ),
        ],
        border: Border.all(
          color: AppColors.divider.withValues(alpha: 0.6),
          width: 1.w,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onViewDetails,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //   Header (Patient & Doctor)
                Padding(
                  padding: EdgeInsets.all(14.r),
                  child: Row(
                    children: [
                      // Patient Avatar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Container(
                          width: 48.r,
                          height: 48.r,
                          color: AppColors.primary.withValues(alpha: 0.1),
                          child: Center(
                            child: Text(
                              appointment.patientName.isNotEmpty
                                  ? appointment.patientName[0].toUpperCase()
                                  : 'P',
                              style: context.bold18.primary,
                            ),
                          ),
                        ),
                      ),
                      12.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              appointment.patientName,
                              style: context.bold16.textPrimary,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            2.verticalSpace,
                            Text(
                              '${appointment.doctorName}${appointment.doctorSpecialty != null && appointment.doctorSpecialty!.isNotEmpty ? ' • ${appointment.doctorSpecialty}' : ''}',
                              style: context.regular12.textSecondary,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      AppointmentStatusPill(status: appointment.status),
                    ],
                  ),
                ),

                Divider(height: 1.h, color: AppColors.divider),

                //   Details Row (Date / Time / Fee)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 12.h,
                  ),
                  child: Row(
                    children: [
                      _detailItem(
                        context,
                        MyIcons.calendarTodayOutlined,
                        t.admin.appointments.date,
                        dateStr,
                      ),
                      _detailItem(
                        context,
                        MyIcons.accessTimeRounded,
                        t.admin.appointments.time,
                        appointment.timeSlot,
                      ),
                      _detailItem(
                        context,
                        MyIcons.attachMoneyRounded,
                        t.admin.appointments.fee,
                        t.common.amount(
                          amount: appointment.doctorFee.toStringAsFixed(2),
                        ),
                      ),
                    ],
                  ),
                ),

                //   Review Quote (Completed & Has Review)
                if (appointment.status == AppointmentStatus.completed &&
                    (appointment.reviewRating != null ||
                        (appointment.reviewComment != null &&
                            appointment.reviewComment!.isNotEmpty))) ...[
                  Padding(
                    padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 12.h),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: AppColors.divider.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Row(
                        children: [
                          if (appointment.reviewRating != null) ...[
                            Icon(
                              MyIcons.starRounded,
                              size: 16.r,
                              color: AppColors.star,
                            ),
                            4.horizontalSpace,
                            Text(
                              appointment.reviewRating!.toStringAsFixed(1),
                              style: context.semiBold12.textPrimary,
                            ),
                            6.horizontalSpace,
                            Text('•', style: context.regular12.textHint),
                            6.horizontalSpace,
                          ],
                          Expanded(
                            child: Text(
                              '"${appointment.reviewComment ?? ''}"',
                              style: context.regular12.copyWith(
                                fontStyle: FontStyle.italic,
                                color: AppColors.textSecondary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          //   Action Buttons
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 14.h),
            child: _buildActionButtons(context),
          ),
        ],
      ),
    );
  }

  Widget _detailItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, size: 16.r, color: AppColors.primary),
          ),
          8.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: context.regular11.copyWith(color: AppColors.textHint),
                ),
                Text(
                  value,
                  style: context.semiBold12.textPrimary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    if (appointment.status == AppointmentStatus.upcoming) {
      return Row(
        children: [
          // Cancel Appointment
          Expanded(
            child: OutlinedButton(
              onPressed: onCancel,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: BorderSide(color: AppColors.error, width: 1.2.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
              child: Text(
                t.admin.appointments.cancelAppointment,
                style: context.semiBold12.copyWith(color: AppColors.error),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          10.horizontalSpace,
          // Mark as Completed
          Expanded(
            child: ElevatedButton(
              onPressed: onComplete,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textOnPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 12.h),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    MyIcons.checkRounded,
                    size: 16.r,
                    color: AppColors.textOnPrimary,
                  ),
                  4.horizontalSpace,
                  Flexible(
                    child: Text(
                      t.admin.appointments.markCompleted,
                      style: context.semiBold12.copyWith(color: AppColors.textOnPrimary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    // Completed or Cancelled -> View Details button
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onViewDetails,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(color: AppColors.primary, width: 1.2.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          padding: EdgeInsets.symmetric(vertical: 12.h),
        ),
        child: Text(
          t.admin.appointments.viewDetails,
          style: context.semiBold14.primary,
        ),
      ),
    );
  }
}
