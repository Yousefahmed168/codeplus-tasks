import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/colors.dart';

/// Skeleton shown while the patient profile is loading.
class PatientProfileShimmer extends StatelessWidget {
  const PatientProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: 52.h,
            left: 20.w,
            right: 20.w,
            bottom: 26.h,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30.r),
              bottomRight: Radius.circular(30.r),
            ),
          ),
          child: Center(
            child: Shimmer.fromColors(
              baseColor: AppColors.primaryLight,
              highlightColor: AppColors.textOnPrimary,
              child: Container(
                width: 104.r,
                height: 104.r,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
            child: Shimmer.fromColors(
              baseColor: AppColors.surfaceVariant,
              highlightColor: AppColors.surface,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _box(140.w, 16.h),
                  14.verticalSpace,
                  Container(
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        _row(),
                        Divider(height: 1.h, color: AppColors.divider),
                        _row(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _row() => Padding(
    padding: EdgeInsets.symmetric(vertical: 14.h),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _box(80.w, 10.h),
              8.verticalSpace,
              _box(160.w, 14.h),
            ],
          ),
        ),
        8.horizontalSpace,
        _box(20.r, 20.r, radius: 6.r),
      ],
    ),
  );

  Widget _box(double width, double height, {double? radius}) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: AppColors.surfaceVariant,
      borderRadius: BorderRadius.circular(radius ?? 6.r),
    ),
  );
}
