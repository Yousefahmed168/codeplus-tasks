import 'package:equatable/equatable.dart';
import '../../data/models/patient_model.dart';

abstract class PatientProfileState extends Equatable {
  const PatientProfileState();

  @override
  List<Object?> get props => [];
}

class PatientProfileInitial extends PatientProfileState {}

class PatientProfileLoading extends PatientProfileState {}

class PatientProfileLoaded extends PatientProfileState {
  final PatientModel patient;

  const PatientProfileLoaded({required this.patient});

  @override
  List<Object?> get props => [patient];
}

class PatientProfileSaving extends PatientProfileState {
  final PatientModel patient; // Keep the current patient data visible while saving

  const PatientProfileSaving({required this.patient});

  @override
  List<Object?> get props => [patient];
}

class PatientProfileError extends PatientProfileState {
  final String message;

  const PatientProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
