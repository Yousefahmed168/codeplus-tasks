import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/widgets/custom_text_form_field.dart';
import '../../../../core/data/dummy_doctors.dart';
import '../../models/doctor_model.dart';
import '../widgets/favorite_doctor_grid_card.dart';
import '../../../home/presentation/widgets/feature_doctor_card.dart';
import '../../../../i18n/strings.g.dart';

class FavoriteDoctorsScreen extends StatefulWidget {
  const FavoriteDoctorsScreen({super.key});

  @override
  State<FavoriteDoctorsScreen> createState() => _FavoriteDoctorsScreenState();
}

class _FavoriteDoctorsScreenState extends State<FavoriteDoctorsScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<Doctor> get _favoriteDoctors =>
      DummyDoctors.all.where((d) => d.isFavorite).toList();

  List<Doctor> get _featureDoctors => DummyDoctors.all;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20, top: 8, bottom: 8),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.textPrimary,
                size: 16,
              ),
              onPressed: () {},
            ),
          ),
        ),
        leadingWidth: 64,
        title: Text(t.home.favouriteDoctors, style: context.bold.px20.textPrimary),
        centerTitle: false,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: CustomTextFormField(
                controller: _searchController,
                hintText: t.findDoctors.searchHint,
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.textHint,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    color: AppColors.textHint,
                    size: 20,
                  ),
                  onPressed: () => _searchController.clear(),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                return FavoriteDoctorGridCard(
                  doctor: _favoriteDoctors[index],
                  onFavoriteToggle: () {},
                );
              }, childCount: _favoriteDoctors.length),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        t.home.featureDoctor,
                        style: context.bold.px18.textPrimary,
                      ),
                      Row(
                        children: [
                          Text(
                            t.home.seeAll,
                            style: context.regular.px12.textSecondary,
                          ),
                          const Icon(
                            Icons.chevron_right_rounded,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Gap(16),
                SizedBox(
                  height: 130, // FeatureDoctorCard has height 120
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: _featureDoctors.length,
                    separatorBuilder: (context, index) => const Gap(10),
                    itemBuilder: (context, index) {
                      final doctor = _featureDoctors[index];
                      return FeatureDoctorCard(
                        name: doctor.name,
                        imagePath: doctor.imagePath,
                        rating: doctor.ratingPercentage,
                        hourlyRate: doctor.hourlyRate,
                        isFavorite: doctor.isFavorite,
                      );
                    },
                  ),
                ),
                const Gap(32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
