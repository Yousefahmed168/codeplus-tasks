import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/widgets/main_button.dart';
import '../../../../i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gap/gap.dart';

class DoctorInfoCard extends StatelessWidget {
  const DoctorInfoCard({
    super.key,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.hourlyRate,
    required this.imagePath,
    this.isFavorite = false,
    this.onFavoriteToggle,
    this.onBookNow,
  });

  final String name;
  final String specialty;
  final int rating;
  final double hourlyRate;
  final String imagePath;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onBookNow;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // Top: photo + info
          Row(
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
                        errorWidget: (context, url, error) => Icon(
                          Icons.person,
                          size: 50,
                          color: AppColors.primary,
                        ),
                      )
                    : Image.asset(
                        imagePath,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.person,
                          size: 50,
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
                    Text(name, style: context.bold18.textPrimary),
                    Gap(4),
                    Text(specialty, style: context.regular14.textSecondary),
                    Gap(8),
                    // Stars
                    Row(
                      children: List.generate(
                        5,
                        (i) => Icon(
                          i < rating
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          size: 20,
                          color: AppColors.star,
                        ),
                      ),
                    ),
                    Gap(4),
                    Text(
                      t.doctorDetails.perHour(
                        price: hourlyRate.toStringAsFixed(2),
                      ),
                      style: context.bold16.primary,
                    ),
                  ],
                ),
              ),

              // Heart
              GestureDetector(
                onTap: onFavoriteToggle,
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : AppColors.textHint,
                  size: 24,
                ),
              ),
            ],
          ),

          Gap(12),

          // Book Now button
          MainButton(
            text: t.common.bookNow,
            onPressed: onBookNow,
            bgColor: AppColors.primary,
            textColor: AppColors.textOnPrimary,
          ),
        ],
      ),
    );
  }
}
