import '../../../../core/models/appointment_model.dart';

abstract class AdminAppointmentsState {}

class AdminAppointmentsInitial extends AdminAppointmentsState {}

class AdminAppointmentsLoading extends AdminAppointmentsState {}

class AdminAppointmentsLoaded extends AdminAppointmentsState {
  final List<AppointmentModel> all;
  final List<AppointmentModel> upcoming;
  final List<AppointmentModel> completed;
  final List<AppointmentModel> cancelled;

  AdminAppointmentsLoaded({
    required this.all,
    required this.upcoming,
    required this.completed,
    required this.cancelled,
  });
}

class AdminAppointmentsError extends AdminAppointmentsState {
  final String message;

  AdminAppointmentsError(this.message);
}
