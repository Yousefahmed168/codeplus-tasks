import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../../../../core/models/appointment_model.dart';
import '../../../../core/theme/colors.dart';
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
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          //   Header
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Doctor avatar
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child:
                      appt.doctorImageUrl != null &&
                          appt.doctorImageUrl!.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: appt.doctorImageUrl!,
                          width: 58,
                          height: 58,
                          fit: BoxFit.cover,
                          placeholder: (_, _) => _avatarPlaceholder(),
                          errorWidget: (_, _, _) => _avatarPlaceholder(),
                        )
                      : _avatarPlaceholder(),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appt.doctorName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Gap(3),
                      Text(
                        appt.doctorSpecialty ?? '',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
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

          const Divider(height: 1, color: AppColors.divider),

          //   Details grid
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
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
                    const Gap(20),
                    _detailItem(
                      Icons.access_time_rounded,
                      t.appointments.appointmentTime,
                      appt.timeSlot,
                    ),
                  ],
                ),
                const Gap(8),
                Row(
                  children: [
                    _detailItem(
                      Icons.person_outline_rounded,
                      t.appointments.patient,
                      appt.patientName,
                    ),
                    const Gap(20),
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
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 1, color: AppColors.divider),
                  const Gap(10),
                  Text(
                    t.appointments.tapToRate,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Gap(6),
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
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                if (appt.status == AppointmentStatus.upcoming) ...[
                  Expanded(
                    child: _OutlinedBtn(
                      label: t.appointments.viewDetails,
                      onTap: widget.onViewDetails,
                    ),
                  ),
                  const Gap(10),
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
                    const Gap(10),
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
    width: 58,
    height: 58,
    color: AppColors.primary.withValues(alpha: 0.1),
    child: const Icon(Icons.person_rounded, color: AppColors.primary, size: 30),
  );

  Widget _detailItem(IconData icon, String label, String value) => Expanded(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const Gap(5),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 10, color: AppColors.textHint),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
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
          onTap: () {
            onRatingChanged(starValue);
            onRatingSubmitted?.call(starValue);
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Icon(
              rating >= starValue
                  ? Icons.star_rounded
                  : Icons.star_outline_rounded,
              color: AppColors.star,
              size: 26,
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
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: color,
          ),
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
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          gradient: onTap != null ? AppColors.primaryGradient : null,
          color: onTap == null ? AppColors.textHint : null,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textOnPrimary,
          ),
        ),
      ),
    );
  }
}
