import '../../../../core/routes/app_routes.dart';
import '../../../../core/widgets/custom_text_form_field.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../pages/drawer_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/utils/app_images.dart';
import 'package:go_router/go_router.dart';
import '../../../../../i18n/strings.g.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../../../../core/constants/my_icons.dart';

class HomeHeader extends StatelessWidget {
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onClearSearch;
  final VoidCallback? onSearchTap;
  final VoidCallback? onAvatarTap;

  const HomeHeader({
    super.key,
    this.searchController,
    this.onSearchChanged,
    this.onClearSearch,
    this.onSearchTap,
    this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        String? name;
        String? imageUrl;
        bool hasImage = false;

        if (state is HomeLoaded) {
          name = state.patient?.name;
          imageUrl = state.patient?.image;
          hasImage = imageUrl != null && imageUrl.isNotEmpty;
        }

        final firstName = name?.split(' ').first ?? '';

        return Stack(
          clipBehavior: Clip.none,
          children: [
            // Top curved green container
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                left: 20.w,
                right: 20.w,
                top: 50.h,
                bottom: 45.h,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withValues(alpha: 0.7),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24.r),
                  bottomRight: Radius.circular(24.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () => DrawerScreen.of(context)?.toggleDrawer(),
                        child: Icon(
                          MyIcons.menuRounded,
                          color: AppColors.textOnPrimary,
                          size: 28.r,
                        ),
                      ),
                      12.horizontalSpace,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            firstName.isNotEmpty
                                ? t.home.greeting(name: firstName)
                                : t.home.findYourDoctor,
                            style: context.bold24.copyWith(
                              color: AppColors.textOnPrimary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // User Avatar — taps to open profile tab
                  GestureDetector(
                    onTap: onAvatarTap,
                    child: Container(
                      width: 48.r,
                      height: 48.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.textOnPrimary, width: 2.w),
                      ),
                      child: ClipOval(
                        child: hasImage && imageUrl!.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: imageUrl,
                                fit: BoxFit.cover,
                                placeholder: (_, _) => Container(
                                  color: AppColors.textOnPrimary.withValues(alpha: 0.3),
                                  child: Icon(
                                    MyIcons.personRounded,
                                    color: AppColors.textOnPrimary,
                                    size: 26.r,
                                  ),
                                ),
                              )
                            : Image.asset(AppImages.doctor, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Floating Search Bar
            Positioned(
              left: 20.w,
              right: 20.w,
              bottom: -24.h,
              child: CustomTextFormField(
                suffixIcon: GestureDetector(
                  onTap: onClearSearch,
                  child: Icon(
                    MyIcons.closeRounded,
                    color: AppColors.textSecondary,
                    size: 20.r,
                  ),
                ),
                prefixIcon: Icon(
                  MyIcons.searchRounded,
                  color: AppColors.success,
                  size: 16.r,
                ),
                controller: searchController,
                onChange: onSearchChanged,
                textInputAction: TextInputAction.search,
                hintText: t.home.searchHint,
                onTap: () {
                  context.go(AppRoutes.search);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
