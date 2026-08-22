import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
          height: 80,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
            ),
            boxShadow: [
              BoxShadow(
                color: gradientColors.last.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: svgAssetPath != null
                ? SvgPicture.asset(
                    svgAssetPath!,
                    width: 36,
                    height: 36,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  )
                : Icon(
                    iconData ?? Icons.medical_services_outlined,
                    color: Colors.white,
                    size: 36,
                  ),
          ),
        ),
      ),
    );
  }
}
