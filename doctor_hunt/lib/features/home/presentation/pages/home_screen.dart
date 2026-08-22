import 'package:doctor_hunt/core/routes/app_routes.dart';
import 'package:doctor_hunt/core/widgets/app_background.dart';
import 'package:flutter/material.dart';
import 'package:doctor_hunt/core/theme/colors.dart';
import 'package:doctor_hunt/core/theme/style_atoms.dart';
import 'package:doctor_hunt/core/utils/app_images.dart';
import 'package:doctor_hunt/core/constants/assets.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../widgets/home_header.dart';
import '../widgets/live_doctor_card.dart';
import '../widgets/category_card.dart';
import '../widgets/popular_doctor_card.dart';
import '../widgets/feature_doctor_card.dart';
import '../widgets/home_bottom_nav_bar.dart';
import '../../../doctors/models/doctor_model.dart';
import '../../../../i18n/strings.g.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  final Doctor _dummyDoctor = const Doctor(
    name: 'Dr. Crick',
    specialty: 'Cardiologist',
    yearsExperience: 5,
    ratingPercentage: 4.8,
    patientStories: 120,
    nextAvailableTime: '10:00 AM tomorrow',
    imagePath: AppImages.doctor,
    isFavorite: false,
    hourlyRate: 25.00,
  );

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      
      child: Scaffold(
        backgroundColor: AppColors.background,
        bottomNavigationBar: HomeBottomNavBar(
          currentIndex: _currentNavIndex,
          onTap: (index) => setState(() => _currentNavIndex = index),
        ),
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
                            AppColors.info.withOpacity(0.7),
                          ],
                        ),
                        CategoryCard(
                          iconData: Icons.favorite_rounded,
                          gradientColors: [
                            AppColors.success,
                            AppColors.success.withOpacity(0.7),
                          ],
                        ),
                        CategoryCard(
                          svgAssetPath: Assets.resourceIconsEye,
                          gradientColors: [
                            AppColors.warning,
                            AppColors.warning.withOpacity(0.6),
                          ],
                        ),
                        CategoryCard(
                          iconData: Icons.wc_rounded,
                          gradientColors: [
                            AppColors.error,
                            AppColors.error.withOpacity(0.5),
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
                          imagePath: AppImages.doctor1,
                          name: 'Dr. Fillerup Grab',
                          specialty: 'Medicine Specialist',
                          rating: 4.5,
                          onTap: () => context.go(
                            AppRoutes.doctorDetails,
                            extra: _dummyDoctor,
                          ),
                        ),
                        PopularDoctorCard(
                          imagePath: AppImages.doctor2,
                          name: 'Dr. Blessing',
                          specialty: 'Dentist Specialist',
                          rating: 4.0,
                          onTap: () => context.go(
                            AppRoutes.doctorDetails,
                            extra: _dummyDoctor,
                          ),
                        ),
                        PopularDoctorCard(
                          imagePath: AppImages.doctor3,
                          name: 'Dr. Crick',
                          specialty: 'Cardiologist',
                          rating: 5.0,
                          onTap: () => context.go(
                            AppRoutes.doctorDetails,
                            extra: _dummyDoctor,
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
                              extra: _dummyDoctor,
                            );
                          },
                          imagePath: AppImages.doctor,
                          name: 'Dr. Crick',
                          rating: 3.7,
                          hourlyRate: 25.00,
                          isFavorite: false,
                        ),
                        FeatureDoctorCard(
                          onTap: () {
                            context.go(
                              AppRoutes.doctorDetails,
                              extra: _dummyDoctor,
                            );
                          },
                          imagePath: AppImages.doctor2,
                          name: 'Dr. Strain',
                          rating: 3.0,
                          hourlyRate: 22.00,
                          isFavorite: true,
                        ),
                        FeatureDoctorCard(
                          onTap: () {
                            context.go(
                              AppRoutes.doctorDetails,
                              extra: _dummyDoctor,
                            );
                          },
                          imagePath: AppImages.doctor3,
                          name: 'Dr. Lachinet',
                          rating: 2.9,
                          hourlyRate: 29.00,
                          isFavorite: false,
                        ),
                        FeatureDoctorCard(
                          onTap: () {
                            context.go(
                              AppRoutes.doctorDetails,
                              extra: _dummyDoctor,
                            );
                          },
                          imagePath: AppImages.doctor1,
                          name: 'Dr. Blessing',
                          rating: 4.8,
                          hourlyRate: 35.00,
                          isFavorite: true,
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
