import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/models/appointment_model.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../i18n/strings.g.dart';
import 'appointment_status_chip.dart';

class AppointmentCard extends StatefulWidget {
  final AppointmentModel appointment;
  final VoidCallback? onCancel;
  final VoidCallback? onViewDetails;
  final void Function(double rating)? onRate;

  const AppointmentCard({
    super.key,
    required this.appointment,
    this.onCancel,
    this.onViewDetails,
    this.onRate,
  });

  @override
  State<AppointmentCard> createState() => _AppointmentCardState();
}

class _AppointmentCardState extends State<AppointmentCard> {
  double _hoverRating = 0;

  AppointmentModel get appt => widget.appointment;

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('dd MMM yyyy').format(appt.date);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.06),
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        children: [
          //   Header
          Padding(
            padding: EdgeInsets.all(14.r),
            child: Row(
              children: [
                // Doctor avatar
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child:
                      appt.doctorImageUrl != null &&
                              appt.doctorImageUrl!.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: appt.doctorImageUrl!,
                              width: 58.r,
                              height: 58.r,
                              fit: BoxFit.cover,
                              placeholder: (_, _) => _avatarPlaceholder(),
                              errorWidget: (_, _, _) => _avatarPlaceholder(),
                            )
                          : _avatarPlaceholder(),
                ),
                12.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appt.doctorName,
                        style: context.bold16.textPrimary,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      3.verticalSpace,
                      Text(
                        appt.doctorSpecialty ?? '',
                        style: context.regular12.textSecondary,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                AppointmentStatusChip(status: appt.status),
              ],
            ),
          ),

          Divider(height: 1.h, color: AppColors.divider),

          //   Details grid
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _detailItem(
                      Icons.calendar_today_rounded,
                      t.appointments.appointmentDate,
                      dateStr,
                    ),
                    20.horizontalSpace,
                    _detailItem(
                      Icons.access_time_rounded,
                      t.appointments.appointmentTime,
                      appt.timeSlot,
                    ),
                  ],
                ),
                8.verticalSpace,
                Row(
                  children: [
                    _detailItem(
                      Icons.person_outline_rounded,
                      t.appointments.patient,
                      appt.patientName,
                    ),
                    20.horizontalSpace,
                    _detailItem(
                      Icons.attach_money_rounded,
                      t.appointments.consultationFee,
                      '\$${appt.doctorFee.toStringAsFixed(2)}',
                    ),
                  ],
                ),
              ],
            ),
          ),

          //   Star rating (completed & not reviewed)
          if (appt.status == AppointmentStatus.completed && !appt.hasReviewed)
            Padding(
              padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(height: 1.h, color: AppColors.divider),
                  10.verticalSpace,
                  Text(
                    t.appointments.tapToRate,
                    style: context.regular12.textSecondary,
                  ),
                  6.verticalSpace,
                  _StarRatingRow(
                    rating: _hoverRating,
                    onRatingChanged: (r) => setState(() => _hoverRating = r),
                    onRatingSubmitted: widget.onRate,
                  ),
                ],
              ),
            ),

          //   Action buttons
          Padding(
            padding: EdgeInsets.all(14.r),
            child: Row(
              children: [
                if (appt.status == AppointmentStatus.upcoming) ...[
                  Expanded(
                    child: _OutlinedBtn(
                      label: t.appointments.viewDetails,
                      onTap: widget.onViewDetails,
                    ),
                  ),
                  10.horizontalSpace,
                  Expanded(
                    child: _OutlinedBtn(
                      label: t.appointments.cancelAppointment,
                      color: AppColors.error,
                      onTap: widget.onCancel,
                    ),
                  ),
                ] else if (appt.status == AppointmentStatus.completed) ...[
                  Expanded(
                    child: _OutlinedBtn(
                      label: t.appointments.viewDetails,
                      onTap: widget.onViewDetails,
                    ),
                  ),
                  if (!appt.hasReviewed) ...[
                    10.horizontalSpace,
                    Expanded(
                      child: _FilledBtn(
                        label: t.appointments.rateDoctor,
                        onTap: _hoverRating > 0
                            ? () => widget.onRate?.call(_hoverRating)
                            : null,
                      ),
                    ),
                  ],
                ] else ...[
                  Expanded(
                    child: _OutlinedBtn(
                      label: t.appointments.viewDetails,
                      onTap: widget.onViewDetails,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatarPlaceholder() => Container(
    width: 58.r,
    height: 58.r,
    color: AppColors.primary.withValues(alpha: 0.1),
    child: Icon(Icons.person_rounded, color: AppColors.primary, size: 30.r),
  );

  Widget _detailItem(IconData icon, String label, String value) => Expanded(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14.r, color: AppColors.textSecondary),
        5.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: context.regular11.textHint,
              ),
              Text(
                value,
                style: context.semiBold12.textPrimary,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _StarRatingRow extends StatelessWidget {
  final double rating;
  final ValueChanged<double> onRatingChanged;
  final void Function(double)? onRatingSubmitted;

  const _StarRatingRow({
    required this.rating,
    required this.onRatingChanged,
    required this.onRatingSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (i) {
        final starValue = (i + 1).toDouble();
        return GestureDetector(
          onTap: () => onRatingChanged(starValue),
          child: Padding(
            padding: EdgeInsets.only(right: 4.w),
            child: Icon(
              rating >= starValue
                  ? Icons.star_rounded
                  : Icons.star_outline_rounded,
              color: AppColors.star,
              size: 26.r,
            ),
          ),
        );
      }),
    );
  }
}

class _OutlinedBtn extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Color color;

  const _OutlinedBtn({
    required this.label,
    this.onTap,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 11.h),
        decoration: BoxDecoration(
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: context.semiBold14.copyWith(color: color),
        ),
      ),
    );
  }
}

class _FilledBtn extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _FilledBtn({required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 11.h),
        decoration: BoxDecoration(
          gradient: onTap != null ? AppColors.primaryGradient : null,
          color: onTap == null ? AppColors.textHint : null,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: context.semiBold14.textOnPrimary,
        ),
      ),
    );
  }
}
