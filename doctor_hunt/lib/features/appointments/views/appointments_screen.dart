import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/appointment_model.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/colors.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/custom_back_button.dart';
import '../../../i18n/strings.g.dart';
import '../view_models/appointments_cubit.dart';
import '../view_models/appointments_state.dart';
import 'widgets/appointment_card.dart';
import 'widgets/appointment_empty_state.dart';
import 'widgets/appointment_shimmer.dart';
import 'widgets/appointment_tab_bar.dart';

class AppointmentsScreen extends StatefulWidget {
  final bool showBackButton;

  const AppointmentsScreen({super.key, this.showBackButton = true});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppointmentsCubit()..loadAppointments(),
      child: AppBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            leading: widget.showBackButton
                ? Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: CustomBackButton(
                      onTap: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go(AppRoutes.home);
                        }
                      },
                    ),
                  )
                : null,
            leadingWidth: widget.showBackButton ? 64 : 0,
            title: Text(
              t.appointments.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            centerTitle: false,
          ),
          body: BlocBuilder<AppointmentsCubit, AppointmentsState>(
            builder: (context, state) {
              if (state is AppointmentsLoading || state is AppointmentsInitial) {
                return const AppointmentShimmer();
              }

              if (state is AppointmentsError) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                );
              }

              if (state is AppointmentsLoaded) {
                return Column(
                  children: [
                    AppointmentTabBar(
                      selectedIndex: _selectedTab,
                      onTabChanged: (i) => setState(() => _selectedTab = i),
                    ),
                    Expanded(
                      child: IndexedStack(
                        index: _selectedTab,
                        children: [
                          _AppointmentList(
                            appointments: state.upcoming,
                            emptyTitle: t.appointments.noUpcoming,
                            emptySubtitle:
                                'Book an appointment with a doctor to see it here.',
                            emptyIcon: Icons.calendar_today_rounded,
                            tabIndex: 0,
                          ),
                          _AppointmentList(
                            appointments: state.completed,
                            emptyTitle: t.appointments.noCompleted,
                            emptySubtitle:
                                'Your completed appointments will appear here.',
                            emptyIcon: Icons.check_circle_outline_rounded,
                            tabIndex: 1,
                          ),
                          _AppointmentList(
                            appointments: state.cancelled,
                            emptyTitle: t.appointments.noCancelled,
                            emptySubtitle:
                                'Your cancelled appointments will appear here.',
                            emptyIcon: Icons.cancel_outlined,
                            tabIndex: 2,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}

class _AppointmentList extends StatelessWidget {
  final List<AppointmentModel> appointments;
  final String emptyTitle;
  final String emptySubtitle;
  final IconData emptyIcon;
  final int tabIndex;

  const _AppointmentList({
    required this.appointments,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.emptyIcon,
    required this.tabIndex,
  });

  @override
  Widget build(BuildContext context) {
    if (appointments.isEmpty) {
      return AppointmentEmptyState(
        icon: emptyIcon,
        title: emptyTitle,
        subtitle: emptySubtitle,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: appointments.length,
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final appt = appointments[index];
        return AppointmentCard(
          appointment: appt,
          onCancel: appt.canCancel
              ? () => _confirmCancel(context, appt)
              : null,
          onViewDetails: () {
            context.push(
              AppRoutes.adminAppointmentDetails,
              extra: appt,
            );
          },
          onRate: appt.canReview
              ? (rating) => _submitReview(context, appt, rating)
              : null,
        );
      },
    );
  }

  Future<void> _confirmCancel(
      BuildContext context, AppointmentModel appt) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(t.appointments.cancelConfirmTitle),
        content: Text(t.appointments.cancelConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(t.common.cancel,
                style: const TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(t.common.confirm,
                style: const TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await context.read<AppointmentsCubit>().cancelAppointment(appt.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.appointments.cancelSuccess),
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  Future<void> _submitReview(
      BuildContext context, AppointmentModel appt, double rating) async {
    try {
      await context.read<AppointmentsCubit>().submitReview(
            appointmentId: appt.id,
            doctorId: appt.doctorId,
            rating: rating,
          );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.appointments.reviewSuccess),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.primary,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.appointments.reviewFailed),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.error,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }
}
