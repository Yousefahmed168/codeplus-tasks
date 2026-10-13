import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';

class DoctorProfileHeader extends StatelessWidget {
  const DoctorProfileHeader({
    super.key,
    required this.name,
    required this.clinic,
    required this.rating,
    required this.imagePath,
    this.isFavorite = false,
    this.onFavoriteToggle,
  });

  final String name;
  final String clinic;
  final int rating;
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
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Doctor photo
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: imagePath.startsWith('http')
                ? CachedNetworkImage(
                    imageUrl: imagePath,
                    width: 80.r,
                    height: 80.r,
                    fit: BoxFit.cover,
                    errorWidget: (_, _, _) => Icon(
                      Icons.person,
                      size: 80.r,
                      color: AppColors.primary,
                    ),
                  )
                : Image.asset(
                    imagePath,
                    width: 80.r,
                    height: 80.r,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Icon(
                      Icons.person,
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
                Text(name, style: context.bold18.textPrimary),
                4.verticalSpace,
                Text(clinic, style: context.regular12.textSecondary),
                8.verticalSpace,
                // Stars
                Row(
                  children: List.generate(
                    5,
                    (i) => Icon(
                      i < rating
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      size: 16.r,
                      color: AppColors.star,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Heart
          GestureDetector(
            onTap: onFavoriteToggle,
            child: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? AppColors.error : AppColors.textHint,
              size: 20.r,
            ),
          ),
        ],
      ),
    );
  }
}
