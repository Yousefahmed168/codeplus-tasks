import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/widgets/main_button.dart';
import '../../../../core/widgets/rating_stars.dart';
import '../../../../i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/my_icons.dart';

/// Header card on the doctor details screen: photo, name, specialty,
/// rating with review count, consultation fee and the primary booking CTA.
class DoctorInfoCard extends StatelessWidget {
  const DoctorInfoCard({
    super.key,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.reviewsCount,
    required this.consultationFee,
    required this.imagePath,
    this.isFavorite = false,
    this.onFavoriteToggle,
    this.onBookNow,
  });

  final String name;
  final String specialty;
  final double rating;
  final int reviewsCount;
  final double consultationFee;
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
          Row(
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
                    Text(specialty, style: context.regular14.textSecondary),
                    8.verticalSpace,
                    Row(
                      children: [
                        RatingStars(rating: rating, size: 18),
                        6.horizontalSpace,
                        Text(
                          rating.toStringAsFixed(1),
                          style: context.bold12.textPrimary,
                        ),
                      ],
                    ),
                    2.verticalSpace,
                    Text(
                      t.doctorDetails.reviewsCount(count: reviewsCount),
                      style: context.regular11.textSecondary,
                    ),
                    6.verticalSpace,
                    Text(
                      t.doctorDetails.consultationFee,
                      style: context.regular11.textHint,
                    ),
                    Text(
                      t.common.amount(amount: consultationFee.toStringAsFixed(2)),
                      style: context.bold16.primary,
                    ),
                  ],
                ),
              ),
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

  Widget _avatarPlaceholder() => Container(
    width: 80.r,
    height: 80.r,
    color: AppColors.primary.withValues(alpha: 0.1),
    child: Icon(MyIcons.person, size: 50.r, color: AppColors.primary),
  );
}
