import '../../../../core/theme/colors.dart';
import '../../../../i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LiveDoctorCard extends StatelessWidget {
  final String imagePath;
  final VoidCallback? onTap;

  const LiveDoctorCard({super.key, required this.imagePath, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 160,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: BoxBorder.all(color: AppColors.divider),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.fill,
          ),
        ),
        child: Stack(
          children: [
            // Live Badge (Top Right)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.circle, size: 6, color: Colors.white),
                    Gap(4),
                    Text(
                      t.home.live,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Center Play Icon Button
            Center(
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.75),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
