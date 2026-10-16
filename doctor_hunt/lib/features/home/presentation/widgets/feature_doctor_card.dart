import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/constants/my_icons.dart';
import '../../../../i18n/strings.g.dart';

class FeatureDoctorCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final double rating;
  final int reviewsCount;
  final double hourlyRate;
  final bool isFavorite;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onTap;

  const FeatureDoctorCard({
    super.key,
    required this.imagePath,
    required this.name,
    required this.rating,
    required this.hourlyRate,
    this.reviewsCount = 0,
    this.isFavorite = false,
    this.onFavoriteTap,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 135.w,
        height: 130.h,
        margin: EdgeInsets.only(right: 5.w),
        padding: EdgeInsets.all(5.r),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.divider, width: 2.w),
          boxShadow: [
            BoxShadow(
              color: AppColors.backgroundDark.withValues(alpha: 0.1),
              blurRadius: 10.r,
              offset: Offset(0, 3.h),
            ),
          ],
        ),
        child: Column(
          children: [
            // Top Row: Heart icon (left) and Rating (right)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: onFavoriteTap,
                  child: Icon(
                    isFavorite
                        ? MyIcons.favoriteRounded
                        : MyIcons.favoriteBorderRounded,
                    size: 16.r,
                    color: isFavorite ? AppColors.error : AppColors.textLight,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      MyIcons.starRounded,
                      size: 14.r,
                      color: AppColors.star,
                    ),
                    2.horizontalSpace,
                    Text(
                      rating.toStringAsFixed(1),
                      style: context.bold12.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    2.horizontalSpace,
                    Text(
                      '($reviewsCount)',
                      style: context.regular11.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            5.verticalSpace,

            // Circular Avatar
            ClipOval(
              child: imagePath.startsWith('http')
                  ? CachedNetworkImage(
                      imageUrl: imagePath,
                      width: 50.r,
                      height: 50.r,
                      fit: BoxFit.cover,
                      errorWidget: (_, _, _) => Icon(
                        MyIcons.person,
                        size: 30.r,
                        color: AppColors.primary,
                      ),
                    )
                  : Image.asset(
                      imagePath,
                      width: 50.r,
                      height: 50.r,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Icon(
                        MyIcons.person,
                        size: 30.r,
                        color: AppColors.primary,
                      ),
                    ),
            ),
            5.verticalSpace,

            // Doctor Name
            Text(
              name,
              style: context.semiBold12.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            // Consultation fee
            Text(
              t.common.amount(amount: hourlyRate.toStringAsFixed(0)),
              textAlign: TextAlign.center,
              style: context.bold12.primary,
            ),
          ],
        ),
      ),
    );
  }
}
