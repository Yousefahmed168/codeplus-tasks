import 'package:equatable/equatable.dart';

import '../../../../core/models/patient_model.dart';

/// Presentation state for the settings screen.
///
/// A single immutable state (with [copyWith]) is enough here: the screen holds
/// independent values and toggles rather than mutually exclusive phases.
class PatientSettingsState extends Equatable {
  const PatientSettingsState({
    this.isLoading = true,
    this.isLoggingOut = false,
    this.error,
    this.patient,
    this.notificationsEnabled = true,
    this.appVersion = '',
  });

  /// True until the stored preferences, the app version and the patient
  /// document have been resolved.
  final bool isLoading;

  /// True while the sign-out request is in flight.
  final bool isLoggingOut;

  /// Transient error message, surfaced once as a snack bar.
  final String? error;

  /// The signed-in patient, used by the quick information card.
  final PatientModel? patient;

  final bool notificationsEnabled;

  /// Formatted app version, e.g. `v1.0.0+1`.
  final String appVersion;

  PatientSettingsState copyWith({
    bool? isLoading,
    bool? isLoggingOut,
    String? error,
    PatientModel? patient,
    bool? notificationsEnabled,
    String? appVersion,
  }) {
    return PatientSettingsState(
      isLoading: isLoading ?? this.isLoading,
      isLoggingOut: isLoggingOut ?? this.isLoggingOut,
      error: error ?? this.error,
      patient: patient ?? this.patient,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      appVersion: appVersion ?? this.appVersion,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isLoggingOut,
    error,
    patient,
    notificationsEnabled,
    appVersion,
  ];
}
