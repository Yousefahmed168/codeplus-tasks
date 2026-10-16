import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/widgets/rating_stars.dart';
import '../../../../core/constants/my_icons.dart';
import '../../../../i18n/strings.g.dart';

/// Compact doctor summary shown at the top of the booking flow.
class DoctorProfileHeader extends StatelessWidget {
  const DoctorProfileHeader({
    super.key,
    required this.name,
    required this.clinic,
    required this.rating,
    required this.imagePath,
    this.reviewsCount = 0,
    this.isFavorite = false,
    this.onFavoriteToggle,
  });

  final String name;
  final String clinic;
  final double rating;
  final int reviewsCount;
  final String imagePath;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.04),
            blurRadius: 10.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: imagePath.startsWith('http')
                ? CachedNetworkImage(
                    imageUrl: imagePath,
                    width: 80.r,
                    height: 80.r,
                    fit: BoxFit.cover,
                    errorWidget: (_, _, _) => _avatarPlaceholder(),
                  )
                : Image.asset(
                    imagePath,
                    width: 80.r,
                    height: 80.r,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => _avatarPlaceholder(),
                  ),
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: context.bold18.textPrimary),
                4.verticalSpace,
                Text(clinic, style: context.regular12.textSecondary),
                8.verticalSpace,
                Row(
                  children: [
                    RatingStars(rating: rating, size: 16),
                    6.horizontalSpace,
                    Text(
                      t.doctorDetails.reviewsCount(count: reviewsCount),
                      style: context.regular11.textSecondary,
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onFavoriteToggle,
            child: Icon(
              isFavorite ? MyIcons.favorite : MyIcons.favoriteBorder,
              color: isFavorite ? AppColors.error : AppColors.textHint,
              size: 20.r,
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatarPlaceholder() => Container(
    width: 80.r,
    height: 80.r,
    color: AppColors.primary.withValues(alpha: 0.1),
    child: Icon(MyIcons.person, size: 80.r, color: AppColors.primary),
  );
}
