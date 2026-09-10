import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../features/doctors/models/doctor.dart';

class AdminDoctorCard extends StatelessWidget {
  const AdminDoctorCard({
    super.key,
    required this.doctor,
    required this.onDelete,
    required this.onEdit,
  });

  final Doctor doctor;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 56,
            height: 56,
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
                ? Icon(Icons.person, color: AppColors.primary, size: 28)
                : null,
          ),
          const Gap(16),

          // Name + Specialization
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dr. ${doctor.name ?? 'Unknown'}',
                  style: context.semiBold16.textPrimary,
                ),
                const Gap(4),
                Text(
                  doctor.specialization ?? 'General',
                  style: context.regular14.textSecondary,
                ),
                const Gap(4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Active',
                    style: context.regular11.copyWith(color: AppColors.success),
                  ),
                ),
              ],
            ),
          ),

          // 3-dot menu
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') onEdit();
              if (value == 'delete') onDelete();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'edit', child: Text('Edit')),
              PopupMenuItem(
                value: 'delete',
                child: Text('Delete', style: context.regular12.copyWith(color: AppColors.error)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
