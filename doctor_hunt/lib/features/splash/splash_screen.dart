import '../../core/utils/app_images.dart';
import '../../i18n/strings.g.dart';
import '../../core/widgets/widgets.dart';
import '../../core/theme/style_atoms.dart';
import '../../core/routes/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

  void _navigateToNext() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.go(AppRoutes.home);
      }
    });
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
