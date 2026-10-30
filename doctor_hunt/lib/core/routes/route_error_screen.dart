import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../constants/my_icons.dart';
import '../di/service_locator.dart';
import '../enums/user_role.dart';
import '../theme/colors.dart';
import '../theme/style_atoms.dart';
import '../widgets/main_button.dart';
import '../../i18n/strings.g.dart';
import 'app_routes.dart';
import 'session_controller.dart';

/// Shown when the router cannot resolve a location or its payload is missing.
class RouteErrorScreen extends StatelessWidget {
  const RouteErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final role = sl<SessionController>().role;
    final destination = role == UserRole.admin
        ? AppRoutes.adminMain
        : AppRoutes.home;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24.r),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  MyIcons.errorOutlineRounded,
                  size: 56.r,
                  color: AppColors.error,
                ),
                16.verticalSpace,
                Text(
                  t.common.errorGeneric,
                  textAlign: TextAlign.center,
                  style: context.regular16.textPrimary,
                ),
                24.verticalSpace,
                MainButton(
                  text: t.common.continueBtn,
                  onPressed: () => context.go(destination),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
