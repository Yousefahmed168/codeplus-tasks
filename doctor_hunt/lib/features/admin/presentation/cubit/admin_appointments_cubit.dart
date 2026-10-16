import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/models/appointment_model.dart';
import '../../../../core/services/appointment_service.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../i18n/strings.g.dart';
import 'admin_appointments_state.dart';

class AdminAppointmentsCubit extends Cubit<AdminAppointmentsState> {
  AdminAppointmentsCubit() : super(AdminAppointmentsInitial());

  StreamSubscription<List<AppointmentModel>>? _subscription;

  void loadAppointments() {
    // Guard: never open a Firestore listener without an authenticated admin.
    if (sl<AuthService>().currentUser == null) {
      _subscription?.cancel();
      _subscription = null;
      emit(AdminAppointmentsError(t.common.errorGeneric));
      return;
    }

    emit(AdminAppointmentsLoading());

    _subscription?.cancel();
    _subscription = sl<AppointmentService>()
        .streamAdminAppointments()
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

        emit(AdminAppointmentsLoaded(
          all: list,
          upcoming: upcoming,
          completed: completed,
          cancelled: cancelled,
        ));
      },
      onError: (e) {
        debugPrint('AdminAppointmentsCubit stream error: $e');
        emit(AdminAppointmentsError(t.common.errorGeneric));
      },
    );
  }

  Future<void> completeAppointment(String appointmentId) async {
    try {
      await sl<AppointmentService>().completeAppointment(appointmentId);
    } catch (e) {
      // Automatic refresh from stream listener
      rethrow;
    }
  }

  Future<void> cancelAppointment(String appointmentId) async {
    try {
      await sl<AppointmentService>().cancelAppointment(appointmentId);
    } catch (e) {
      // Automatic refresh from stream listener
      rethrow;
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
