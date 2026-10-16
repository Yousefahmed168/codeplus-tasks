import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/constants/my_icons.dart';

class HomeBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final int favoritesCount;
  final ValueChanged<int>? onTap;

  const HomeBottomNavBar({
    super.key,
    this.currentIndex = 0,
    this.favoritesCount = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72.h,
      margin: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.08),
            blurRadius: 20.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavBarItem(
            icon: MyIcons.homeRounded,
            isSelected: currentIndex == 0,
            onTap: () => onTap?.call(0),
          ),
          _NavBarItem(
            icon: MyIcons.favoriteRounded,
            isSelected: currentIndex == 1,
            badgeCount: favoritesCount,
            onTap: () => onTap?.call(1),
          ),
          _NavBarItem(
            icon: MyIcons.menuBookRounded,
            isSelected: currentIndex == 2,
            onTap: () => onTap?.call(2),
          ),
          _NavBarItem(
            icon: MyIcons.settingsRounded,
            isSelected: currentIndex == 3,
            onTap: () => onTap?.call(3),
          ),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final bool isSelected;
  final int badgeCount;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.isSelected,
    this.badgeCount = 0,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 48.r,
        height: 48.r,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            isSelected
                ? Container(
                    width: 48.r,
                    height: 48.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.primary.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                    child: Icon(icon, color: AppColors.textOnPrimary, size: 24.r),
                  )
                : Icon(icon, color: AppColors.textLight, size: 24.r),
            // Badge
            if (badgeCount > 0)
              Positioned(
                top: -4.h,
                right: -4.w,
                child: Container(
                  constraints: BoxConstraints(
                    minWidth: 18.r,
                    minHeight: 18.r,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.surface, width: 2.w),
                  ),
                  child: Center(
                    child: Text(
                      badgeCount > 99 ? '99+' : '$badgeCount',
                      style: context.bold11.copyWith(
                        color: AppColors.textOnPrimary,
                        height: 1,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
