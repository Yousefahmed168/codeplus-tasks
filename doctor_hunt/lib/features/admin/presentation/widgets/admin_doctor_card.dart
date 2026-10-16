import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/models/doctor.dart';
import '../../../../i18n/strings.g.dart';
import '../../../../core/constants/my_icons.dart';

class AdminDoctorCard extends StatelessWidget {
  const AdminDoctorCard({
    super.key,
    required this.doctor,
    required this.onEdit,
    required this.onToggleStatus,
  });

  final Doctor doctor;
  final VoidCallback onEdit;
  final VoidCallback onToggleStatus;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.05),
            blurRadius: 10.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 56.r,
            height: 56.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.1),
              image: doctor.imageUrl != null && doctor.imageUrl!.isNotEmpty
                  ? DecorationImage(
                      image: CachedNetworkImageProvider(doctor.imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: doctor.imageUrl == null || doctor.imageUrl!.isEmpty
                ? Icon(MyIcons.person, color: AppColors.primary, size: 28.r)
                : null,
          ),
          16.horizontalSpace,

          // Name + Specialization
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.name ?? '',
                  style: context.semiBold16.textPrimary,
                ),
                4.verticalSpace,
                Text(
                  doctor.specialization ?? '',
                  style: context.regular14.textSecondary,
                ),
                4.verticalSpace,
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: (doctor.isActive ? AppColors.success : AppColors.error)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    doctor.isActive
                        ? t.admin.doctors.active
                        : t.admin.doctorDetails.inactive,
                    style: context.regular11.copyWith(
                      color: doctor.isActive
                          ? AppColors.success
                          : AppColors.error,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 3-dot menu
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') onEdit();
              if (value == 'status') onToggleStatus();
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'edit', child: Text(t.common.edit)),
              PopupMenuItem(
                value: 'status',
                child: Text(
                  doctor.isActive
                      ? t.admin.doctors.deactivate
                      : t.admin.doctors.activate,
                  style: context.regular12.copyWith(
                    color: doctor.isActive
                        ? AppColors.error
                        : AppColors.success,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
