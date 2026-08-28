import '../../../../core/theme/colors.dart';
import 'package:flutter/material.dart';

class HomeBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const HomeBottomNavBar({super.key, this.currentIndex = 0, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavBarItem(
            icon: Icons.home_rounded,
            isSelected: currentIndex == 0,
            onTap: () => onTap?.call(0),
          ),
          _NavBarItem(
            icon: Icons.favorite_rounded,
            isSelected: currentIndex == 1,
            onTap: () => onTap?.call(1),
          ),
          _NavBarItem(
            icon: Icons.menu_book_rounded,
            isSelected: currentIndex == 2,
            onTap: () => onTap?.call(2),
          ),
          _NavBarItem(
            icon: Icons.chat_bubble_rounded,
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
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: isSelected
          ? Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withValues(alpha: 0.7),
                  ],
                ),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            )
          : Icon(icon, color: AppColors.textLight, size: 24),
    );
  }
}
