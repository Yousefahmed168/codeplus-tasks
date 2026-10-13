import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../models/doctor.dart';

class FavoriteDoctorGridCard extends StatelessWidget {
  const FavoriteDoctorGridCard({
    super.key,
    required this.doctor,
    this.onTap,
    this.onFavoriteToggle,
  });

  final Doctor doctor;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipOval(
                    child: Image.asset(
                      doctor.imageUrl ?? 'assets/images/doctor.png',
                      width: 80.r,
                      height: 80.r,
                      fit: BoxFit.cover,
                    ),
                  ),
                  12.verticalSpace,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Text(
                      doctor.name ?? 'Unknown',
                      style: context.bold16.textPrimary,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  4.verticalSpace,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Text(
                      doctor.specialization ?? 'General',
                      style: context.regular12.primary,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 12.h,
              right: 12.w,
              child: GestureDetector(
                onTap: onFavoriteToggle,
                child: Icon(
                  doctor.isFavorite
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: doctor.isFavorite
                      ? AppColors.error
                      : AppColors.textSecondary,
                  size: 20.r,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
