import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/constants/assets.dart';
import '../../../../core/models/doctor.dart';
import '../widgets/home_header.dart';
import '../widgets/live_doctor_card.dart';
import '../widgets/category_card.dart';
import '../widgets/popular_doctor_card.dart';
import '../widgets/feature_doctor_card.dart';
import '../../../../i18n/strings.g.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../../../../core/utils/snack_bar_helper.dart';
import '../../../../core/widgets/doctor_shimmer.dart';
import '../../../../core/constants/my_icons.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onAvatarTap;
  const HomeScreen({super.key, this.onAvatarTap});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..loadHomeData(),
      child: Scaffold(
        backgroundColor: AppColors.transparent,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeHeader(
                    searchController: _searchController,
                    onClearSearch: () => _searchController.clear(),
                    onSearchTap: () => context.go(AppRoutes.search),
                    onAvatarTap: widget.onAvatarTap,
                  ),
                  36.verticalSpace,
                  _buildSectionHeader(
                    title: t.home.liveDoctors,
                    showSeeAll: true,
                  ),
                  12.verticalSpace,
                  SizedBox(
                    height: 160.h,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      children: const [
                        LiveDoctorCard(imagePath: AppImages.doctor1),
                        LiveDoctorCard(imagePath: AppImages.doctor2),
                        LiveDoctorCard(imagePath: AppImages.doctor3),
                        LiveDoctorCard(imagePath: AppImages.doctor),
                      ],
                    ),
                  ),
                  24.verticalSpace,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      children: [
                        CategoryCard(
                          svgAssetPath: Assets.resourceIconsDentist,
                          gradientColors: [
                            AppColors.info,
                            AppColors.info.withValues(alpha: 0.7),
                          ],
                        ),
                        CategoryCard(
                          iconData: MyIcons.favoriteRounded,
                          gradientColors: [
                            AppColors.success,
                            AppColors.success.withValues(alpha: 0.7),
                          ],
                        ),
                        CategoryCard(
                          svgAssetPath: Assets.resourceIconsEye,
                          gradientColors: [
                            AppColors.warning,
                            AppColors.warning.withValues(alpha: 0.6),
                          ],
                        ),
                        CategoryCard(
                          iconData: MyIcons.wcRounded,
                          gradientColors: [
                            AppColors.error,
                            AppColors.error.withValues(alpha: 0.5),
                          ],
                        ),
                      ],
                    ),
                  ),
                  24.verticalSpace,

                  // Popular Doctors (using BlocBuilder)
                  BlocBuilder<HomeCubit, HomeState>(
                    builder: (context, state) {
                      if (state is HomeLoading) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionHeader(
                              title: t.home.popularDoctor,
                              showSeeAll: true,
                            ),
                            12.verticalSpace,
                            SizedBox(
                              height: 220.h,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                itemCount: 3,
                                separatorBuilder: (_, _) => 14.horizontalSpace,
                                itemBuilder: (_, _) => const DoctorCardShimmer(),
                              ),
                            ),
                          ],
                        );
                      }
                      if (state is HomeError) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 40.h),
                          child: Center(
                            child: Text(
                              state.message,
                              style: context.regular14.textSecondary,
                            ),
                          ),
                        );
                      }

                      if (state is HomeLoaded) {
                        final doctors = state.doctors;
                        if (doctors.isEmpty) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 40.h),
                            child: Center(
                              child: Text(
                                t.home.noDoctorsAvailableYet,
                                style: context.regular14.textSecondary,
                              ),
                            ),
                          );
                        }

                        return _buildDoctorSections(
                          context,
                          doctors,
                          state.favoriteIds,
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                  24.verticalSpace,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorSections(
    BuildContext context,
    List<Doctor> doctors,
    Set<String> favoriteIds,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(title: t.home.popularDoctor, showSeeAll: true),
        12.verticalSpace,
        SizedBox(
          height: 220.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: doctors.length,
            separatorBuilder: (_, _) => 14.horizontalSpace,
            itemBuilder: (context, index) {
              final doctor = doctors[index];
              final isFav =
                  doctor.uid != null && favoriteIds.contains(doctor.uid);
              return PopularDoctorCard(
                imagePath:
                    (doctor.imageUrl != null && doctor.imageUrl!.isNotEmpty)
                    ? doctor.imageUrl!
                    : AppImages.doctor,
                name: doctor.name ?? 'Unknown',
                specialty: doctor.specialization ?? 'General',
                rating: doctor.rating ?? 0,
                onTap: () => context.push(
                  AppRoutes.doctorDetails,
                  extra: doctor.copyWith(isFavorite: isFav),
                ),
              );
            },
          ),
        ),
        24.verticalSpace,
        _buildSectionHeader(title: t.home.featureDoctor, showSeeAll: true),
        12.verticalSpace,
        SizedBox(
          height: 135.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: doctors.length,
            separatorBuilder: (_, _) => 10.horizontalSpace,
            itemBuilder: (context, index) {
              final doctor = doctors[index];
              final isFav =
                  doctor.uid != null && favoriteIds.contains(doctor.uid);
              return FeatureDoctorCard(
                onTap: () => context.push(
                  AppRoutes.doctorDetails,
                  extra: doctor.copyWith(isFavorite: isFav),
                ),
                imagePath:
                    (doctor.imageUrl != null && doctor.imageUrl!.isNotEmpty)
                    ? doctor.imageUrl!
                    : AppImages.doctor,
                name: doctor.name ?? 'Unknown',
                rating: doctor.rating ?? 0,
                hourlyRate: doctor.consultationFee,
                isFavorite: isFav,
                onFavoriteTap: () async {
                  await context.read<HomeCubit>().toggleFavorite(doctor.uid!);
                  if (isFav && context.mounted) {
                    SnackBarHelper.show(
                      context,
                      t.favorite.doctorRemoved(doctorName: doctor.name ?? 'Doctor'),
                      action: SnackBarAction(
                        label: t.common.undo,
                        textColor: AppColors.primary,
                        onPressed: () async {
                          await context.read<HomeCubit>().toggleFavorite(
                            doctor.uid!,
                          );
                        },
                      ),
                      duration: const Duration(seconds: 3),
                    );
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader({
    required String title,
    bool showSeeAll = false,
    VoidCallback? onSeeAllTap,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: context.bold18.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (showSeeAll)
            GestureDetector(
              onTap: onSeeAllTap,
              child: Row(
                children: [
                  Text(
                    t.home.seeAll,
                    style: context.regular12.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  2.horizontalSpace,
                  Icon(
                    MyIcons.chevronRightRounded,
                    size: 16.r,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
