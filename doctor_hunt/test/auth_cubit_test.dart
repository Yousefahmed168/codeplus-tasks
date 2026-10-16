import 'package:doctor_hunt/core/di/service_locator.dart';
import 'package:doctor_hunt/core/enums/user_role.dart';
import 'package:doctor_hunt/core/services/auth_service.dart';
import 'package:doctor_hunt/core/services/cloudinary_service.dart';
import 'package:doctor_hunt/core/services/user_service.dart';
import 'package:doctor_hunt/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:doctor_hunt/features/auth/presentation/cubit/auth_state.dart';
import 'package:doctor_hunt/i18n/strings.g.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fakes/fake_services.dart';

void main() {
  late FakeAuthService auth;
  late AuthCubit cubit;

  setUpAll(() {
    // Slang needs an active locale before any `t.*` lookup.
    LocaleSettings.setLocaleSync(AppLocale.en);
  });

  setUp(() {
    sl.reset();
    auth = FakeAuthService();
    sl.registerSingleton<AuthService>(auth);
    sl.registerSingleton<UserService>(FakeUserService());
    sl.registerSingleton<CloudinaryService>(FakeCloudinaryService());
    cubit = AuthCubit();
  });

  tearDown(() async {
    await cubit.close();
    await sl.reset();
  });

  test('login as a patient emits AuthLoginSuccessState with the role name',
      () async {
    auth.currentUserValue = FakeUser(uid: 'patient-1');
    auth.roleValue = UserRole.patient;

    await cubit.login(email: 'patient@test.com', password: '123456');

    expect(cubit.state, isA<AuthLoginSuccessState>());
    expect((cubit.state as AuthLoginSuccessState).roleName, 'patient');
    expect(auth.logoutCalled, isFalse);
  });

  test('login as an admin signs out and emits an error', () async {
    auth.currentUserValue = FakeUser(uid: 'admin-1');
    auth.roleValue = UserRole.admin;

    await cubit.login(email: 'admin@test.com', password: '123456');

    expect(auth.logoutCalled, isTrue);
    expect(cubit.state, isA<AuthErrorState>());
  });

  test('login with no matching role signs out and emits an error', () async {
    auth.currentUserValue = FakeUser(uid: 'ghost');
    auth.roleValue = null;

    await cubit.login(email: 'ghost@test.com', password: '123456');

    expect(auth.logoutCalled, isTrue);
    expect(cubit.state, isA<AuthErrorState>());
  });

  test('registerPatient emits AuthSuccessState', () async {
    await cubit.registerPatient(
      name: 'Patient',
      email: 'p@test.com',
      password: '123456',
      phone: '0100000000',
    );

    expect(cubit.state, isA<AuthSuccessState>());
  });

  test('registerPatient surfaces a service error as AuthErrorState', () async {
    auth.registerError = Exception('email-already-in-use');

    await cubit.registerPatient(
      name: 'Patient',
      email: 'p@test.com',
      password: '123456',
      phone: '0100000000',
    );

    expect(cubit.state, isA<AuthErrorState>());
  });
}
