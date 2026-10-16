import 'dart:async';

import 'package:doctor_hunt/core/enums/user_role.dart';
import 'package:doctor_hunt/core/models/appointment_model.dart';
import 'package:doctor_hunt/core/services/appointment_service.dart';
import 'package:doctor_hunt/core/services/auth_service.dart';
import 'package:doctor_hunt/core/services/cloudinary_service.dart';
import 'package:doctor_hunt/core/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Hand-rolled test doubles.
///
/// The production services expose only private constructors and are resolved
/// through get_it, so tests cannot sub-class them. Instead each fake
/// `implements` the interface (which never calls the private constructor) and
/// relies on `noSuchMethod` for the members a given test does not exercise.

class FakeUser implements User {
  FakeUser({required this.uid, this.displayName, this.email});

  @override
  final String uid;

  @override
  final String? displayName;

  @override
  final String? email;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeUserCredential implements UserCredential {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Auth service double with scriptable role/user and error injection.
class FakeAuthService implements AuthService {
  User? currentUserValue;
  UserRole? roleValue;
  Object? loginError;
  Object? registerError;
  bool logoutCalled = false;

  @override
  User? get currentUser => currentUserValue;

  @override
  Stream<User?> get authStateChanges => const Stream.empty();

  @override
  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    if (loginError != null) throw loginError!;
    return _FakeUserCredential();
  }

  @override
  Future<UserRole?> getUserRole(String uid) async => roleValue;

  @override
  Future<void> logout() async {
    logoutCalled = true;
  }

  @override
  Future<UserCredential> registerPatient({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    if (registerError != null) throw registerError!;
    return _FakeUserCredential();
  }

  @override
  String getErrorMessage(String code) => code;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeUserService implements UserService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeCloudinaryService implements CloudinaryService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Appointment service double driven by a broadcast stream the test controls.
class FakeAppointmentService implements AppointmentService {
  final StreamController<List<AppointmentModel>> _controller =
      StreamController<List<AppointmentModel>>.broadcast();

  final List<String> cancelledIds = <String>[];
  final List<Map<String, Object?>> reviews = <Map<String, Object?>>[];

  void emitAppointments(List<AppointmentModel> appointments) =>
      _controller.add(appointments);

  Future<void> dispose() => _controller.close();

  @override
  Stream<List<AppointmentModel>> streamPatientAppointments(String patientId) =>
      _controller.stream;

  @override
  Future<void> cancelAppointment(String appointmentId) async {
    cancelledIds.add(appointmentId);
  }

  @override
  Future<void> submitReview({
    required String appointmentId,
    required String doctorId,
    required String patientId,
    required double rating,
    String? comment,
  }) async {
    reviews.add({
      'appointmentId': appointmentId,
      'doctorId': doctorId,
      'patientId': patientId,
      'rating': rating,
      'comment': comment,
    });
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
