import 'package:doctor_hunt/core/di/service_locator.dart';
import 'package:doctor_hunt/core/models/appointment_model.dart';
import 'package:doctor_hunt/core/services/appointment_service.dart';
import 'package:doctor_hunt/core/services/auth_service.dart';
import 'package:doctor_hunt/features/appointments/view_models/appointments_cubit.dart';
import 'package:doctor_hunt/features/appointments/view_models/appointments_state.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes/fake_services.dart';

AppointmentModel _appointment(String id, AppointmentStatus status) {
  return AppointmentModel(
    id: id,
    patientId: 'patient-1',
    patientName: 'Patient',
    patientEmail: 'patient@test.com',
    doctorId: 'doctor-1',
    doctorName: 'Doctor',
    clinicLocation: 'Central Clinic',
    date: DateTime(2026, 10, 20),
    timeSlot: '1:00 PM',
    status: status,
  );
}

void main() {
  late FakeAuthService auth;
  late FakeAppointmentService appointments;
  late AppointmentsCubit cubit;

  setUp(() {
    sl.reset();
    auth = FakeAuthService();
    appointments = FakeAppointmentService();
    sl.registerSingleton<AuthService>(auth);
    sl.registerSingleton<AppointmentService>(appointments);
    cubit = AppointmentsCubit();
  });

  tearDown(() async {
    await cubit.close();
    await appointments.dispose();
    await sl.reset();
  });

  test('loadAppointments without an authenticated user emits an error', () {
    auth.currentUserValue = null;

    cubit.loadAppointments();

    expect(cubit.state, isA<AppointmentsError>());
  });

  test('loadAppointments streams and groups appointments by status', () async {
    auth.currentUserValue = FakeUser(uid: 'patient-1');

    cubit.loadAppointments();
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state, isA<AppointmentsLoading>());

    appointments.emitAppointments([
      _appointment('a1', AppointmentStatus.upcoming),
      _appointment('a2', AppointmentStatus.completed),
      _appointment('a3', AppointmentStatus.cancelled),
      _appointment('a4', AppointmentStatus.upcoming),
    ]);
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state, isA<AppointmentsLoaded>());
    final loaded = cubit.state as AppointmentsLoaded;
    expect(loaded.upcoming.map((a) => a.id), containsAll(['a1', 'a4']));
    expect(loaded.completed.single.id, 'a2');
    expect(loaded.cancelled.single.id, 'a3');
  });

  test('cancelAppointment delegates to the service', () async {
    auth.currentUserValue = FakeUser(uid: 'patient-1');

    await cubit.cancelAppointment('a1');

    expect(appointments.cancelledIds, contains('a1'));
  });

  test('submitReview forwards the current user id to the service', () async {
    auth.currentUserValue = FakeUser(uid: 'patient-1');

    await cubit.submitReview(
      appointmentId: 'a1',
      doctorId: 'doctor-1',
      rating: 5,
      comment: 'Great',
    );

    expect(appointments.reviews, hasLength(1));
    expect(appointments.reviews.single['patientId'], 'patient-1');
    expect(appointments.reviews.single['doctorId'], 'doctor-1');
    expect(appointments.reviews.single['rating'], 5);
  });

  test('submitReview is a no-op when there is no authenticated user', () async {
    auth.currentUserValue = null;

    await cubit.submitReview(
      appointmentId: 'a1',
      doctorId: 'doctor-1',
      rating: 5,
    );

    expect(appointments.reviews, isEmpty);
  });
}
