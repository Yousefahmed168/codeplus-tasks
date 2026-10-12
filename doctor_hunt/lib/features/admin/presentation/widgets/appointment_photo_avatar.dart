import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';

class AppointmentPhotoAvatar extends StatelessWidget {
  const AppointmentPhotoAvatar({
    super.key,
    required this.name,
    this.imageUrl,
  });

  final String name;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        width: 64.w,
        height: 64.h,
        color: AppColors.mintTileBackground,
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                width: 64.w,
                height: 64.h,
                fit: BoxFit.cover,
                errorWidget: (_, _, _) => _FallbackInitial(name: name),
              )
            : _FallbackInitial(name: name),
      ),
    );
  }
}

class _FallbackInitial extends StatelessWidget {
  const _FallbackInitial({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: context.bold24.copyWith(color: AppColors.emeraldGreen),
      ),
    );
  }
}
