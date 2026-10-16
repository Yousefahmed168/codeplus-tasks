import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../i18n/strings.g.dart';
import '../../../../core/models/doctor.dart';
import '../../../../core/constants/my_icons.dart';

class DoctorCard extends StatelessWidget {
  const DoctorCard({
    super.key,
    required this.doctor,
    this.onTap,
    this.onBookNow,
    this.onFavoriteToggle,
  });

  final Doctor doctor;
  final VoidCallback? onTap;
  final VoidCallback? onBookNow;
  final VoidCallback? onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
        child: Column(
          children: [
            // Top row: image + info + heart
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Doctor photo
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: (doctor.imageUrl ?? '').startsWith('http')
                      ? CachedNetworkImage(
                          imageUrl: doctor.imageUrl!,
                          width: 80.r,
                          height: 80.r,
                          fit: BoxFit.cover,
                          errorWidget: (_, _, _) => Icon(
                            MyIcons.person,
                            size: 80.r,
                            color: AppColors.primary,
                          ),
                        )
                      : Image.asset(
                          doctor.imageUrl ?? 'assets/images/doctor.png',
                          width: 80.r,
                          height: 80.r,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Icon(
                            MyIcons.person,
                            size: 80.r,
                            color: AppColors.primary,
                          ),
                        ),
                ),
                12.horizontalSpace,

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(doctor.name ?? 'Unknown', style: context.bold16.textPrimary),
                      2.verticalSpace,
                      Text(doctor.specialization ?? 'General', style: context.regular14.primary),
                      6.verticalSpace,
                      Row(
                        children: [
                          Icon(MyIcons.star, size: 14.r, color: AppColors.star),
                          4.horizontalSpace,
                          Text(
                            '${doctor.rating ?? 0.0}',
                            style: context.regular12.textSecondary,
                          ),
                        ],
                      ),
                      4.verticalSpace,
                      Text(
                        '\$${doctor.consultationFee.toStringAsFixed(2)}',
                        style: context.semiBold14.textPrimary,
                      ),
                    ],
                  ),
                ),

                // Favorite heart
                GestureDetector(
                  onTap: onFavoriteToggle,
                  child: Icon(
                    doctor.isFavorite ? MyIcons.favorite : MyIcons.favoriteBorder,
                    color: doctor.isFavorite
                        ? AppColors.error
                        : AppColors.textHint,
                    size: 24.r,
                  ),
                ),
              ],
            ),

            12.verticalSpace,
            Row(
              children: [
                // Next Available
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.common.nextAvailable,
                        style: context.regular12.textSecondary,
                      ),
                      2.verticalSpace,
                      Text('8:00 AM', style: context.medium14.textPrimary),
                    ],
                  ),
                ),

                // Book Now button
                GestureDetector(
                  onTap: onBookNow,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      t.common.bookNow,
                      style: context.bold14.textOnPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
