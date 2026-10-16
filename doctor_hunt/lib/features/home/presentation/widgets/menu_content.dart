import '../../../../core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../../core/theme/style_atoms.dart';
import '../../../../../i18n/strings.g.dart';
import '../../../../../core/services/auth_service.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../../../core/routes/app_routes.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../pages/drawer_screen.dart';
import '../../../auth/presentation/widgets/logout_dialog.dart';
import '../../../../core/constants/my_icons.dart';

class MenuContent extends StatelessWidget {
  const MenuContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..loadHomeData(),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          String? name;
          String? imageUrl;
          String? phone;

          if (state is HomeLoaded) {
            name = state.patient?.name;
            imageUrl = state.patient?.image;
            phone = state.patient?.phone;
          }
          final userName = name?.isNotEmpty == true ? name! : 'Patient User';
          final userPhone = phone?.isNotEmpty == true ? phone! : '';

          return SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                left: 24.w,
                top: 40.h,
                bottom: 40.h,
                right: 16.w,
              ),
              child: SizedBox(
                width: 0.65.sw,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Row
                    Row(
                      children: [
                        Container(
                          width: 50.r,
                          height: 50.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.textOnPrimary, width: 2.w),
                          ),
                          child: ClipOval(
                            child: imageUrl != null && imageUrl.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: imageUrl,
                                    fit: BoxFit.cover,
                                  )
                                : Icon(
                                    MyIcons.personRounded,
                                    color: AppColors.textOnPrimary,
                                    size: 32.r,
                                  ),
                          ),
                        ),
                        12.horizontalSpace,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userName,
                                style: context.bold16.copyWith(
                                  color: AppColors.textOnPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (userPhone.isNotEmpty) ...[
                                4.verticalSpace,
                                Row(
                                  children: [
                                    Icon(
                                      MyIcons.phoneRounded,
                                      color: AppColors.textOnPrimary,
                                      size: 14.r,
                                    ),
                                    4.horizontalSpace,
                                    Expanded(
                                      child: Text(
                                        userPhone,
                                        style: context.regular12.copyWith(
                                          color: AppColors.textOnPrimary,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                    60.verticalSpace,
                    // Menu Items
                    _MenuItem(
                      icon: MyIcons.accountCircleRounded,
                      title: t.menu.profile,
                      onTap: () {
                        DrawerScreen.of(context)?.closeDrawer();
                        context.push(AppRoutes.patientProfile);
                      },
                    ),
                    _MenuItem(
                      icon: MyIcons.personRounded,
                      title: t.menu.home,
                      onTap: () {
                        DrawerScreen.of(context)?.closeDrawer();
                      },
                    ),
                    _MenuItem(
                      icon: MyIcons.favoriteRounded,
                      title: t.menu.favourites,
                      onTap: () {
                        DrawerScreen.of(context)?.closeDrawer();
                        context.push(AppRoutes.favoriteDoctors);
                      },
                    ),
                    _MenuItem(
                      icon: MyIcons.calendarMonthRounded,
                      title: t.menu.myAppointments,
                      onTap: () {
                        DrawerScreen.of(context)?.closeDrawer();
                        context.push(AppRoutes.patientAppointments);
                      },
                    ),
                    _MenuItem(
                      icon: MyIcons.settingsRounded,
                      title: t.menu.settings,
                      onTap: () {
                        DrawerScreen.of(context)?.closeDrawer();
                        context.push(AppRoutes.patientSettings);
                      },
                    ),
                    const Spacer(),
                    // Logout
                    InkWell(
                      onTap: () async {
                        final confirmed = await LogoutDialog.show(context);
                        if (confirmed == true) {
                          if (!context.mounted) return;
                          DrawerScreen.of(context)?.closeDrawer();
                          await sl<AuthService>().logout();
                          if (context.mounted) {
                            context.go(AppRoutes.role);
                          }
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: Row(
                          children: [
                            Icon(
                              MyIcons.logoutRounded,
                              color: AppColors.textOnPrimary,
                              size: 24.r,
                            ),
                            16.horizontalSpace,
                            Text(
                              t.menu.logout,
                              style: context.bold18.copyWith(
                                color: AppColors.textOnPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Row(
          children: [
            Icon(icon, color: AppColors.background, size: 24.r),
            16.horizontalSpace,
            Expanded(
              child: Text(
                title,
                style: context.bold16.copyWith(color: AppColors.background),
              ),
            ),
            Icon(
              MyIcons.chevronRightRounded,
              color: AppColors.background,
              size: 24.r,
            ),
            16.horizontalSpace,
          ],
        ),
      ),
    );
  }
}
