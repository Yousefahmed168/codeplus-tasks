import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/service_locator.dart';
import '../../core/routes/app_routes.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/local/shared_pref.dart';
import '../../core/theme/style_atoms.dart';
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

    final currentUser = sl<AuthService>().currentUser;
    if (currentUser == null) {
      // First launch → onboarding; afterwards → role selection.
      context.go(
        SharedPref.isOnboardingShown() ? AppRoutes.role : AppRoutes.onboarding,
      );
    } else {
      // Logged in → check role
      final role = await sl<AuthService>().getUserRole(currentUser.uid);
      if (!mounted) return;

      if (role == null) {
        context.go(AppRoutes.role);
      } else if (role.name == 'admin') {
        context.go(AppRoutes.adminMain);
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
              padding: EdgeInsets.all(18.r),
              child: SvgPicture.asset(AppImages.logo, width: 56.r, height: 56.r),
            ),
            Text(t.common.appName, style: context.bold24.textPrimary),
          ],
        ),
      ),
    );
  }
}
