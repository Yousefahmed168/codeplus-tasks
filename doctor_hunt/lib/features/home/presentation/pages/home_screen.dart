import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/constants/assets.dart';
import '../../../../core/services/user_service.dart';
import '../../../../core/services/favorite_service.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/utils/db_seeder.dart';
import '../../../../features/doctors/models/doctor_model.dart';
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

  String? get _patientUid => AuthService.instance.currentUser?.uid;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        heroTag: 'seed_db_btn',
        onPressed: () async {
          await DbSeeder.seedDoctors();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(t.home.seededSuccess)),
            );
          }
        },
        tooltip: 'Seed Mock Doctors',
        child: const Icon(Icons.add),
      ),
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
                ),
                Gap(36),
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

                // ── Popular Doctors (with favorites stream) ────────────
                StreamBuilder<List<DoctorModel>>(
                  stream: UserService.instance.streamDoctors(),
                  builder: (context, docSnapshot) {
                    if (docSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                      );
                    }
                    if (docSnapshot.hasError) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: Text(
                            'Failed to load doctors',
                            style: context.regular14.textSecondary,
                          ),
                        ),
                      );
                    }

                    final doctors = docSnapshot.data ?? [];
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

                    // If user not logged in, show all as not-favorited
                    if (_patientUid == null) {
                      return _buildDoctorSections(
                        context,
                        doctors,
                        <String>{},
                      );
                    }

                    // Stream favorite IDs for real-time sync
                    return StreamBuilder<Set<String>>(
                      stream: FavoriteService.instance
                          .streamFavoriteIds(_patientUid!),
                      builder: (context, favSnapshot) {
                        final favoriteIds = favSnapshot.data ?? {};
                        return _buildDoctorSections(
                          context,
                          doctors,
                          favoriteIds,
                        );
                      },
                    );
                  },
                ),
                Gap(24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorSections(
    BuildContext context,
    List<DoctorModel> doctors,
    Set<String> favoriteIds,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          title: t.home.popularDoctor,
          showSeeAll: true,
        ),
        Gap(12),
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
                imagePath: (doctor.imageUrl != null &&
                        doctor.imageUrl!.isNotEmpty)
                    ? doctor.imageUrl!
                    : AppImages.doctor,
                name: doctor.name ?? 'Unknown',
                specialty: doctor.specialization ?? 'General',
                rating: doctor.rating ?? 0,
                onTap: () => context.push(
                  AppRoutes.doctorDetails,
                  extra: doctor.toDoctor(isFavorite: isFav),
                ),
              );
            },
          ),
        ),
        Gap(24),
        _buildSectionHeader(
          title: t.home.featureDoctor,
          showSeeAll: true,
        ),
        Gap(12),
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
                  extra: doctor.toDoctor(isFavorite: isFav),
                ),
                imagePath: (doctor.imageUrl != null &&
                        doctor.imageUrl!.isNotEmpty)
                    ? doctor.imageUrl!
                    : AppImages.doctor,
                name: doctor.name ?? 'Unknown',
                rating: doctor.rating ?? 0,
                hourlyRate: 50.0,
                isFavorite: isFav,
                onFavoriteTap: () => _toggleFavorite(
                  doctor.uid,
                  doctorName: doctor.name ?? 'Doctor',
                  wasFavorite: isFav,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _toggleFavorite(
    String? doctorUid, {
    String doctorName = 'Doctor',
    bool wasFavorite = false,
  }) async {
    if (_patientUid == null || doctorUid == null) return;
    final isNowFavorite = await FavoriteService.instance.toggleFavorite(
      patientUid: _patientUid!,
      doctorUid: doctorUid,
    );
    // StreamBuilder auto-rebuilds — no setState needed

    // Show undo snackbar when REMOVING a favorite
    if (wasFavorite && !isNowFavorite && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$doctorName removed from favorites'),
          action: SnackBarAction(
            label: t.common.undo,
            textColor: AppColors.primary,
            onPressed: () async {
              await FavoriteService.instance.addFavorite(
                patientUid: _patientUid!,
                doctorUid: doctorUid,
              );
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
