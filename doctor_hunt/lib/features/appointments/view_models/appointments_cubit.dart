import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/models/appointment_model.dart';
import '../../../core/services/appointment_service.dart';
import '../../../core/services/auth_service.dart';
import '../../../i18n/strings.g.dart';
import 'appointments_state.dart';

class AppointmentsCubit extends Cubit<AppointmentsState> {
  AppointmentsCubit() : super(AppointmentsInitial());

  StreamSubscription<List<AppointmentModel>>? _subscription;

  void loadAppointments() {
    final patientId = sl<AuthService>().currentUser?.uid;
    if (patientId == null) {
      _subscription?.cancel();
      _subscription = null;
      emit(AppointmentsError(t.common.errorGeneric));
      return;
    }

    emit(AppointmentsLoading());

    _subscription = sl<AppointmentService>()
        .streamPatientAppointments(patientId)
        .listen(
      (list) {
        final upcoming = list
            .where((a) => a.status == AppointmentStatus.upcoming)
            .toList();
        final completed = list
            .where((a) => a.status == AppointmentStatus.completed)
            .toList();
        final cancelled = list
            .where((a) => a.status == AppointmentStatus.cancelled)
            .toList();

        emit(AppointmentsLoaded(
          upcoming: upcoming,
          completed: completed,
          cancelled: cancelled,
        ));
      },
      onError: (e) {
        debugPrint('AppointmentsCubit stream error: $e');
        emit(AppointmentsError(t.common.errorGeneric));
      },
    );
  }

  Future<void> cancelAppointment(String appointmentId) async {
    try {
      await sl<AppointmentService>().cancelAppointment(appointmentId);
    } catch (e) {
      // State will update automatically via stream
    }
  }

  Future<void> submitReview({
    required String appointmentId,
    required String doctorId,
    required double rating,
    String? comment,
  }) async {
    final patientId = sl<AuthService>().currentUser?.uid;
    if (patientId == null) return;

    await sl<AppointmentService>().submitReview(
      appointmentId: appointmentId,
      doctorId: doctorId,
      patientId: patientId,
      rating: rating,
      comment: comment,
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
