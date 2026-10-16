import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/models/doctor.dart';
import '../../../../core/widgets/specialty_chips.dart';
import '../widgets/home_header.dart';
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
  String? _selectedSpecialty;

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
                    onClearSearch: () {
                      _searchController.clear();
                      setState(() => _selectedSpecialty = null);
                    },
                    onSearchTap: () => context.go(AppRoutes.search),
                    onAvatarTap: widget.onAvatarTap,
                  ),
                  36.verticalSpace,
                  BlocBuilder<HomeCubit, HomeState>(
                    builder: (context, state) {
                      if (state is HomeLoading) return _buildLoading();
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
                      if (state is HomeLoaded) return _buildLoaded(context, state);
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

  Widget _buildLoading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 40.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: 4,
            separatorBuilder: (_, _) => 8.horizontalSpace,
            itemBuilder: (_, _) => Shimmer.fromColors(
              baseColor: AppColors.surfaceVariant,
              highlightColor: AppColors.surface,
              child: Container(
                width: 90.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
            ),
          ),
        ),
        24.verticalSpace,
        _buildSectionHeader(title: t.home.popularDoctor),
        12.verticalSpace,
        SizedBox(
          height: 256.h,
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

  Widget _buildLoaded(BuildContext context, HomeLoaded state) {
    if (state.doctors.isEmpty) {
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

    final specialties = _specialtiesOf(state.doctors);
    final popular = _filterBySpecialty(state.popularDoctors);
    final topRated = _filterBySpecialty(state.topRatedDoctors);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(title: t.home.specialties),
        12.verticalSpace,
        SpecialtyChips(
          specialties: specialties,
          selected: _selectedSpecialty,
          allLabel: t.home.allSpecialties,
          onSelected: (value) => setState(() => _selectedSpecialty = value),
        ),
        24.verticalSpace,
        _buildSectionHeader(
          title: t.home.popularDoctor,
          showSeeAll: true,
          onSeeAllTap: () => context.go(AppRoutes.search),
        ),
        12.verticalSpace,
        _buildPopularList(context, popular, state.favoriteIds),
        24.verticalSpace,
        _buildSectionHeader(
          title: t.home.topRatedDoctor,
          showSeeAll: true,
          onSeeAllTap: () => context.go(AppRoutes.search),
        ),
        12.verticalSpace,
        _buildTopRatedList(context, topRated, state.favoriteIds),
      ],
    );
  }

  List<String> _specialtiesOf(List<Doctor> doctors) {
    final set = <String>{};
    for (final doctor in doctors) {
      final specialty = doctor.specialization?.trim();
      if (specialty != null && specialty.isNotEmpty) set.add(specialty);
    }
    return set.toList()..sort();
  }

  List<Doctor> _filterBySpecialty(List<Doctor> doctors) {
    if (_selectedSpecialty == null) return doctors;
    return doctors
        .where((doctor) => doctor.specialization == _selectedSpecialty)
        .toList();
  }

  Widget _buildPopularList(
    BuildContext context,
    List<Doctor> doctors,
    Set<String> favoriteIds,
  ) {
    if (doctors.isEmpty) return _buildEmptySection();
    return SizedBox(
      height: 256.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: doctors.length,
        separatorBuilder: (_, _) => 14.horizontalSpace,
        itemBuilder: (context, index) {
          final doctor = doctors[index];
          final isFav = doctor.uid != null && favoriteIds.contains(doctor.uid);
          return PopularDoctorCard(
            imagePath: _imageOf(doctor),
            name: doctor.name ?? '',
            specialty: doctor.specialization ?? '',
            rating: doctor.rating ?? 0,
            reviewsCount: doctor.reviewsCount,
            fee: doctor.consultationFee,
            onTap: () => context.push(
              AppRoutes.doctorDetails,
              extra: doctor.copyWith(isFavorite: isFav),
            ),
            onBookNow: () => context.push(
              AppRoutes.doctorDetails,
              extra: doctor.copyWith(isFavorite: isFav),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopRatedList(
    BuildContext context,
    List<Doctor> doctors,
    Set<String> favoriteIds,
  ) {
    if (doctors.isEmpty) return _buildEmptySection();
    return SizedBox(
      height: 135.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: doctors.length,
        separatorBuilder: (_, _) => 10.horizontalSpace,
        itemBuilder: (context, index) {
          final doctor = doctors[index];
          final isFav = doctor.uid != null && favoriteIds.contains(doctor.uid);
          return FeatureDoctorCard(
            imagePath: _imageOf(doctor),
            name: doctor.name ?? '',
            rating: doctor.rating ?? 0,
            reviewsCount: doctor.reviewsCount,
            hourlyRate: doctor.consultationFee,
            isFavorite: isFav,
            onTap: () => context.push(
              AppRoutes.doctorDetails,
              extra: doctor.copyWith(isFavorite: isFav),
            ),
            onFavoriteTap: () => _toggleFavorite(context, doctor, isFav),
          );
        },
      ),
    );
  }

  Widget _buildEmptySection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Text(
        t.home.noDoctorsAvailableYet,
        style: context.regular14.textSecondary,
      ),
    );
  }

  Future<void> _toggleFavorite(
    BuildContext context,
    Doctor doctor,
    bool isFav,
  ) async {
    final uid = doctor.uid;
    if (uid == null) return;
    final cubit = context.read<HomeCubit>();
    await cubit.toggleFavorite(uid);
    if (isFav && context.mounted) {
      SnackBarHelper.show(
        context,
        t.favorite.doctorRemoved(doctorName: doctor.name ?? ''),
        action: SnackBarAction(
          label: t.common.undo,
          textColor: AppColors.primary,
          onPressed: () => cubit.toggleFavorite(uid),
        ),
        duration: const Duration(seconds: 3),
      );
    }
  }

  String _imageOf(Doctor doctor) =>
      (doctor.imageUrl != null && doctor.imageUrl!.isNotEmpty)
      ? doctor.imageUrl!
      : AppImages.doctor;

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
