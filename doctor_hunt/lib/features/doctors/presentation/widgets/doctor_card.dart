import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../models/doctor.dart';
import '../../../../i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
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
                  borderRadius: BorderRadius.circular(12),
                  child: doctor.imagePath.startsWith('http')
                      ? Image.network(
                          doctor.imagePath,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Icon(
                            Icons.person,
                            size: 80,
                            color: AppColors.primary,
                          ),
                        )
                      : Image.asset(
                          doctor.imagePath,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Icon(
                            Icons.person,
                            size: 80,
                            color: AppColors.primary,
                          ),
                        ),
                ),
                Gap(12),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(doctor.name, style: context.bold16.textPrimary),
                      Gap(2),
                      Text(doctor.specialty, style: context.regular14.primary),
                      Gap(4),
                      Text(
                        t.findDoctors.yearsExperience(
                          count: doctor.yearsExperience.toString(),
                        ),
                        style: context.regular12.textSecondary,
                      ),
                      Gap(6),
                      Row(
                        children: [
                          Icon(Icons.circle, size: 6, color: AppColors.primary),
                          Gap(4),
                          Text(
                            '${doctor.ratingPercentage.round()}%',
                            style: context.regular12.textSecondary,
                          ),
                          Gap(8),
                          Icon(Icons.circle, size: 6, color: AppColors.primary),
                          Gap(4),
                          Text(
                            t.findDoctors.patientStories(
                              count: doctor.patientStories.toString(),
                            ),
                            style: context.regular12.textSecondary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Favorite heart
                GestureDetector(
                  onTap: onFavoriteToggle,
                  child: Icon(
                    doctor.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: doctor.isFavorite ? Colors.red : AppColors.textHint,
                    size: 24,
                  ),
                ),
              ],
            ),

            Gap(12),
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
                      Gap(2),
                      Text(
                        t.findDoctors.timeTomorrow(
                          time: doctor.nextAvailableTime,
                        ),
                        style: context.medium14.textPrimary,
                      ),
                    ],
                  ),
                ),

                // Book Now button
                GestureDetector(
                  onTap: onBookNow,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
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
