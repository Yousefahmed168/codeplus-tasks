import '../../../../core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/constants/assets.dart';
import '../../../../core/data/dummy_doctors.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../widgets/home_header.dart';
import '../widgets/live_doctor_card.dart';
import '../widgets/category_card.dart';
import '../widgets/popular_doctor_card.dart';
import '../widgets/feature_doctor_card.dart';
import '../../../../i18n/strings.g.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Header with floating search bar
                  HomeHeader(
                    searchController: _searchController,
                    onClearSearch: () => _searchController.clear(),
                    onSearchTap: () => context.go(AppRoutes.search),
                  ),
                  Gap(36),
      
                  // 2. Live Doctors Section
                  _buildSectionHeader(
                    title: t.home.liveDoctors,
                    showSeeAll: true,
                  ),
                  Gap(12),
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
                  Gap(24),
      
                  // 3. Category Cards Row
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
                  Gap(24),
      
                  // 4. Popular Doctor Section
                  _buildSectionHeader(
                    title: t.home.popularDoctor,
                    showSeeAll: true,
                    onSeeAllTap: () {},
                  ),
                  Gap(12),
                  SizedBox(
                    height: 220,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        PopularDoctorCard(
                          imagePath: DummyDoctors.all[1].imagePath,
                          name: DummyDoctors.all[1].name,
                          specialty: DummyDoctors.all[1].specialty,
                          rating: DummyDoctors.all[1].ratingPercentage,
                          onTap: () => context.go(
                            AppRoutes.doctorDetails,
                            extra: DummyDoctors.all[1],
                          ),
                        ),
                        PopularDoctorCard(
                          imagePath: DummyDoctors.all[2].imagePath,
                          name: DummyDoctors.all[2].name,
                          specialty: DummyDoctors.all[2].specialty,
                          rating: DummyDoctors.all[2].ratingPercentage,
                          onTap: () => context.go(
                            AppRoutes.doctorDetails,
                            extra: DummyDoctors.all[2],
                          ),
                        ),
                        PopularDoctorCard(
                          imagePath: DummyDoctors.all[0].imagePath,
                          name: DummyDoctors.all[0].name,
                          specialty: DummyDoctors.all[0].specialty,
                          rating: DummyDoctors.all[0].ratingPercentage,
                          onTap: () => context.go(
                            AppRoutes.doctorDetails,
                            extra: DummyDoctors.all[0],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(24),
      
                  // 5. Feature Doctor Section
                  _buildSectionHeader(
                    title: t.home.featureDoctor,
                    showSeeAll: true,
                    onSeeAllTap: () {},
                  ),
                  Gap(12),
                  SizedBox(
                    height: 135,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        FeatureDoctorCard(
                          onTap: () {
                            context.go(
                              AppRoutes.doctorDetails,
                              extra: DummyDoctors.all[0],
                            );
                          },
                          imagePath: DummyDoctors.all[0].imagePath,
                          name: DummyDoctors.all[0].name,
                          rating: DummyDoctors.all[0].ratingPercentage,
                          hourlyRate: DummyDoctors.all[0].hourlyRate,
                          isFavorite: DummyDoctors.all[0].isFavorite,
                        ),
                        FeatureDoctorCard(
                          onTap: () {
                            context.go(
                              AppRoutes.doctorDetails,
                              extra: DummyDoctors.all[2],
                            );
                          },
                          imagePath: DummyDoctors.all[2].imagePath,
                          name: DummyDoctors.all[2].name,
                          rating: DummyDoctors.all[2].ratingPercentage,
                          hourlyRate: DummyDoctors.all[2].hourlyRate,
                          isFavorite: DummyDoctors.all[2].isFavorite,
                        ),
                        FeatureDoctorCard(
                          onTap: () {
                            context.go(
                              AppRoutes.doctorDetails,
                              extra: DummyDoctors.all[5],
                            );
                          },
                          imagePath: DummyDoctors.all[5].imagePath,
                          name: DummyDoctors.all[5].name,
                          rating: DummyDoctors.all[5].ratingPercentage,
                          hourlyRate: DummyDoctors.all[5].hourlyRate,
                          isFavorite: DummyDoctors.all[5].isFavorite,
                        ),
                        FeatureDoctorCard(
                          onTap: () {
                            context.go(
                              AppRoutes.doctorDetails,
                              extra: DummyDoctors.all[1],
                            );
                          },
                          imagePath: DummyDoctors.all[1].imagePath,
                          name: DummyDoctors.all[1].name,
                          rating: DummyDoctors.all[1].ratingPercentage,
                          hourlyRate: DummyDoctors.all[1].hourlyRate,
                          isFavorite: DummyDoctors.all[1].isFavorite,
                        ),
                      ],
                    ),
                  ),
                  Gap(24),
                ],
              ),
            ),
          ],
        ),
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
                  Gap(2),
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
