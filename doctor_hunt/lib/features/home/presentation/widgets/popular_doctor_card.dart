import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/constants/my_icons.dart';

class PopularDoctorCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String specialty;
  final double rating;
  final VoidCallback? onTap;

  const PopularDoctorCard({
    super.key,
    required this.imagePath,
    required this.name,
    required this.specialty,
    this.rating = 5.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150.w,
        margin: EdgeInsets.only(right: 7.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withValues(alpha: 0.09),
              blurRadius: 14.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Doctor Image Container
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16.r),
              ),
              child: Container(
                height: 140.h,
                width: double.infinity,
                color: AppColors.divider,
                child: imagePath.startsWith('http')
                    ? CachedNetworkImage(
                        imageUrl: imagePath,
                        fit: BoxFit.cover,
                        errorWidget: (_, _, _) => Center(
                          child: Icon(
                            MyIcons.person,
                            size: 60.r,
                            color: AppColors.primary,
                          ),
                        ),
                      )
                    : Image.asset(
                        imagePath,
                        fit: BoxFit.fill,
                        errorBuilder: (_, _, _) => Center(
                          child: Icon(
                            MyIcons.person,
                            size: 50.r,
                            color: AppColors.primary,
                          ),
                        ),
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
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  2.verticalSpace,
                  Text(
                    specialty,
                    style: context.regular12.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  6.verticalSpace,
                  // Rating Stars
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return Icon(
                        index < rating.floor()
                            ? MyIcons.starRounded
                            : (index < rating
                                  ? MyIcons.starHalfRounded
                                  : MyIcons.starOutlineRounded),
                        color: AppColors.star,
                        size: 14.r,
                      );
                    }),
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
