import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/models/appointment_model.dart';
import '../../../../core/models/booking_draft.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/appointment_service.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/utils/snack_bar_helper.dart';
import '../../../../core/widgets/app_background.dart';
import '../../../../core/widgets/custom_back_button.dart';
import '../../../../core/widgets/main_button.dart';
import '../../../../i18n/strings.g.dart';
import '../widgets/appointment_success_dialog.dart';
import '../../../../core/constants/my_icons.dart';

/// Step 3 of the 4-step booking flow (Date -> Time -> Review -> Confirm).
///
/// Shows a read-only summary of the chosen doctor, date, time, fee and clinic
/// location, and only creates the appointment when the patient confirms.
class ReviewAppointmentScreen extends StatefulWidget {
  const ReviewAppointmentScreen({super.key, required this.draft});

  final BookingDraft draft;

  @override
  State<ReviewAppointmentScreen> createState() =>
      _ReviewAppointmentScreenState();
}

class _ReviewAppointmentScreenState extends State<ReviewAppointmentScreen> {
  bool _isBooking = false;

  Future<void> _confirm() async {
    final currentUser = sl<AuthService>().currentUser;
    if (currentUser == null) {
      SnackBarHelper.showWarning(context, t.favorite.pleaseLogin);
      return;
    }

    final draft = widget.draft;
    setState(() => _isBooking = true);

    try {
      final appointment = AppointmentModel(
        id: '',
        patientId: currentUser.uid,
        patientName: currentUser.displayName ?? '',
        patientEmail: currentUser.email ?? '',
        doctorId: draft.doctor.uid ?? '',
        doctorName: draft.doctor.name ?? '',
        doctorSpecialty: draft.doctor.specialization,
        doctorImageUrl: draft.doctor.imageUrl,
        doctorFee: draft.doctor.consultationFee,
        clinicLocation: draft.clinicLocation,
        date: draft.date,
        timeSlot: draft.timeSlot,
        status: AppointmentStatus.upcoming,
      );

      await sl<AppointmentService>().createAppointment(appointment);
      if (!mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => AppointmentSuccessDialog(
          doctorName: draft.doctor.name ?? '',
          date: DateFormat('d MMM yyyy').format(draft.date),
          time: draft.timeSlot,
          onDone: () {
            Navigator.of(dialogContext).pop();
            context.go(AppRoutes.home);
          },
          onEdit: () {
            Navigator.of(dialogContext).pop();
            context.pop();
          },
        ),
      );
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(context, t.appointments.bookingFailed);
      }
    } finally {
      if (mounted) setState(() => _isBooking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final draft = widget.draft;
    final doctor = draft.doctor;

    return AppBackground(
      child: Scaffold(
        backgroundColor: AppColors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.transparent,
          leading: CustomBackButton(),
          title: Text(t.review.title, style: context.bold24.textPrimary),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              8.verticalSpace,
              Text(t.review.subtitle, style: context.regular14.textSecondary),
              20.verticalSpace,
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow.withValues(alpha: 0.06),
                      blurRadius: 12.r,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _SummaryRow(
                      icon: MyIcons.personRounded,
                      label: t.review.doctor,
                      value: doctor.specialization == null
                          ? (doctor.name ?? '')
                          : '${doctor.name ?? ''} - ${doctor.specialization}',
                    ),
                    Divider(height: 24.h, color: AppColors.divider),
                    _SummaryRow(
                      icon: MyIcons.calendarTodayRounded,
                      label: t.review.date,
                      value: DateFormat('EEEE, d MMM yyyy').format(draft.date),
                    ),
                    Divider(height: 24.h, color: AppColors.divider),
                    _SummaryRow(
                      icon: MyIcons.accessTimeRounded,
                      label: t.review.time,
                      value: draft.timeSlot,
                    ),
                    Divider(height: 24.h, color: AppColors.divider),
                    _SummaryRow(
                      icon: MyIcons.attachMoneyRounded,
                      label: t.review.fee,
                      value: t.common.amount(
                        amount: doctor.consultationFee.toStringAsFixed(2),
                      ),
                    ),
                    Divider(height: 24.h, color: AppColors.divider),
                    _SummaryRow(
                      icon: MyIcons.locationOnOutlined,
                      label: t.review.location,
                      value: draft.clinicLocation.isEmpty
                          ? t.common.notProvided
                          : draft.clinicLocation,
                    ),
                  ],
                ),
              ),
              32.verticalSpace,
              MainButton(
                text: _isBooking ? t.review.confirming : t.review.confirm,
                onPressed: _isBooking ? null : _confirm,
                bgColor: AppColors.primary,
                textColor: AppColors.textOnPrimary,
              ),
              32.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18.r, color: AppColors.primary),
        10.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: context.regular11.textHint),
              2.verticalSpace,
              Text(value, style: context.semiBold14.textPrimary),
            ],
          ),
        ),
      ],
    );
  }
}
