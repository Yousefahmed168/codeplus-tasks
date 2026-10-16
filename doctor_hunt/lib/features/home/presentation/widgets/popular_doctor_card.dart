import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/constants/my_icons.dart';
import '../../../../i18n/strings.g.dart';

/// Horizontal doctor card used by the Home "Popular Doctors" section.
///
/// Shows image, name, specialty, rating & review count, consultation fee and a
/// "Book Now" call to action (locked MVP scope).
class PopularDoctorCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String specialty;
  final double rating;
  final int reviewsCount;
  final double fee;
  final VoidCallback? onTap;
  final VoidCallback? onBookNow;

  const PopularDoctorCard({
    super.key,
    required this.imagePath,
    required this.name,
    required this.specialty,
    required this.rating,
    this.reviewsCount = 0,
    this.fee = 0,
    this.onTap,
    this.onBookNow,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 170.w,
        margin: EdgeInsets.only(right: 14.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.08),
              blurRadius: 14.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              child: SizedBox(
                height: 100.h,
                child: imagePath.startsWith('http')
                    ? CachedNetworkImage(
                        imageUrl: imagePath,
                        fit: BoxFit.cover,
                        errorWidget: (_, _, _) => _fallback(),
                      )
                    : Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => _fallback(),
                      ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.r),
              child: Column(
                children: [
                  Text(
                    name,
                    style: context.semiBold14.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  2.verticalSpace,
                  Text(
                    specialty,
                    style: context.regular12.textSecondary,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  6.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        MyIcons.starRounded,
                        size: 14.r,
                        color: AppColors.star,
                      ),
                      2.horizontalSpace,
                      Text(
                        rating.toStringAsFixed(1),
                        style: context.bold12.textPrimary,
                      ),
                      4.horizontalSpace,
                      Flexible(
                        child: Text(
                          t.home.reviewsCount(count: reviewsCount),
                          style: context.regular11.textSecondary,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  6.verticalSpace,
                  Text(
                    t.common.amount(amount: fee.toStringAsFixed(0)),
                    style: context.bold12.primary,
                  ),
                  8.verticalSpace,
                  GestureDetector(
                    onTap: onBookNow,
                    child: Container(
                      height: 32.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        t.home.bookNow,
                        style: context.semiBold12.copyWith(
                          color: AppColors.textOnPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fallback() => Container(
        color: AppColors.divider,
        child: Center(
          child: Icon(MyIcons.person, size: 48.r, color: AppColors.primary),
        ),
      );
}
