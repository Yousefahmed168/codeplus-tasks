import '../../../../core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

class MapPreview extends StatelessWidget {
  const MapPreview({super.key});

  @override
  Widget build(BuildContext context) {
    // Example coordinates for a doctor's clinic
    final clinicLocation = const LatLng(29.337383058534286, 30.854864845451573);

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
        child: FlutterMap(
          options: MapOptions(
            initialCenter: clinicLocation,
            initialZoom: 13.0,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.doctor_hunt.app',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: clinicLocation,
                  width: 40,
                  height: 40,
                  child: const Icon(
                    Icons.location_on_rounded,
                    size: 40,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
