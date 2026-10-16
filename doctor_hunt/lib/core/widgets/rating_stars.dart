import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/my_icons.dart';
import '../theme/colors.dart';

/// Read-only 5-star display with half-star support, shared by every screen
/// that surfaces a doctor's rating.
class RatingStars extends StatelessWidget {
  final double rating;
  final double size;
  final int starCount;

  const RatingStars({
    super.key,
    required this.rating,
    this.size = 16,
    this.starCount = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(starCount, (index) {
        final threshold = index + 1;
        final IconData icon;
        if (rating >= threshold) {
          icon = MyIcons.starRounded;
        } else if (rating >= threshold - 0.5) {
          icon = MyIcons.starHalfRounded;
        } else {
          icon = MyIcons.starBorderRounded;
        }
        return Padding(
          padding: EdgeInsets.only(right: index == starCount - 1 ? 0 : 2.w),
          child: Icon(icon, size: size.r, color: AppColors.star),
        );
      }),
    );
  }
}
