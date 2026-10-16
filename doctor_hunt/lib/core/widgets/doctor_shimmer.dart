import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../theme/colors.dart';

/// Skeleton for the vertical doctor card used in the home carousel.
///
/// The home and admin doctor lists used to show a bare
/// `CircularProgressIndicator`, which tells the user nothing about what is
/// loading and breaks the app's own "shimmer, never spinners" rule.
class DoctorCardShimmer extends StatelessWidget {
  const DoctorCardShimmer({super.key, this.width = 150, this.height = 200});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceVariant,
      highlightColor: AppColors.surface,
      child: Container(
        width: width.w,
        height: height.h,
        padding: EdgeInsets.all(12.r),
        decoration: _cardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _box(double.infinity, 96.h, 12.r),
            12.verticalSpace,
            _box(96.w, 12.h),
            8.verticalSpace,
            _box(64.w, 10.h),
          ],
        ),
      ),
    );
  }
}

/// Skeleton for the horizontal doctor row used in the admin list.
class DoctorListRowShimmer extends StatelessWidget {
  const DoctorListRowShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceVariant,
      highlightColor: AppColors.surface,
      child: Container(
        padding: EdgeInsets.all(14.r),
        decoration: _cardDecoration(),
        child: Row(
          children: [
            _box(56.r, 56.r, 12.r),
            12.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _box(130.w, 14.h),
                  8.verticalSpace,
                  _box(90.w, 12.h),
                ],
              ),
            ),
            _box(72.w, 26.h, 20.r),
          ],
        ),
      ),
    );
  }
}

BoxDecoration _cardDecoration() => BoxDecoration(
  color: AppColors.surface,
  borderRadius: BorderRadius.circular(16.r),
  border: Border.all(color: AppColors.divider),
);

Widget _box(double width, double height, [double radius = 8]) => Container(
  width: width,
  height: height,
  decoration: BoxDecoration(
    color: AppColors.surfaceVariant,
    borderRadius: BorderRadius.circular(radius.r),
  ),
);
