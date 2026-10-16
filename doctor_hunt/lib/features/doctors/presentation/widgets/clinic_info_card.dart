import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/my_icons.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../i18n/strings.g.dart';

/// Read-only clinic block on the doctor details screen. Every doctor shown to
/// patients shares the single central clinic location.
class ClinicInfoCard extends StatelessWidget {
  const ClinicInfoCard({
    super.key,
    required this.location,
    required this.workingDays,
    required this.startTime,
    required this.endTime,
  });

  final String location;
  final List<String> workingDays;
  final String startTime;
  final String endTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.06),
            blurRadius: 12.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.doctorDetails.clinicInfo,
            style: context.bold16.textPrimary,
          ),
          12.verticalSpace,
          _InfoRow(
            icon: MyIcons.locationOnOutlined,
            label: t.doctorDetails.location,
            value: location,
          ),
          12.verticalSpace,
          _InfoRow(
            icon: MyIcons.calendarMonthRounded,
            label: t.doctorDetails.workingDays,
            value: workingDays.join(', '),
          ),
          12.verticalSpace,
          _InfoRow(
            icon: MyIcons.scheduleRounded,
            label: t.doctorDetails.workingHours,
            value: '$startTime - $endTime',
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18.r, color: AppColors.primary),
        10.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: context.regular11.textHint),
              2.verticalSpace,
              Text(
                value.isEmpty ? t.common.notProvided : value,
                style: context.semiBold12.textPrimary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
