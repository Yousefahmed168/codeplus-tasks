import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/my_icons.dart';
import '../../../../core/models/appointment_model.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/widgets/custom_back_button.dart';
import '../../../../i18n/strings.g.dart';
import '../cubit/admin_appointment_details_cubit.dart';
import '../../../../core/utils/snack_bar_helper.dart';
import '../widgets/appointment_status_pill.dart';

class AdminAppointmentDetailsScreen extends StatelessWidget {
  const AdminAppointmentDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final extra = GoRouterState.of(context).extra;
    AppointmentModel? appointment;
    bool isAdminView = true;

    if (extra is Map) {
      appointment = extra['appointment'] as AppointmentModel?;
      isAdminView = extra['isAdminView'] as bool? ?? true;
    } else if (extra is AppointmentModel) {
      appointment = extra;
    }

    if (appointment == null) {
      return Scaffold(
        body: Center(child: Text(t.admin.appointments.notFound)),
      );
    }
    return BlocProvider(
      create: (_) =>
          AdminAppointmentDetailsCubit(initialAppointment: appointment!),
      child: _AdminAppointmentDetailsView(isAdminView: isAdminView),
    );
  }
}

class _AdminAppointmentDetailsView extends StatelessWidget {
  final bool isAdminView;
  const _AdminAppointmentDetailsView({this.isAdminView = true});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<
      AdminAppointmentDetailsCubit,
      AdminAppointmentDetailsState
    >(
      listener: (context, state) {
        if (state.successAction == 'cancelled') {
          SnackBarHelper.show(context, t.admin.appointments.cancelSuccess, color: AppColors.destructiveRed);
        } else if (state.successAction == 'completed') {
          SnackBarHelper.show(context, t.admin.appointments.completeSuccess, color: AppColors.emeraldGreen);
        } else if (state.errorMessage != null) {
          SnackBarHelper.showError(context, state.errorMessage!);
        }
      },
      builder: (context, state) {
        final appt = state.appointment;
        final dateStr = DateFormat('dd MMM yyyy').format(appt.date);

        return Scaffold(
          backgroundColor: AppColors.mintBackground,
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            elevation: 0,
            scrolledUnderElevation: 0,
            leadingWidth: 70.w,
            leading: Padding(
              padding: EdgeInsets.only(left: 16),
              child: CustomBackButton(),
            ),
            title: Text(
              t.admin.appointments.detailsTitle,
              style: context.bold18.textPrimary,
            ),
            centerTitle: false,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //   Section 1: Patient
                Text(
                  t.admin.appointments.patient,
                  style: context.bold16.textPrimary,
                ),
                8.h.verticalSpace,
                _buildCard(
                  child: Row(
                    children: [
                      _buildPhotoAvatar(
                        context: context,
                        imageUrl: null,
                        name: appt.patientName,
                      ),
                      14.w.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              appt.patientName,
                              style: context.bold16.textPrimary,
                            ),
                            4.h.verticalSpace,
                            Row(
                              children: [
                                const Icon(
                                  MyIcons.email,
                                  size: 14,
                                  color: AppColors.textSecondary,
                                ),
                                6.w.horizontalSpace,
                                Expanded(
                                  child: Text(
                                    appt.patientEmail,
                                    style: context.regular12.textSecondary,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                20.h.verticalSpace,

                //   Section 2: Doctor
                Text(
                  t.admin.appointments.doctor,
                  style: context.bold16.textPrimary,
                ),
                8.h.verticalSpace,
                _buildCard(
                  child: Row(
                    children: [
                      _buildPhotoAvatar(
                        context: context,
                        imageUrl: appt.doctorImageUrl,
                        name: appt.doctorName,
                      ),
                      14.w.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              appt.doctorName,
                              style: context.bold16.textPrimary,
                            ),
                            4.h.verticalSpace,
                            Text(
                              appt.doctorSpecialty ?? '',
                              style: context.regular12.textSecondary,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 32.w,
                        height: 32.h,
                        decoration: const BoxDecoration(
                          color: AppColors.mintTileBackground,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          MyIcons.verified,
                          color: AppColors.emeraldGreen,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                20.h.verticalSpace,

                //   Section 3: Appointment
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      t.admin.appointments.appointment,
                      style: context.bold16.textPrimary,
                    ),
                    AppointmentStatusPill(status: appt.status),
                  ],
                ),
                8.h.verticalSpace,
                _buildCard(
                  padding: EdgeInsets.all(12.w),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildDetailTile(
                              context: context,
                              icon: MyIcons.calendar,
                              label: t.admin.appointments.date.toUpperCase(),
                              value: dateStr,
                            ),
                          ),
                          10.w.horizontalSpace,
                          Expanded(
                            child: _buildDetailTile(
                              context: context,
                              icon: MyIcons.clock,
                              label: t.admin.appointments.time.toUpperCase(),
                              value: appt.timeSlot,
                            ),
                          ),
                        ],
                      ),
                      10.h.verticalSpace,
                      _buildDetailTile(
                        context: context,
                        icon: MyIcons.fee,
                        label: t.admin.appointments.consultationFee
                            .toUpperCase(),
                        value: '\$${appt.doctorFee.toStringAsFixed(2)}',
                      ),
                      10.h.verticalSpace,
                      _buildDetailTile(
                        context: context,
                        icon: MyIcons.location,
                        label: t.admin.appointments.clinicLocation
                            .toUpperCase(),
                        value: appt.clinicLocation,
                      ),
                    ],
                  ),
                ),
                32.h.verticalSpace,
              ],
            ),
          ),
          bottomNavigationBar: isAdminView && appt.status == AppointmentStatus.upcoming
              ? Container(
                  padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.textPrimary.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: state.isLoading
                                ? null
                                : () => _confirmCancel(context),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: AppColors.destructiveRedLight,
                              foregroundColor: AppColors.destructiveRed,
                              side: const BorderSide(
                                color: AppColors.destructiveRed,
                                width: 1.2,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                            ),
                            child: Text(
                              t.admin.appointments.cancelAppointment,
                              style: context.semiBold14.copyWith(
                                color: AppColors.destructiveRed,
                              ),
                            ),
                          ),
                        ),
                        12.w.horizontalSpace,
                        Expanded(
                          child: ElevatedButton(
                            onPressed: state.isLoading
                                ? null
                                : () => _confirmComplete(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.emeraldGreen,
                              foregroundColor: AppColors.surface,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  MyIcons.check,
                                  size: 18,
                                  color: AppColors.surface,
                                ),
                                6.w.horizontalSpace,
                                Flexible(
                                  child: Text(
                                    t.admin.appointments.markCompleted,
                                    style: context.semiBold14.copyWith(
                                      color: AppColors.surface,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : null,
        );
      },
    );
  }

  Widget _buildCard({required Widget child, EdgeInsetsGeometry? padding}) {
    return Container(
      padding: padding ?? EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildDetailTile({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.tileBackground,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.tileBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 36.w,
            height: 36.h,
            decoration: BoxDecoration(
              color: AppColors.mintTileBackground,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, size: 18, color: AppColors.emeraldGreen),
          ),
          12.w.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: context.regular11.copyWith(
                    color: AppColors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
                2.h.verticalSpace,
                Text(
                  value,
                  style: context.semiBold14.textPrimary,
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

  Widget _buildPhotoAvatar({
    required BuildContext context,
    required String? imageUrl,
    required String name,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        width: 64.w,
        height: 64.h,
        color: AppColors.mintTileBackground,
        child: imageUrl != null && imageUrl.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: imageUrl,
                width: 64.w,
                height: 64.h,
                fit: BoxFit.cover,
                errorWidget: (_, _, _) => _fallbackInitial(context, name),
              )
            : _fallbackInitial(context, name),
      ),
    );
  }

  Widget _fallbackInitial(BuildContext context, String name) {
    return Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: context.bold24.copyWith(color: AppColors.emeraldGreen),
      ),
    );
  }

  Future<void> _confirmCancel(BuildContext context) async {
    final cubit = context.read<AdminAppointmentDetailsCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(t.admin.appointments.cancelConfirmTitle),
        content: Text(t.admin.appointments.cancelConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              t.common.cancel,
              style: context.regular14.textSecondary,
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              t.common.confirm,
              style: context.semiBold14.copyWith(
                color: AppColors.destructiveRed,
              ),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await cubit.cancelAppointment();
    }
  }

  Future<void> _confirmComplete(BuildContext context) async {
    final cubit = context.read<AdminAppointmentDetailsCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(t.admin.appointments.completeConfirmTitle),
        content: Text(t.admin.appointments.completeConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              t.common.cancel,
              style: context.regular14.textSecondary,
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              t.common.confirm,
              style: context.semiBold14.copyWith(color: AppColors.emeraldGreen),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await cubit.completeAppointment();
    }
  }
}
