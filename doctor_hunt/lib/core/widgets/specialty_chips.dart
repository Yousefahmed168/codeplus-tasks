import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/colors.dart';
import '../theme/style_atoms.dart';

/// Horizontal, single-select specialty filter used by Home and Discovery.
///
/// Tapping the leading [allLabel] chip clears the filter ([onSelected] is
/// called with `null`).
class SpecialtyChips extends StatelessWidget {
  final List<String> specialties;
  final String? selected;
  final String allLabel;
  final ValueChanged<String?> onSelected;

  const SpecialtyChips({
    super.key,
    required this.specialties,
    required this.selected,
    required this.allLabel,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: specialties.length + 1,
        separatorBuilder: (_, _) => 8.horizontalSpace,
        itemBuilder: (context, index) {
          final isAll = index == 0;
          final String? value = isAll ? null : specialties[index - 1];
          return _SpecialtyChip(
            label: isAll ? allLabel : specialties[index - 1],
            isSelected: selected == value,
            onTap: () => onSelected(value),
          );
        },
      ),
    );
  }
}

class _SpecialtyChip extends StatelessWidget {
  const _SpecialtyChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: context.regular12.copyWith(
            color: isSelected ? AppColors.textOnPrimary : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
