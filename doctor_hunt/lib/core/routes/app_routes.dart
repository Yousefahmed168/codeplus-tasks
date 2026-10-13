import '../../features/patient_profile/presentation/pages/help_center_screen.dart';
import '../../features/patient_profile/presentation/pages/patient_profile_screen.dart';
import '../../features/patient_profile/presentation/pages/patient_settings_screen.dart';
import '../../features/patient_profile/presentation/pages/privacy_policy_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/appointments/views/appointments_screen.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/register_screen.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/doctors/models/doctor.dart';
import '../../features/doctors/presentation/pages/doctor_details_screen.dart';
import '../../features/doctors/presentation/pages/select_time_screen.dart';
import '../../features/doctors/presentation/pages/favorite_doctors_screen.dart';
import '../../features/home/presentation/pages/drawer_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/role/choose_role.dart';
import '../../features/search/presentation/pages/find_doctor.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/admin/presentation/pages/admin_login_screen.dart';
import '../../features/admin/presentation/pages/admin_main_screen.dart';
import '../../features/admin/presentation/pages/admin_doctors_screen.dart';
import '../../features/admin/presentation/pages/admin_doctor_details_screen.dart';
import '../../features/admin/presentation/pages/admin_doctor_availability_screen.dart';
import '../../features/admin/presentation/pages/create_doctor_screen.dart';
import '../../features/admin/presentation/pages/edit_doctor_screen.dart';
import '../../features/admin/presentation/pages/edit_admin_profile_screen.dart';
import '../../features/auth/presentation/pages/change_password_screen.dart';
import '../../features/admin/presentation/pages/admin_appointment_details_screen.dart';

class AppRoutes {
  AppRoutes._();
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String role = '/role';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String doctorDetails = '/doctor-details';
  static const String search = '/search';
  static const String selectTime = '/select-time';
  static const String updateDoctorProfile = '/update-doctor-profile';
  static const String patientSettings = '/patient-settings';
  static const String privacyPolicy = '/privacy-policy';
  static const String helpCenter = '/help-center';
  static const String patientAppointments = '/patient-appointments';
  static const String favoriteDoctors = '/favorite-doctors';
  static const String patientProfile = '/profile';

  // Admin routes
  static const String adminLogin = '/admin/login';
  static const String adminMain = '/admin/main';
  static const String adminDoctors = '/admin/doctors';
  static const String createDoctor = '/admin/create-doctor';
  static const String editDoctor = '/admin/edit-doctor';
  static const String adminSettings = '/admin/settings';
  static const String adminDoctorDetails = '/admin/doctor-details';
  static const String adminDoctorAvailability = '/admin/doctor-availability';
  static const String editAdminProfile = '/admin/edit-profile';
  static const String changePassword = '/change-password';
  static const String adminAppointmentDetails = '/admin/appointment-details';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      pageBuilder: (context, state) =>
          _slidePage(key: state.pageKey, child: const SplashScreen()),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      pageBuilder: (context, state) =>
          _slidePage(key: state.pageKey, child: const OnboardingScreen()),
    ),
    GoRoute(
      path: AppRoutes.role,
      pageBuilder: (context, state) =>
          _slidePage(key: state.pageKey, child: const ChooseRoleScreen()),
    ),
    GoRoute(
      path: AppRoutes.login,
      pageBuilder: (context, state) => _slidePage(
        key: state.pageKey,
        child: BlocProvider(
          create: (_) => AuthCubit(),
          child: const LoginScreen(),
        ),
      ),
    ),
    GoRoute(
      path: AppRoutes.register,
      pageBuilder: (context, state) {
        final role = state.extra as String?;
        return _slidePage(
          key: state.pageKey,
          child: BlocProvider(
            create: (_) => AuthCubit(),
            child: RegisterScreen(role: role),
          ),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.home,
      pageBuilder: (context, state) =>
          _slidePage(key: state.pageKey, child: const DrawerScreen()),
    ),

    GoRoute(
      path: AppRoutes.doctorDetails,
      pageBuilder: (context, state) {
        final doctor = state.extra as Doctor;
        return _slidePage(
          key: state.pageKey,
          child: DoctorDetailsScreen(doctor: doctor),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.search,
      pageBuilder: (context, state) =>
          _slidePage(key: state.pageKey, child: const FindDoctorScreen()),
    ),
    GoRoute(
      path: AppRoutes.selectTime,
      pageBuilder: (context, state) {
        final doctor = state.extra as Doctor;
        return _slidePage(
          key: state.pageKey,
          child: SelectTimeScreen(doctor: doctor),
        );
      },
    ),
    
    GoRoute(
      path: AppRoutes.patientSettings,
      pageBuilder: (context, state) =>
          _slidePage(key: state.pageKey, child: const PatientSettingsScreen()),
    ),
    GoRoute(
      path: AppRoutes.privacyPolicy,
      pageBuilder: (context, state) =>
          _slidePage(key: state.pageKey, child: const PrivacyPolicyScreen()),
    ),
    GoRoute(
      path: AppRoutes.helpCenter,
      pageBuilder: (context, state) =>
          _slidePage(key: state.pageKey, child: const HelpCenterScreen()),
    ),
    GoRoute(
      path: AppRoutes.favoriteDoctors,
      pageBuilder: (context, state) =>
          _slidePage(key: state.pageKey, child: const FavoriteDoctorsScreen()),
    ),
    GoRoute(
      path: AppRoutes.patientAppointments,
      pageBuilder: (context, state) =>
          _slidePage(key: state.pageKey, child: const AppointmentsScreen()),
    ),
    GoRoute(
      path: AppRoutes.patientProfile,
      pageBuilder: (context, state) =>
          _slidePage(key: state.pageKey, child: const PatientProfileScreen()),
    ),

    // Admin routes
    GoRoute(
      path: AppRoutes.adminLogin,
      pageBuilder: (context, state) =>
          _slidePage(key: state.pageKey, child: const AdminLoginScreen()),
    ),
    GoRoute(
      path: AppRoutes.adminMain,
      pageBuilder: (context, state) =>
          _slidePage(key: state.pageKey, child: const AdminMainScreen()),
    ),
    GoRoute(
      path: AppRoutes.adminDoctors,
      pageBuilder: (context, state) =>
          _slidePage(key: state.pageKey, child: const AdminDoctorsScreen()),
    ),
    GoRoute(
      path: AppRoutes.createDoctor,
      pageBuilder: (context, state) =>
          _slidePage(key: state.pageKey, child: const CreateDoctorScreen()),
    ),
    GoRoute(
      path: AppRoutes.editDoctor,
      pageBuilder: (context, state) {
        final doctor = state.extra as dynamic;
        return _slidePage(
          key: state.pageKey,
          child: EditDoctorScreen(doctor: doctor),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.adminDoctorDetails,
      pageBuilder: (context, state) {
        final doctor = state.extra as Doctor;
        return _slidePage(
          key: state.pageKey,
          child: AdminDoctorDetailsScreen(doctor: doctor),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.adminDoctorAvailability,
      pageBuilder: (context, state) {
        final doctor = state.extra as Doctor;
        return _slidePage(
          key: state.pageKey,
          child: AdminDoctorAvailabilityScreen(doctor: doctor),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.editAdminProfile,
      pageBuilder: (context, state) =>
          _slidePage(key: state.pageKey, child: const EditAdminProfileScreen()),
    ),
    GoRoute(
      path: AppRoutes.changePassword,
      pageBuilder: (context, state) =>
          _slidePage(key: state.pageKey, child: const ChangePasswordScreen()),
    ),
    GoRoute(
      path: AppRoutes.adminAppointmentDetails,
      pageBuilder: (context, state) {
        return _slidePage(
          key: state.pageKey,
          child: AdminAppointmentDetailsScreen(),
        );
      },
    ),
  ],
);

CustomTransitionPage<void> _slidePage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOutCubic;
      final tween = Tween(
        begin: begin,
        end: end,
      ).chain(CurveTween(curve: curve));
      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}
