import 'package:doctor_hunt/core/theme/colors.dart';
import 'package:doctor_hunt/core/theme/style_atoms.dart';
import 'package:doctor_hunt/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class StatsRow extends StatelessWidget {
  const StatsRow({
    super.key,
    required this.running,
    required this.ongoing,
    required this.patients,
  });

  final int running;
  final int ongoing;
  final int patients;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatItem(value: '$running', label: t.doctorDetails.running),
        _StatItem(value: '$ongoing', label: t.doctorDetails.ongoing),
        _StatItem(value: '$patients', label: t.doctorDetails.patient),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: Column(
          children: [
            Text(value, style: context.bold22.textPrimary),
            Gap(4),
            Text(label, style: context.regular12.textSecondary),
          ],
        ),
      ),
    );
  }
}
