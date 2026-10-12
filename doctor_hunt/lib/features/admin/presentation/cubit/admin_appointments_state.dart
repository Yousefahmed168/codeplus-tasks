import '../../../../core/models/appointment_model.dart';

abstract class AdminAppointmentsState {}

class AdminAppointmentsInitial extends AdminAppointmentsState {}

class AdminAppointmentsLoading extends AdminAppointmentsState {}

class AdminAppointmentsLoaded extends AdminAppointmentsState {
  final List<AppointmentModel> upcoming;
  final List<AppointmentModel> completed;
  final List<AppointmentModel> cancelled;

  AdminAppointmentsLoaded({
    required this.upcoming,
    required this.completed,
    required this.cancelled,
  });

  List<AppointmentModel> getByStatus(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.upcoming:
        return upcoming;
      case AppointmentStatus.completed:
        return completed;
      case AppointmentStatus.cancelled:
        return cancelled;
    }
  }
}

class AdminAppointmentsError extends AdminAppointmentsState {
  final String message;

  AdminAppointmentsError(this.message);
}
