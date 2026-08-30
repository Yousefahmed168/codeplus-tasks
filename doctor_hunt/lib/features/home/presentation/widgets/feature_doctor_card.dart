import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import 'package:gap/gap.dart';

class FeatureDoctorCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final double rating;
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
    this.isFavorite = false,
    this.onFavoriteTap,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 130,
        margin: const EdgeInsets.only(right: 5),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider, width: 2),
          boxShadow: [
            BoxShadow(
              color: AppColors.backgroundDark.withValues(alpha: (0.1)),
              blurRadius: 10,
              offset: const Offset(0, 3),
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
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    size: 16,
                    color: isFavorite ? AppColors.error : AppColors.textLight,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      size: 14,
                      color: AppColors.star,
                    ),
                    Gap(2),
                    Text(
                      rating.toStringAsFixed(1),
                      style: context.bold12.copyWith(
                        fontSize: 11,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Gap(5),

            // Circular Avatar
            ClipOval(
              child: imagePath.startsWith('http')
                  ? Image.network(
                      imagePath,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const Icon(
                        Icons.person,
                        size: 30,
                        color: AppColors.primary,
                      ),
                    )
                  : Image.asset(
                      imagePath,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const Icon(
                        Icons.person,
                        size: 30,
                        color: AppColors.primary,
                      ),
                    ),
            ),
            Gap(5),

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

            // Hourly Price Rate
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(text: '\$ ', style: context.medium12BlobGlow),
                  TextSpan(
                    text: '${hourlyRate.toStringAsFixed(2)}/ hr',
                    style: context.medium11,
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
