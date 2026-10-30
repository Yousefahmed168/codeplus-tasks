import 'package:doctor_hunt/core/enums/user_role.dart';
import 'package:doctor_hunt/core/routes/app_routes.dart';
import 'package:doctor_hunt/core/routes/route_guard.dart';
import 'package:doctor_hunt/core/routes/session_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  String? redirect(String location, SessionStatus status, UserRole? role) =>
      RouteGuard.resolveRedirect(
        location: location,
        status: status,
        role: role,
      );

  group('unauthenticated session', () {
    test('can reach public routes', () {
      for (final route in [
        AppRoutes.splash,
        AppRoutes.onboarding,
        AppRoutes.role,
        AppRoutes.login,
        AppRoutes.register,
        AppRoutes.adminLogin,
      ]) {
        expect(
          redirect(route, SessionStatus.unauthenticated, null),
          isNull,
          reason: route,
        );
      }
    });

    test('is sent to the patient login for patient routes', () {
      expect(
        redirect(AppRoutes.home, SessionStatus.unauthenticated, null),
        AppRoutes.login,
      );
      expect(
        redirect(AppRoutes.selectTime, SessionStatus.unauthenticated, null),
        AppRoutes.login,
      );
    });

    test('is sent to the admin login for admin routes', () {
      expect(
        redirect(AppRoutes.adminMain, SessionStatus.unauthenticated, null),
        AppRoutes.adminLogin,
      );
      expect(
        redirect(AppRoutes.createDoctor, SessionStatus.unauthenticated, null),
        AppRoutes.adminLogin,
      );
    });
  });

  group('patient session', () {
    test('can reach patient routes', () {
      expect(
        redirect(AppRoutes.home, SessionStatus.authenticated, UserRole.patient),
        isNull,
      );
      expect(
        redirect(
          AppRoutes.patientProfile,
          SessionStatus.authenticated,
          UserRole.patient,
        ),
        isNull,
      );
      expect(
        redirect(
          AppRoutes.patientAppointments,
          SessionStatus.authenticated,
          UserRole.patient,
        ),
        isNull,
      );
    });

    test('is blocked from every admin route', () {
      expect(
        redirect(
          AppRoutes.adminMain,
          SessionStatus.authenticated,
          UserRole.patient,
        ),
        AppRoutes.home,
      );
      expect(
        redirect(
          AppRoutes.adminDoctors,
          SessionStatus.authenticated,
          UserRole.patient,
        ),
        AppRoutes.home,
      );
    });

    test('is moved away from the auth screens once signed in', () {
      expect(
        redirect(
          AppRoutes.login,
          SessionStatus.authenticated,
          UserRole.patient,
        ),
        AppRoutes.home,
      );
      expect(
        redirect(
          AppRoutes.adminLogin,
          SessionStatus.authenticated,
          UserRole.patient,
        ),
        AppRoutes.home,
      );
    });
  });

  group('admin session', () {
    test('can reach admin routes', () {
      expect(
        redirect(
          AppRoutes.adminMain,
          SessionStatus.authenticated,
          UserRole.admin,
        ),
        isNull,
      );
      expect(
        redirect(
          AppRoutes.adminAppointmentDetails,
          SessionStatus.authenticated,
          UserRole.admin,
        ),
        isNull,
      );
    });

    test('is blocked from patient routes', () {
      expect(
        redirect(AppRoutes.home, SessionStatus.authenticated, UserRole.admin),
        AppRoutes.adminMain,
      );
      expect(
        redirect(
          AppRoutes.patientProfile,
          SessionStatus.authenticated,
          UserRole.admin,
        ),
        AppRoutes.adminMain,
      );
    });

    test('is moved away from both login screens once signed in', () {
      expect(
        redirect(
          AppRoutes.adminLogin,
          SessionStatus.authenticated,
          UserRole.admin,
        ),
        AppRoutes.adminMain,
      );
      expect(
        redirect(AppRoutes.login, SessionStatus.authenticated, UserRole.admin),
        AppRoutes.adminMain,
      );
    });
  });

  test(
    'authenticated user without a resolved role is sent to role selection',
    () {
      expect(
        redirect(AppRoutes.home, SessionStatus.authenticated, null),
        AppRoutes.role,
      );
    },
  );

  test('change password is reachable by both roles', () {
    expect(
      redirect(
        AppRoutes.changePassword,
        SessionStatus.authenticated,
        UserRole.patient,
      ),
      isNull,
    );
    expect(
      redirect(
        AppRoutes.changePassword,
        SessionStatus.authenticated,
        UserRole.admin,
      ),
      isNull,
    );
    expect(
      redirect(AppRoutes.changePassword, SessionStatus.unauthenticated, null),
      AppRoutes.login,
    );
  });

  test('appointment details is shared by patient and admin', () {
    expect(
      redirect(
        AppRoutes.adminAppointmentDetails,
        SessionStatus.authenticated,
        UserRole.patient,
      ),
      isNull,
    );
    expect(
      redirect(
        AppRoutes.adminAppointmentDetails,
        SessionStatus.authenticated,
        UserRole.admin,
      ),
      isNull,
    );
  });

  test('unknown session does not redirect away from the splash', () {
    expect(redirect(AppRoutes.splash, SessionStatus.unknown, null), isNull);
  });

  test('routes with a required payload have a role-aware fallback', () {
    expect(
      RouteGuard.extraRequiredRoutes.contains(AppRoutes.selectTime),
      isTrue,
    );
    expect(
      RouteGuard.extraRequiredRoutes.contains(AppRoutes.adminDoctorDetails),
      isTrue,
    );
    expect(RouteGuard.fallbackFor(UserRole.patient), AppRoutes.search);
    expect(RouteGuard.fallbackFor(UserRole.admin), AppRoutes.adminDoctors);
  });
}
