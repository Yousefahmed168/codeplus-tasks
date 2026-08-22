import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/register_screen.dart';
import '../../features/doctors/models/doctor_model.dart';
import '../../features/doctors/presentation/pages/doctor_details_screen.dart';
import '../../features/home/presentation/pages/home_screen.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/role/choose_role.dart';
import '../../features/search/presentation/pages/find_doctor.dart';
import '../../features/splash/splash_screen.dart';


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
}

// Route tree

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
      pageBuilder: (context, state) =>
          _slidePage(key: state.pageKey, child: const RegisterScreen()),
    ),
    GoRoute(
      path: AppRoutes.home,
      pageBuilder: (context, state) =>
          _slidePage(key: state.pageKey, child: const HomeScreen()),
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
