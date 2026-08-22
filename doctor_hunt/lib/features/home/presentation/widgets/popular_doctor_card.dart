import 'package:flutter/material.dart';
import 'package:doctor_hunt/core/theme/colors.dart';
import 'package:doctor_hunt/core/theme/style_atoms.dart';
import 'package:gap/gap.dart';

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
        width: 175,
        margin: const EdgeInsets.only(right: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Doctor Image Container
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Container(
                height: 140,
                width: double.infinity,
                color: AppColors.background,
                child: Image.asset(imagePath, fit: BoxFit.fill),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
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
                  Gap(2),
                  Text(
                    specialty,
                    style: context.regular12.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Gap(6),
                  // Rating Stars
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return Icon(
                        index < rating.floor()
                            ? Icons.star_rounded
                            : (index < rating
                                  ? Icons.star_half_rounded
                                  : Icons.star_outline_rounded),
                        color: AppColors.star,
                        size: 14,
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
