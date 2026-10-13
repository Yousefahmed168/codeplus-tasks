import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/colors.dart';

class AppointmentShimmer extends StatelessWidget {
  const AppointmentShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      itemCount: 3,
      separatorBuilder: (_, _) => 16.verticalSpace,
      itemBuilder: (_, _) => const _ShimmerCard(),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceVariant,
      highlightColor: AppColors.surface,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withValues(alpha: 0.04),
              blurRadius: 10.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor row
            Row(
              children: [
                _box(56.r, 56.r, radius: 12.r),
                12.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _box(140.w, 14.h),
                      6.verticalSpace,
                      _box(100.w, 12.h),
                    ],
                  ),
                ),
                _box(72.w, 22.h, radius: 20.r),
              ],
            ),
            14.verticalSpace,
            Divider(height: 1.h),
            14.verticalSpace,
            // Details row
            Row(
              children: [
                _box(110.w, 12.h),
                20.horizontalSpace,
                _box(90.w, 12.h),
              ],
            ),
            10.verticalSpace,
            _box(100.w, 12.h),
            14.verticalSpace,
            // Buttons
            Row(
              children: [
                Expanded(child: _box(double.infinity, 38.h, radius: 10.r)),
                10.horizontalSpace,
                Expanded(child: _box(double.infinity, 38.h, radius: 10.r)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _box(double w, double h, {double? radius}) => Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(radius ?? 8.r),
        ),
      );
}
