import '../../../core/models/appointment_model.dart';

abstract class AppointmentsState {}

class AppointmentsInitial extends AppointmentsState {}

class AppointmentsLoading extends AppointmentsState {}

class AppointmentsLoaded extends AppointmentsState {
  final List<AppointmentModel> upcoming;
  final List<AppointmentModel> completed;
  final List<AppointmentModel> cancelled;

  AppointmentsLoaded({
    required this.upcoming,
    required this.completed,
    required this.cancelled,
  });
}

class AppointmentsError extends AppointmentsState {
  final String message;
  AppointmentsError(this.message);
}
