import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/widgets/widgets.dart';
import '../../data/models/patient_model.dart';
import '../cubit/patient_profile_cubit.dart';

class PatientProfileEditForm extends StatelessWidget {
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
  final VoidCallback onSaved;

  const PatientProfileEditForm({
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
    required this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(8),
          Text('Edit Profile', style: context.semiBold16.textPrimary),
          const Gap(16),
          _field(context, 'Full Name', nameCtrl, Icons.person_rounded),
          const Gap(12),
          _field(
            context,
            'Phone',
            phoneCtrl,
            Icons.phone_rounded,
            keyboardType: TextInputType.phone,
          ),
          const Gap(12),
          _field(
            context,
            'Age',
            ageCtrl,
            Icons.cake_rounded,
            keyboardType: TextInputType.number,
          ),
          const Gap(12),
          _field(context, 'City', cityCtrl, Icons.location_city_rounded),
          const Gap(12),
          _field(
            context,
            'Bio',
            bioCtrl,
            Icons.info_outline_rounded,
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
          const Gap(24),
          SizedBox(
            width: double.infinity,
            child: MainButton(
              text: 'Save Changes',
              onPressed: isSaving
                  ? null
                  : () async {
                      if (patient == null) return;
                      await context.read<PatientProfileCubit>().updateProfile(
                        currentPatient: patient!,
                        name: nameCtrl.text,
                        phone: phoneCtrl.text,
                        age: ageCtrl.text,
                        city: cityCtrl.text,
                        bio: bioCtrl.text,
                        gender: selectedGender,
                        localImagePath: localImagePath,
                      );
                      onSaved();
                    },
            ),
          ),
          const Gap(32),
        ],
      ),
    );
  }

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

  Widget _field(
    BuildContext context,
    String label,
    TextEditingController controller,
    IconData icon, {
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}
