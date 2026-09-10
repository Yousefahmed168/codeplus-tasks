import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../data/models/patient_model.dart';

class PatientProfileView extends StatelessWidget {
  final PatientModel patient;

  const PatientProfileView({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    final p = patient;
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(8),
          _sectionTitle(context, 'Personal Information'),
          const Gap(12),
          _infoCard([
            _infoRow(context, Icons.phone_rounded, 'Phone', p.phone),
            _divider,
            _infoRow(
              context,
              Icons.cake_rounded,
              'Age',
              p.age != null ? '${p.age} years' : null,
            ),
            _divider,
            _infoRow(
              context,
              Icons.person_outline_rounded,
              'Gender',
              p.gender == 0
                  ? 'Male'
                  : p.gender == 1
                  ? 'Female'
                  : null,
            ),
            _divider,
            _infoRow(context, Icons.location_city_rounded, 'City', p.city),
          ]),
          const Gap(20),
          if (p.bio != null && p.bio!.isNotEmpty) ...[
            _sectionTitle(context, 'About'),
            const Gap(12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
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
              child: Text(p.bio!, style: context.regular14.textBody),
            ),
            const Gap(20),
          ],
          _sectionTitle(context, 'Account'),
          const Gap(12),
          _infoCard([
            _infoRow(context, Icons.email_rounded, 'Email', p.email),
          ]),
          const Gap(32),
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String title) =>
      Text(title, style: context.semiBold16.textPrimary);

  Widget get _divider =>
      Divider(height: 1, indent: 56, color: AppColors.divider);

  Widget _infoCard(List<Widget> children) => Container(
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
    child: Column(children: children),
  );

  Widget _infoRow(
    BuildContext context,
    IconData icon,
    String label,
    String? value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          const Gap(12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: context.regular12.textSecondary),
              const Gap(2),
              Text(value ?? '—', style: context.semiBold14.textPrimary),
            ],
          ),
        ],
      ),
    );
  }
}
