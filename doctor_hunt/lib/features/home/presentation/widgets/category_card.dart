import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/constants/my_icons.dart';

class CategoryCard extends StatelessWidget {
  final String? svgAssetPath;
  final IconData? iconData;
  final List<Color> gradientColors;
  final VoidCallback? onTap;

  const CategoryCard({
    super.key,
    this.svgAssetPath,
    this.iconData,
    required this.gradientColors,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 80.h,
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
            ),
            boxShadow: [
              BoxShadow(
                color: gradientColors.last.withValues(alpha: 0.3),
                blurRadius: 10.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: Center(
            child: svgAssetPath != null
                ? SvgPicture.asset(
                    svgAssetPath!,
                    width: 36.r,
                    height: 36.r,
                    colorFilter: const ColorFilter.mode(
                      AppColors.textOnPrimary,
                      BlendMode.srcIn,
                    ),
                  )
                : Icon(
                    iconData ?? MyIcons.medicalServicesOutlined,
                    color: AppColors.textOnPrimary,
                    size: 36.r,
                  ),
          ),
        ),
      ),
    );
  }
}
