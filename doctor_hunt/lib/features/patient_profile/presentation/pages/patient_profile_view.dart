import '../../../auth/data/models/patient_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../i18n/strings.g.dart';

class PatientProfileView extends StatelessWidget {
  final PatientModel? patient;
  final bool isSaving;
  final TextEditingController nameCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController ageCtrl;
  final TextEditingController cityCtrl;
  final TextEditingController bioCtrl;
  final int? selectedGender;
  final String? localImagePath;
  final ValueChanged<int> onGenderChanged;
  final VoidCallback onSave;
  final VoidCallback onLogoutTap;

  const PatientProfileView({
    super.key,
    required this.patient,
    required this.isSaving,
    required this.nameCtrl,
    required this.phoneCtrl,
    required this.ageCtrl,
    required this.cityCtrl,
    required this.bioCtrl,
    required this.selectedGender,
    required this.localImagePath,
    required this.onGenderChanged,
    required this.onSave,
    required this.onLogoutTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title: Personal Information
          Text(
            t.patientProfile.personalInfo,
            style: context.medium18BackgroundDark.textPrimary,
          ),
          const Gap(6),

          // Personal Info Form Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextFormField(
                  controller: nameCtrl,
                  hintText: t.common.name,
                  prefixIcon: Icon(
                    Icons.person_rounded,
                    color: AppColors.primary,
                  ),
                ),
                const Gap(12),
                CustomTextFormField(
                  controller: phoneCtrl,
                  hintText: t.patientProfile.contactNumber,
                  prefixIcon: Icon(
                    Icons.phone_rounded,
                    color: AppColors.primary,
                  ),

                  keyboardType: TextInputType.phone,
                ),
                const Gap(12),
                CustomTextFormField(
                  controller: ageCtrl,
                  hintText: t.patientProfile.dateOfBirth,
                  prefixIcon: Icon(
                    Icons.cake_rounded,
                    color: AppColors.primary,
                  ),
                  keyboardType: TextInputType.number,
                ),

                const Gap(12),
                CustomTextFormField(
                  controller: cityCtrl,
                  hintText: t.patientProfile.location,
                  prefixIcon: Icon(
                    Icons.location_city_rounded,
                    color: AppColors.primary,
                  ),
                ),
                const Gap(12),
                CustomTextFormField(
                  controller: bioCtrl,
                  hintText: 'Bio',
                  prefixIcon: Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.primary,
                  ),
                  maxLines: 3,
                ),
                const Gap(16),
                Text('Gender', style: context.semiBold14.textSecondary),
                const Gap(8),
                Row(
                  children: [
                    _genderChip(context, 0, 'Male', Icons.male_rounded),
                    const Gap(12),
                    _genderChip(context, 1, 'Female', Icons.female_rounded),
                  ],
                ),
                const Gap(20),
                SizedBox(
                  width: double.infinity,
                  child: MainButton(
                    text: 'Save Changes',
                    onPressed: isSaving ? null : onSave,
                  ),
                ),
              ],
            ),
          ),

          const Gap(24),

          // Quick Navigation Menu Section
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildMenuItem(
                  context,
                  icon: Icons.people_outline_rounded,
                  title: t.patientProfile.myDoctors,
                  onTap: () {
                    context.push(AppRoutes.search);
                  },
                ),
                _divider,
                _buildMenuItem(
                  context,
                  icon: Icons.assignment_outlined,
                  title: t.patientProfile.medicalRecords,
                  onTap: () {},
                ),
                _divider,
                _buildMenuItem(
                  context,
                  icon: Icons.payment_rounded,
                  title: t.patientProfile.payments,
                  onTap: () {},
                ),
                _divider,
                _buildMenuItem(
                  context,
                  icon: Icons.security_rounded,
                  title: t.patientProfile.privacyPolicy,
                  onTap: () {
                    context.push(AppRoutes.privacyPolicy);
                  },
                ),
                _divider,
                _buildMenuItem(
                  context,
                  icon: Icons.help_outline_rounded,
                  title: t.patientProfile.helpCenter,
                  onTap: () {
                    context.push(AppRoutes.helpCenter);
                  },
                ),
                _divider,
                _buildMenuItem(
                  context,
                  icon: Icons.settings_outlined,
                  title: t.patientProfile.settings,
                  onTap: () {
                    context.push(AppRoutes.patientSettings);
                  },
                ),
                _divider,
                // Logout Card / Row
                _buildMenuItem(
                  context,
                  icon: Icons.logout_rounded,
                  title: t.common.logout,
                  iconColor: AppColors.error,
                  textColor: AppColors.error,
                  onTap: onLogoutTap,
                ),
              ],
            ),
          ),

          const Gap(32),
        ],
      ),
    );
  }

  Widget get _divider =>
      Divider(height: 1, indent: 54, color: AppColors.divider);

  Widget _genderChip(
    BuildContext context,
    int value,
    String label,
    IconData icon,
  ) {
    final selected = selectedGender == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => onGenderChanged(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: selected ? Colors.white : AppColors.textSecondary,
                size: 20,
              ),
              const Gap(6),
              Text(
                label,
                style: context.semiBold14.copyWith(
                  color: selected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    final effectiveIconColor = iconColor ?? AppColors.primary;
    final effectiveTextColor = textColor ?? AppColors.textPrimary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: effectiveIconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: effectiveIconColor, size: 20),
            ),
            const Gap(14),
            Expanded(
              child: Text(
                title,
                style: context.semiBold14.copyWith(color: effectiveTextColor),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
