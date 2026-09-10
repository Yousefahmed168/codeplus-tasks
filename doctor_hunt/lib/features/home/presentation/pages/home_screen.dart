import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/constants/assets.dart';
import '../../../../features/doctors/models/doctor.dart';
import '../widgets/home_header.dart';
import '../widgets/live_doctor_card.dart';
import '../widgets/category_card.dart';
import '../widgets/popular_doctor_card.dart';
import '../widgets/feature_doctor_card.dart';
import '../../../../i18n/strings.g.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

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
        backgroundColor: Colors.transparent,
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
                  const Gap(36),
                  _buildSectionHeader(
                    title: t.home.liveDoctors,
                    showSeeAll: true,
                  ),
                  const Gap(12),
                  SizedBox(
                    height: 160,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: const [
                        LiveDoctorCard(imagePath: AppImages.doctor1),
                        LiveDoctorCard(imagePath: AppImages.doctor2),
                        LiveDoctorCard(imagePath: AppImages.doctor3),
                        LiveDoctorCard(imagePath: AppImages.doctor),
                      ],
                    ),
                  ),
                  const Gap(24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
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
                          iconData: Icons.favorite_rounded,
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
                          iconData: Icons.wc_rounded,
                          gradientColors: [
                            AppColors.error,
                            AppColors.error.withValues(alpha: 0.5),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Gap(24),
                  
                  // Popular Doctors (using BlocBuilder)
                  BlocBuilder<HomeCubit, HomeState>(
                    builder: (context, state) {
                      if (state is HomeLoading) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          ),
                        );
                      }
                      if (state is HomeError) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
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
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Center(
                              child: Text(
                                'No doctors available yet',
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
                  const Gap(24),
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
        const Gap(12),
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: doctors.length,
            separatorBuilder: (_, _) => const Gap(14),
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
        const Gap(24),
        _buildSectionHeader(title: t.home.featureDoctor, showSeeAll: true),
        const Gap(12),
        SizedBox(
          height: 135,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: doctors.length,
            separatorBuilder: (_, _) => const Gap(10),
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
                hourlyRate: 50.0,
                isFavorite: isFav,
                onFavoriteTap: () async {
                  await context.read<HomeCubit>().toggleFavorite(doctor.uid!);
                  if (isFav && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${doctor.name ?? 'Doctor'} removed from favorites'),
                        action: SnackBarAction(
                          label: t.common.undo,
                          textColor: AppColors.primary,
                          onPressed: () async {
                            await context.read<HomeCubit>().toggleFavorite(doctor.uid!);
                          },
                        ),
                        duration: const Duration(seconds: 3),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
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
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
                  const Gap(2),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 16,
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
