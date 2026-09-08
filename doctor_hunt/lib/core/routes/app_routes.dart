import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/register_screen.dart';
import '../../features/auth/presentation/pages/update_doctor_profile_screen.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/dashboard/presentation/pages/doctor_dashboard_screen.dart';
import '../../features/doctors/models/doctor.dart';
import '../../features/doctors/presentation/pages/doctor_details_screen.dart';
import '../../features/doctors/presentation/pages/select_time_screen.dart';
import '../../features/home/presentation/pages/main_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/role/choose_role.dart';
import '../../features/search/presentation/pages/find_doctor.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/admin/presentation/pages/admin_login_screen.dart';
import '../../features/admin/presentation/pages/admin_main_screen.dart';
import '../../features/admin/presentation/pages/admin_doctors_screen.dart';
import '../../features/admin/presentation/pages/create_doctor_screen.dart';
import '../../features/admin/presentation/pages/edit_doctor_screen.dart';

class AppRoutes {
  AppRoutes._();
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String role = '/role';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String doctorDashboard = '/doctor-dashboard';
  static const String doctorDetails = '/doctor-details';
  static const String search = '/search';
  static const String selectTime = '/select-time';
  static const String updateDoctorProfile = '/update-doctor-profile';
  // Admin routes
  static const String adminLogin = '/admin/login';
  static const String adminMain = '/admin/main';
  static const String adminDoctors = '/admin/doctors';
  static const String createDoctor = '/admin/create-doctor';
  static const String editDoctor = '/admin/edit-doctor';
  static const String adminSettings = '/admin/settings';
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
      pageBuilder: (context, state) =>
          _slidePage(key: state.pageKey, child: const LoginScreen()),
    ),
    GoRoute(
      path: AppRoutes.register,
      pageBuilder: (context, state) {
        final role = state.extra as String?;
        return _slidePage(
          key: state.pageKey,
          child: RegisterScreen(role: role),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.home,
      pageBuilder: (context, state) =>
          _slidePage(key: state.pageKey, child: const MainScreen()),
    ),
    GoRoute(
      path: AppRoutes.doctorDashboard,
      pageBuilder: (context, state) =>
          _slidePage(key: state.pageKey, child: const DoctorDashboardScreen()),
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
      path: AppRoutes.updateDoctorProfile,
      pageBuilder: (context, state) => _slidePage(
        key: state.pageKey,
        child: BlocProvider(
          create: (_) => AuthCubit()..loadCurrentProfile(),
          child: const UpdateDoctorProfileScreen(),
        ),
      ),
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
