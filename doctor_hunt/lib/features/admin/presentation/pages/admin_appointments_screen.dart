import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/models/appointment_model.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../i18n/strings.g.dart';
import '../../../appointments/views/widgets/appointment_empty_state.dart';
import '../../../appointments/views/widgets/appointment_shimmer.dart';
import '../cubit/admin_appointments_cubit.dart';
import '../cubit/admin_appointments_state.dart';
import '../widgets/admin_appointment_card.dart';

class AdminAppointmentsScreen extends StatefulWidget {
  const AdminAppointmentsScreen({super.key});

  @override
  State<AdminAppointmentsScreen> createState() =>
      _AdminAppointmentsScreenState();
}

class _AdminAppointmentsScreenState extends State<AdminAppointmentsScreen> {
  int _selectedTab = 0; // 0: Upcoming, 1: Completed, 2: Cancelled

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminAppointmentsCubit()..loadAppointments(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0,
          automaticallyImplyLeading: false,
          titleSpacing: 20.w,
          title: Text(
            t.admin.appointments.title,
            style: context.bold20.copyWith(color: AppColors.textOnPrimary),
          ),
          actions: [
            // Admin Avatar 'A'
            Container(
              width: 38.r,
              height: 38.r,
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  'A',
                  style: context.bold16.copyWith(color: AppColors.textOnPrimary),
                ),
              ),
            ),
            20.horizontalSpace,
          ],
        ),
        body: Column(
          children: [
            12.verticalSpace,
            //   Pill Tab Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Container(
                padding: EdgeInsets.all(4.r),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.divider.withValues(alpha: 0.5),
                  ),
                ),
                child: Row(
                  children: [
                    _buildTabItem(0, t.admin.appointments.upcoming),
                    _buildTabItem(1, t.admin.appointments.completed),
                    _buildTabItem(2, t.admin.appointments.cancelled),
                  ],
                ),
              ),
            ),
            12.verticalSpace,

            //   Tab View Content
            Expanded(
              child:
                  BlocBuilder<AdminAppointmentsCubit, AdminAppointmentsState>(
                    builder: (context, state) {
                      if (state is AdminAppointmentsLoading ||
                          state is AdminAppointmentsInitial) {
                        return const AppointmentShimmer();
                      }

                      if (state is AdminAppointmentsError) {
                        return Center(
                          child: Text(
                            state.message,
                            style: context.regular14.textSecondary,
                          ),
                        );
                      }

                      if (state is AdminAppointmentsLoaded) {
                        final appointments = _getFilteredAppointments(state);

                        if (appointments.isEmpty) {
                          return AppointmentEmptyState(
                            icon: _getEmptyIcon(),
                            title: _getEmptyTitle(),
                            subtitle: '',
                          );
                        }

                        return ListView.separated(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 8.h,
                          ),
                          itemCount: appointments.length,
                          separatorBuilder: (_, _) => 14.verticalSpace,
                          itemBuilder: (context, index) {
                            final appt = appointments[index];
                            return AdminAppointmentCard(
                              appointment: appt,
                              onCancel: () => _confirmCancel(context, appt),
                              onComplete: () => _confirmComplete(context, appt),
                              onViewDetails: () {
                                context.push(
                                  AppRoutes.adminAppointmentDetails,
                                  extra: {'appointment': appt, 'isAdminView': true},
                                );
                              },
                            );
                          },
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(int index, String title) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Center(
            child: Text(
              title,
              style: isSelected
                  ? context.semiBold14.copyWith(color: AppColors.textOnPrimary)
                  : context.regular14.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  List<AppointmentModel> _getFilteredAppointments(
    AdminAppointmentsLoaded state,
  ) {
    switch (_selectedTab) {
      case 0:
        return state.upcoming;
      case 1:
        return state.completed;
      case 2:
        return state.cancelled;
      default:
        return [];
    }
  }

  IconData _getEmptyIcon() {
    switch (_selectedTab) {
      case 0:
        return Icons.calendar_today_outlined;
      case 1:
        return Icons.check_circle_outline_rounded;
      case 2:
        return Icons.cancel_outlined;
      default:
        return Icons.calendar_today_outlined;
    }
  }

  String _getEmptyTitle() {
    switch (_selectedTab) {
      case 0:
        return t.admin.appointments.noUpcoming;
      case 1:
        return t.admin.appointments.noCompleted;
      case 2:
        return t.admin.appointments.noCancelled;
      default:
        return '';
    }
  }

  Future<void> _confirmCancel(
    BuildContext context,
    AppointmentModel appt,
  ) async {
    final cubit = context.read<AdminAppointmentsCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
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
              style: context.semiBold14.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await cubit.cancelAppointment(appt.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(t.admin.appointments.cancelSuccess),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed: $e'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  Future<void> _confirmComplete(
    BuildContext context,
    AppointmentModel appt,
  ) async {
    final cubit = context.read<AdminAppointmentsCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
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
              style: context.semiBold14.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await cubit.completeAppointment(appt.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(t.admin.appointments.completeSuccess),
              backgroundColor: AppColors.primary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed: $e'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }
}
