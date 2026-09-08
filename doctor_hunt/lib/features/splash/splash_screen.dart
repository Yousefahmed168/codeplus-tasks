import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import '../../core/theme/style_atoms.dart';
import 'package:go_router/go_router.dart';

import '../../core/routes/app_routes.dart';
import '../../core/services/auth_service.dart';
import '../../core/utils/app_images.dart';
import '../../core/widgets/widgets.dart';
import '../../i18n/strings.g.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final currentUser = AuthService.instance.currentUser;
    if (currentUser == null) {
      // Not logged in → go to role selection (which leads to login/register)
      context.go(AppRoutes.role);
    } else {
      // Logged in → check role
      final role = await AuthService.instance.getUserRole(currentUser.uid);
      if (!mounted) return;

      if (role == null) {
        context.go(AppRoutes.role);
      } else if (role.name == 'admin') {
        context.go(AppRoutes.adminMain);
      } else if (role.name == 'doctor') {
        context.go(AppRoutes.doctorDashboard);
      } else {
        context.go(AppRoutes.home);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              child: SvgPicture.asset(AppImages.logo, width: 56, height: 56),
            ),
            Text(t.common.appName, style: context.bold24.textPrimary),
          ],
        ),
      ),
    );
  }
}
