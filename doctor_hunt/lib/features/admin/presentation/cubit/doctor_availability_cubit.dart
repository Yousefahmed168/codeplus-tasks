import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/models/doctor.dart';
import '../../../../core/services/admin_service.dart';
import '../../../../i18n/strings.g.dart';

enum DoctorAvailabilityStatus { idle, saving, saved, failed }

class DoctorAvailabilityState {
  const DoctorAvailabilityState({
    this.status = DoctorAvailabilityStatus.idle,
    this.errorMessage,
  });

  final DoctorAvailabilityStatus status;
  final String? errorMessage;
}

/// Owns the admin "save availability" write so the screen stops calling
/// [AdminService] directly.
class DoctorAvailabilityCubit extends Cubit<DoctorAvailabilityState> {
  DoctorAvailabilityCubit() : super(const DoctorAvailabilityState());

  final AdminService _adminService = sl<AdminService>();

  Future<void> saveAvailability({
    required Doctor doctor,
    required List<String> workingDays,
    required String startTime,
    required String endTime,
    required int slotDuration,
  }) async {
    final uid = doctor.uid;
    if (uid == null) return;

    emit(const DoctorAvailabilityState(status: DoctorAvailabilityStatus.saving));
    try {
      await _adminService.updateDoctor(uid, {
        'workingDays': workingDays,
        'startTime': startTime,
        'endTime': endTime,
        'slotDuration': slotDuration,
      });
      emit(const DoctorAvailabilityState(status: DoctorAvailabilityStatus.saved));
    } catch (e) {
      debugPrint('DoctorAvailabilityCubit: failed to save availability: $e');
      emit(
        DoctorAvailabilityState(
          status: DoctorAvailabilityStatus.failed,
          errorMessage: t.common.errorGeneric,
        ),
      );
    }
  }
}
