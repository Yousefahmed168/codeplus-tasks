import '../enums/user_role.dart';
import 'app_routes.dart';
import 'session_controller.dart';

/// Pure navigation policy, kept separate from `GoRouter` so it can be unit
/// tested without Firebase or a widget tree.
abstract final class RouteGuard {
  RouteGuard._();

  /// Routes reachable without a resolved session.
  static const Set<String> publicRoutes = {
    AppRoutes.splash,
    AppRoutes.onboarding,
    AppRoutes.role,
    AppRoutes.login,
    AppRoutes.register,
    AppRoutes.adminLogin,
  };

  /// Routes shared by every signed-in role.
  static const Set<String> anyRoleRoutes = {
    AppRoutes.changePassword,
    // Appointment details is pushed by the patient list too (isAdminView: false).
    AppRoutes.adminAppointmentDetails,
  };

  /// Routes that read their payload from `state.extra`; a cold deep link does
  /// not carry it, so the router sends the user to a safe fallback instead.
  static const Set<String> extraRequiredRoutes = {
    AppRoutes.doctorDetails,
    AppRoutes.selectTime,
    AppRoutes.reviewAppointment,
    AppRoutes.editDoctor,
    AppRoutes.adminDoctorDetails,
    AppRoutes.adminDoctorAvailability,
  };

  static bool isAdminRoute(String path) =>
      path.startsWith('/admin') && path != AppRoutes.adminLogin;

  /// Returns the location to redirect to, or `null` when navigation may
  /// proceed.
  static String? resolveRedirect({
    required String location,
    required SessionStatus status,
    required UserRole? role,
  }) {
    final path = Uri.parse(location).path;
    final isPublic = publicRoutes.contains(path);
    final isAdmin = isAdminRoute(path);

    // The splash screen owns the very first navigation once the session is
    // resolved; never fight it with a redirect.
    if (status == SessionStatus.unknown) return null;

    if (status == SessionStatus.unauthenticated) {
      if (isPublic) return null;
      return isAdmin ? AppRoutes.adminLogin : AppRoutes.login;
    }

    // Authenticated, role may still be unknown while Firestore resolves.
    if (path == AppRoutes.adminLogin) {
      if (role == null) return null;
      return role == UserRole.admin ? AppRoutes.adminMain : AppRoutes.home;
    }
    if (path == AppRoutes.login || path == AppRoutes.register) {
      if (role == null) return null;
      return role == UserRole.admin ? AppRoutes.adminMain : AppRoutes.home;
    }
    if (role == null) {
      return isPublic ? null : AppRoutes.role;
    }
    if (anyRoleRoutes.contains(path)) return null;
    if (role == UserRole.admin) {
      return isAdmin ? null : AppRoutes.adminMain;
    }
    // Patients (and the unused doctor role) never reach admin screens.
    return isAdmin ? AppRoutes.home : null;
  }

  /// Fallback used when an `extra`-backed route is opened without its payload.
  static String fallbackFor(UserRole? role) =>
      role == UserRole.admin ? AppRoutes.adminDoctors : AppRoutes.search;
}
