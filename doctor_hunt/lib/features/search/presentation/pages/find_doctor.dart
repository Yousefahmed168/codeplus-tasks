
import '../../../doctors/models/doctor.dart';

import '../../../../core/widgets/custom_text_form_field.dart';
import '../../../../core/widgets/custom_back_button.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/widgets/app_background.dart';
import '../../../../core/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:go_router/go_router.dart';
import '../../../../i18n/strings.g.dart';

class FindDoctorScreen extends StatefulWidget {
  const FindDoctorScreen({super.key});

  @override
  State<FindDoctorScreen> createState() => _FindDoctorScreenState();
}

class _FindDoctorScreenState extends State<FindDoctorScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
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
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
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
                    Text(
                      t.findDoctors.title,
                      style: context.bold20.textPrimary,
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
                            Icons.close_rounded,
                            color: AppColors.textSecondary,
                            size: 20.r,
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
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
        final results = allDoctors
            .where(
              (d) =>
                  (d.name ?? '').toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ) ||
                  (d.specialization ?? '').toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ),
            )
            .toList();

        if (results.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off_rounded,
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

        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          itemCount: results.length,
          separatorBuilder: (_, _) => 16.verticalSpace,
          itemBuilder: (context, index) {
            final doctor = results[index];
            return _buildDoctorResultCard(context, doctor);
          },
        );
      },
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
              color: Colors.black.withValues(alpha: 0.06),
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
                    doctor.name ?? 'Unknown',
                    style: context.bold16.textPrimary,
                  ),
                  2.verticalSpace,
                  Text(
                    doctor.specialization ?? 'General',
                    style: context.regular14.primary,
                  ),
                  4.verticalSpace,
                  Text(
                    t.findDoctors.tenYearsExperience,
                    style: context.regular12.textSecondary,
                  ),
                  6.verticalSpace,
                  Row(
                    children: [
                      Icon(Icons.star_rounded, size: 14.r, color: AppColors.star),
                      4.horizontalSpace,
                      Text(
                        (doctor.rating ?? 0).toStringAsFixed(1),
                        style: context.regular12.textSecondary,
                      ),
                    ],
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
