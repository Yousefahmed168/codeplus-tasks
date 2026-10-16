import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/widgets/main_button.dart';
import '../../../../i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/my_icons.dart';

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
          // Top: photo + info
          Row(
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
                        errorWidget: (context, url, error) => Icon(
                          MyIcons.person,
                          size: 50.r,
                          color: AppColors.primary,
                        ),
                      )
                    : Image.asset(
                        imagePath,
                        width: 80.r,
                        height: 80.r,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          MyIcons.person,
                          size: 50.r,
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
                    Text(specialty, style: context.regular14.textSecondary),
                    8.verticalSpace,
                    // Stars
                    Row(
                      children: List.generate(
                        5,
                        (i) => Icon(
                          i < rating
                              ? MyIcons.starRounded
                              : MyIcons.starBorderRounded,
                          size: 20.r,
                          color: AppColors.star,
                        ),
                      ),
                    ),
                    4.verticalSpace,
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
                  isFavorite ? MyIcons.favorite : MyIcons.favoriteBorder,
                  color: isFavorite ? AppColors.error : AppColors.textHint,
                  size: 24.r,
                ),
              ),
            ],
          ),

          12.verticalSpace,

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
