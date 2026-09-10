import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gap/gap.dart';

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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Doctor photo
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: imagePath.startsWith('http')
                ? CachedNetworkImage(
                    imageUrl: imagePath,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorWidget: (_, _, _) => const Icon(
                      Icons.person,
                      size: 80,
                      color: AppColors.primary,
                    ),
                  )
                : Image.asset(
                    imagePath,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const Icon(
                      Icons.person,
                      size: 80,
                      color: AppColors.primary,
                    ),
                  ),
          ),
          const Gap(12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: context.bold18.textPrimary),
                const Gap(4),
                Text(clinic, style: context.regular12.textSecondary),
                const Gap(8),
                // Stars
                Row(
                  children: List.generate(
                    5,
                    (i) => Icon(
                      i < rating
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      size: 16,
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
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
