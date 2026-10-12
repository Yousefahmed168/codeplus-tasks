import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../../../../core/models/appointment_model.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../i18n/strings.g.dart';

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
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(
          color: AppColors.divider.withValues(alpha: 0.6),
          width: 1,
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
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      // Patient Avatar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: 48,
                          height: 48,
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
                      const Gap(12),
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
                            const Gap(2),
                            Text(
                              '${appointment.doctorName}${appointment.doctorSpecialty != null && appointment.doctorSpecialty!.isNotEmpty ? ' • ${appointment.doctorSpecialty}' : ''}',
                              style: context.regular12.textSecondary,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      _buildStatusChip(context, appointment.status),
                    ],
                  ),
                ),

                const Divider(height: 1, color: AppColors.divider),

                //   Details Row (Date / Time / Fee)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      _detailItem(
                        context,
                        Icons.calendar_today_outlined,
                        t.admin.appointments.date,
                        dateStr,
                      ),
                      _detailItem(
                        context,
                        Icons.access_time_rounded,
                        t.admin.appointments.time,
                        appointment.timeSlot,
                      ),
                      _detailItem(
                        context,
                        Icons.attach_money_rounded,
                        t.admin.appointments.fee,
                        '\$${appointment.doctorFee.toStringAsFixed(2)}',
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
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.divider.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Row(
                        children: [
                          if (appointment.reviewRating != null) ...[
                            const Icon(
                              Icons.star_rounded,
                              size: 16,
                              color: Colors.amber,
                            ),
                            const Gap(4),
                            Text(
                              appointment.reviewRating!.toStringAsFixed(1),
                              style: context.semiBold12.textPrimary,
                            ),
                            const Gap(6),
                            Text('•', style: context.regular12.textHint),
                            const Gap(6),
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
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: _buildActionButtons(context),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, AppointmentStatus status) {
    Color chipBg;
    Color chipColor;
    String label;

    switch (status) {
      case AppointmentStatus.upcoming:
        chipBg = AppColors.success.withValues(alpha: 0.12);
        chipColor = AppColors.success;
        label = t.admin.appointments.upcoming;
        break;
      case AppointmentStatus.completed:
        chipBg = AppColors.primary.withValues(alpha: 0.12);
        chipColor = AppColors.primary;
        label = t.admin.appointments.completed;
        break;
      case AppointmentStatus.cancelled:
        chipBg = AppColors.error.withValues(alpha: 0.12);
        chipColor = AppColors.error;
        label = t.admin.appointments.cancelled;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: chipBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: chipColor, shape: BoxShape.circle),
          ),
          const Gap(6),
          Text(label, style: context.semiBold12.copyWith(color: chipColor)),
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
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: AppColors.primary),
          ),
          const Gap(8),
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
                side: const BorderSide(color: AppColors.error, width: 1.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                t.admin.appointments.cancelAppointment,
                style: context.semiBold12.copyWith(color: AppColors.error),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const Gap(10),
          // Mark as Completed
          Expanded(
            child: ElevatedButton(
              onPressed: onComplete,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                  const Gap(4),
                  Flexible(
                    child: Text(
                      t.admin.appointments.markCompleted,
                      style: context.semiBold12.copyWith(color: Colors.white),
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
          side: const BorderSide(color: AppColors.primary, width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(
          t.admin.appointments.viewDetails,
          style: context.semiBold14.primary,
        ),
      ),
    );
  }
}
