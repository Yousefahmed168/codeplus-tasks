import '../../../../core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
          final userName = name?.isNotEmpty == true ? name! : 'Abdullah Mamun';
          final userPhone = phone?.isNotEmpty == true ? phone! : '01303-527300';

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 24,
                top: 40,
                bottom: 40,
                right: 16,
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.65,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Row
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: ClipOval(
                            child: imageUrl != null && imageUrl.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: imageUrl,
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(
                                    Icons.person_rounded,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                          ),
                        ),
                        const Gap(12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userName,
                                style: context.bold16.copyWith(
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Gap(4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.phone_rounded,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                  const Gap(4),
                                  Expanded(
                                    child: Text(
                                      userPhone,
                                      style: context.regular12.copyWith(
                                        color: Colors.white,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Gap(60),
                    // Menu Items
                    _MenuItem(
                      icon: Icons.person_rounded,
                      title: t.menu.home,
                      onTap: () {
                        DrawerScreen.of(context)?.closeDrawer();
                      },
                    ),
                    _MenuItem(
                      icon: Icons.favorite_rounded,
                      title: t.menu.favourites,
                      onTap: () {
                        DrawerScreen.of(context)?.closeDrawer();
                        context.push(AppRoutes.favoriteDoctors);
                      },
                    ),
                    _MenuItem(
                      icon: Icons.calendar_month_rounded,
                      title: t.menu.myAppointments,
                      onTap: () {
                        DrawerScreen.of(context)?.closeDrawer();
                        context.push(AppRoutes.patientAppointments);
                      },
                    ),
                    _MenuItem(
                      icon: Icons.settings_rounded,
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
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.logout_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                            const Gap(16),
                            Text(
                              t.menu.logout,
                              style: context.bold18.copyWith(
                                color: Colors.white,
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
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: AppColors.background, size: 24),
            const Gap(16),
            Expanded(
              child: Text(
                title,
                style: context.bold16.copyWith(color: AppColors.background),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.background,
              size: 24,
            ),
            const Gap(16),
          ],
        ),
      ),
    );
  }
}
