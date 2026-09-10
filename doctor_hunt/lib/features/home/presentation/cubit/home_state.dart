import 'package:equatable/equatable.dart';
import '../../../../features/auth/data/models/patient_model.dart';
import '../../../../features/doctors/models/doctor.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final PatientModel? patient;
  final List<Doctor> doctors;
  final Set<String> favoriteIds;

  const HomeLoaded({
    this.patient,
    required this.doctors,
    required this.favoriteIds,
  });

  @override
  List<Object?> get props => [patient, doctors, favoriteIds];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
