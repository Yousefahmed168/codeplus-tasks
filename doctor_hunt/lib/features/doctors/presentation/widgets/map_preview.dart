import 'package:doctor_hunt/core/theme/colors.dart';
import 'package:flutter/material.dart';

class MapPreview extends StatelessWidget {
  const MapPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.surfaceVariant,
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Map placeholder with grid pattern
            CustomPaint(painter: _MapGridPainter()),

            // Center pin
            const Center(
              child: Icon(
                Icons.location_on_rounded,
                size: 40,
                color: AppColors.primary,
              ),
            ),

            // Road lines
            Positioned(
              top: 40,
              left: 0,
              right: 0,
              child: Container(
                height: 3,
                color: AppColors.border.withValues(alpha: 0.5),
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              left: 60,
              child: Container(
                width: 3,
                color: AppColors.border.withValues(alpha: 0.5),
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              right: 80,
              child: Container(
                width: 3,
                color: AppColors.border.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.border.withValues(alpha: 0.15)
      ..strokeWidth = 1;

    // Horizontal lines
    for (double y = 0; y < size.height; y += 20) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Vertical lines
    for (double x = 0; x < size.width; x += 20) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
