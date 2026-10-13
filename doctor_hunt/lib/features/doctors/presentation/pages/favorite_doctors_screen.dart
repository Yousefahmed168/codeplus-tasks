import '../../../../core/widgets/app_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../i18n/strings.g.dart';
import '../cubit/favorite_cubit.dart';
import '../cubit/favorite_state.dart';

class FavoriteDoctorsScreen extends StatelessWidget {
  const FavoriteDoctorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final patientUid = sl<AuthService>().currentUser?.uid;

    if (patientUid == null) {
      return AppBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Text(
              t.favorite.pleaseLogin,
              style: context.regular14.textSecondary,
            ),
          ),
        ),
      );
    }

    return BlocProvider(
      create: (context) => FavoriteCubit()..loadFavorites(),
      child: AppBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leadingWidth: 64.w,
            title: Text(
              t.home.favouriteDoctors,
              style: context.bold.px20.textPrimary,
            ),
            centerTitle: false,
          ),
          body: BlocBuilder<FavoriteCubit, FavoriteState>(
            builder: (context, state) {
              if (state is FavoriteLoading || state is FavoriteInitial) {
                return ListView.separated(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 10.h,
                  ),
                  itemCount: 4,
                  separatorBuilder: (context, index) => 16.verticalSpace,
                  itemBuilder: (context, index) => Shimmer.fromColors(
                    baseColor: AppColors.border.withValues(alpha: 0.3),
                    highlightColor: AppColors.surface,
                    child: Container(
                      height: 104.h,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                  ),
                );
              }
              if (state is FavoriteError) {
                return Center(
                  child: Text(
                    state.message,
                    style: context.regular14.textSecondary,
                  ),
                );
              }
              if (state is FavoriteLoaded) {
                final favoriteDoctors = state.favoriteDoctors;

                if (favoriteDoctors.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite_border_rounded,
                          size: 64.r,
                          color: AppColors.textHint,
                        ),
                        16.verticalSpace,
                        Text(
                          t.favorite.noFavoriteDoctors,
                          style: context.regular16.textSecondary,
                        ),
                        8.verticalSpace,
                        Text(
                          t.favorite.tapHeartHint,
                          style: context.regular14.textHint,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 10.h,
                  ),
                  itemCount: favoriteDoctors.length,
                  separatorBuilder: (context, index) => 16.verticalSpace,
                  itemBuilder: (context, index) {
                    final doctor = favoriteDoctors[index];
                    final hasImage =
                        doctor.imageUrl != null && doctor.imageUrl!.isNotEmpty;

                    return GestureDetector(
                      onTap: () {
                        context.push(AppRoutes.doctorDetails, extra: doctor);
                      },
                      child: Container(
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.textPrimary.withValues(
                                alpha: 0.05,
                              ),
                              blurRadius: 10.r,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: hasImage
                                  ? CachedNetworkImage(
                                      imageUrl: doctor.imageUrl!,
                                      width: 80.r,
                                      height: 80.r,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          Shimmer.fromColors(
                                        baseColor: AppColors.border
                                            .withValues(alpha: 0.3),
                                        highlightColor: AppColors.surface,
                                        child: Container(
                                          width: 80.r,
                                          height: 80.r,
                                          color: AppColors.surface,
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                        AppImages.doctor,
                                        width: 80.r,
                                        height: 80.r,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Image.asset(
                                      AppImages.doctor,
                                      width: 80.r,
                                      height: 80.r,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            16.horizontalSpace,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    doctor.name ?? 'Doctor',
                                    style: context.bold16.textPrimary,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  4.verticalSpace,
                                  Text(
                                    doctor.specialization ?? 'Specialist',
                                    style: context.regular14.textSecondary,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                final doctorName = doctor.name ?? 'Doctor';

                                await context
                                    .read<FavoriteCubit>()
                                    .removeFavorite(doctor.uid!);

                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      t.favorite.doctorRemoved(
                                        doctorName: doctorName,
                                      ),
                                    ),
                                    action: SnackBarAction(
                                      label: t.common.undo,
                                      textColor: AppColors.background,
                                      onPressed: () {
                                        context
                                            .read<FavoriteCubit>()
                                            .addFavorite(doctor.uid!);
                                      },
                                    ),
                                    duration: const Duration(seconds: 3),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                  ),
                                );
                              },
                              child: Icon(
                                Icons.favorite_rounded,
                                color: AppColors.error,
                                size: 20.r,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
