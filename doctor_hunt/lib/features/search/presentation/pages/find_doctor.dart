
import '../../../../core/models/doctor.dart';

import '../../../../core/widgets/custom_text_form_field.dart';
import '../../../../core/widgets/custom_back_button.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/widgets/app_background.dart';
import '../../../../core/services/user_service.dart';
import '../../../../core/widgets/specialty_chips.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:go_router/go_router.dart';
import '../../../../i18n/strings.g.dart';
import '../../../../core/constants/my_icons.dart';

class FindDoctorScreen extends StatefulWidget {
  const FindDoctorScreen({super.key, this.isTab = false});

  /// When true the screen is embedded as a bottom-navigation tab: the back
  /// button is hidden and the search field does not steal focus.
  final bool isTab;

  @override
  State<FindDoctorScreen> createState() => _FindDoctorScreenState();
}

class _FindDoctorScreenState extends State<FindDoctorScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String _searchQuery = "";
  String? _selectedSpecialty;

  @override
  void initState() {
    super.initState();
    if (widget.isTab) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: AppColors.transparent,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    if (!widget.isTab) ...[
                      CustomBackButton(
                        onTap: () {
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.go(AppRoutes.home);
                          }
                        },
                      ),
                      12.horizontalSpace,
                    ],
                    Text(
                      t.findDoctors.title,
                      style: context.bold20.textPrimary,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => context.push(AppRoutes.favoriteDoctors),
                      icon: Icon(
                        MyIcons.favoriteRounded,
                        color: AppColors.primary,
                        size: 24.r,
                      ),
                    ),
                  ],
                ),
              ),
              20.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        suffixIcon: GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
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
                        controller: _searchController,
                        onChange: (v) => setState(() => _searchQuery = v),
                        textInputAction: TextInputAction.search,
                        hintText: t.home.searchHint,
                      ),
                    ),
                  ],
                ),
              ),
              24.verticalSpace,
              Expanded(child: _buildSearchResults()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return StreamBuilder<List<Doctor>>(
      stream: sl<UserService>().streamDoctors(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: 4,
            separatorBuilder: (_, _) => 16.verticalSpace,
            itemBuilder: (_, _) => Shimmer.fromColors(
              baseColor: AppColors.border.withValues(alpha: 0.3),
              highlightColor: AppColors.surface,
              child: Container(
                height: 112.h,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            ),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              t.home.failedToLoadDoctors,
              style: context.regular14.textSecondary,
            ),
          );
        }

        final allDoctors = snapshot.data ?? [];
        final specialties = _specialtiesOf(allDoctors);
        final query = _searchQuery.toLowerCase();
        final results = allDoctors
            .where(
              (d) =>
                  ((d.name ?? '').toLowerCase().contains(query) ||
                      (d.specialization ?? '').toLowerCase().contains(query)) &&
                  (_selectedSpecialty == null ||
                      d.specialization == _selectedSpecialty),
            )
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (specialties.isNotEmpty) ...[
              SpecialtyChips(
                specialties: specialties,
                selected: _selectedSpecialty,
                allLabel: t.home.allSpecialties,
                onSelected: (value) =>
                    setState(() => _selectedSpecialty = value),
              ),
              16.verticalSpace,
            ],
            Expanded(
              child: results.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      itemCount: results.length,
                      separatorBuilder: (_, _) => 16.verticalSpace,
                      itemBuilder: (context, index) {
                        final doctor = results[index];
                        return _buildDoctorResultCard(context, doctor);
                      },
                    ),
            ),
          ],
        );
      },
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            MyIcons.searchOffRounded,
            size: 64.r,
            color: AppColors.textHint.withValues(alpha: 0.5),
          ),
          16.verticalSpace,
          Text(
            t.findDoctors.noDoctorsFound,
            style: context.bold16.textSecondary,
          ),
          8.verticalSpace,
          Text(
            t.findDoctors.tryDifferentSearchTerm,
            style: context.regular14.textHint,
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorResultCard(BuildContext context, Doctor doctor) {
    return GestureDetector(
      onTap: () {
        context.push(AppRoutes.doctorDetails, extra: doctor);
      },
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.06),
              blurRadius: 12.r,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: (doctor.imageUrl != null && doctor.imageUrl!.isNotEmpty)
                  ? CachedNetworkImage(
                      imageUrl: doctor.imageUrl!,
                      width: 80.r,
                      height: 80.r,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: AppColors.border.withValues(alpha: 0.3),
                        highlightColor: AppColors.surface,
                        child: Container(
                          width: 80.r,
                          height: 80.r,
                          color: AppColors.surface,
                        ),
                      ),
                      errorWidget: (_, _, _) => Image.asset(
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
            12.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name ?? '',
                    style: context.bold16.textPrimary,
                  ),
                  2.verticalSpace,
                  Text(
                    doctor.specialization ?? '',
                    style: context.regular14.primary,
                  ),
                  6.verticalSpace,
                  Row(
                    children: [
                      Icon(MyIcons.starRounded, size: 14.r, color: AppColors.star),
                      4.horizontalSpace,
                      Text(
                        (doctor.rating ?? 0).toStringAsFixed(1),
                        style: context.regular12.textSecondary,
                      ),
                      4.horizontalSpace,
                      Text(
                        t.home.reviewsCount(count: doctor.reviewsCount),
                        style: context.regular12.textSecondary,
                      ),
                    ],
                  ),
                  4.verticalSpace,
                  Text(
                    t.common.amount(
                      amount: doctor.consultationFee.toStringAsFixed(0),
                    ),
                    style: context.bold12.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
