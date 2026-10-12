import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/models/appointment_model.dart';
import '../../../../core/services/appointment_service.dart';

class AdminAppointmentDetailsState {
  final AppointmentModel appointment;
  final bool isLoading;
  final String? errorMessage;
  final String? successAction;

  const AdminAppointmentDetailsState({
    required this.appointment,
    this.isLoading = false,
    this.errorMessage,
    this.successAction,
  });

  AdminAppointmentDetailsState copyWith({
    AppointmentModel? appointment,
    bool? isLoading,
    String? errorMessage,
    String? successAction,
  }) {
    return AdminAppointmentDetailsState(
      appointment: appointment ?? this.appointment,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      successAction: successAction,
    );
  }
}

class AdminAppointmentDetailsCubit
    extends Cubit<AdminAppointmentDetailsState> {
  final AppointmentService _appointmentService;
  StreamSubscription<AppointmentModel?>? _subscription;

  AdminAppointmentDetailsCubit({
    required AppointmentModel initialAppointment,
    AppointmentService? appointmentService,
  })  : _appointmentService =
            appointmentService ?? sl<AppointmentService>(),
        super(AdminAppointmentDetailsState(appointment: initialAppointment)) {
    _subscribeToAppointment(initialAppointment.id);
  }

  void _subscribeToAppointment(String appointmentId) {
    if (appointmentId.isEmpty) return;
    _subscription?.cancel();
    _subscription = _appointmentService
        .streamAppointmentById(appointmentId)
        .listen(
      (updated) {
        if (updated != null) {
          emit(state.copyWith(appointment: updated));
        }
      },
      onError: (err) {
        // Stream listener error handled gracefully without breaking UI
      },
    );
  }

  Future<void> cancelAppointment() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      await _appointmentService.cancelAppointment(state.appointment.id);
      emit(state.copyWith(
        isLoading: false,
        appointment: state.appointment.copyWith(
          status: AppointmentStatus.cancelled,
        ),
        successAction: 'cancelled',
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> completeAppointment() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      await _appointmentService.completeAppointment(state.appointment.id);
      emit(state.copyWith(
        isLoading: false,
        appointment: state.appointment.copyWith(
          status: AppointmentStatus.completed,
        ),
        successAction: 'completed',
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
