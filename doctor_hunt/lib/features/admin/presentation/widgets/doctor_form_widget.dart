import 'dart:io';

import 'package:doctor_hunt/core/widgets/custom_dropdown.dart';
import 'package:flutter/foundation.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/widgets/widgets.dart';

class DoctorFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  final TextEditingController nameCtrl;
  final TextEditingController feeCtrl;
  final String? selectedSpecialty;
  final ValueChanged<String?> onSpecialtyChanged;

  final String? imagePath; // local file path after picking
  final String? existingImageUrl; // only for Edit — pre-existing network image
  final VoidCallback onPickImage;

  final bool? isActive;
  final ValueChanged<bool>? onStatusChanged;

  // Submit button
  final bool isSubmitting;
  final String submitLabel;
  final String submittingLabel;
  final VoidCallback onSubmit;
  final VoidCallback? onDelete; // If provided, shows delete button

  const DoctorFormWidget({
    super.key,
    required this.formKey,
    required this.nameCtrl,
    required this.feeCtrl,
    required this.selectedSpecialty,
    required this.onSpecialtyChanged,
    required this.imagePath,
    required this.onPickImage,
    required this.isSubmitting,
    required this.submitLabel,
    required this.submittingLabel,
    required this.onSubmit,
    this.existingImageUrl,
    this.isActive,
    this.onStatusChanged,
    this.onDelete,
  });

  bool get _isEditMode => isActive != null;

  @override
  Widget build(BuildContext context) {
    final specialties = [
      'Cardiologist',
      'Dentist',
      'Dermatologist',
      'Neurologist',
      'Orthopedic',
      'Pediatrician',
      'Psychiatrist',
      'Surgeon',
    ];

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //  Avatar (Edit/Create picker)
          Center(
            child: GestureDetector(
              onTap: onPickImage,
              child: Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withValues(alpha: 0.1),
                      image: imagePath != null
                          ? DecorationImage(
                              image: kIsWeb
                                  ? NetworkImage(imagePath!) as ImageProvider
                                  : FileImage(File(imagePath!)),
                              fit: BoxFit.cover,
                            )
                          : (existingImageUrl != null &&
                                    existingImageUrl!.isNotEmpty
                                ? DecorationImage(
                                    image: CachedNetworkImageProvider(
                                      existingImageUrl!,
                                    ),
                                    fit: BoxFit.cover,
                                  )
                                : null),
                    ),
                    child:
                        imagePath == null &&
                            (existingImageUrl == null ||
                                existingImageUrl!.isEmpty)
                        ? const Icon(
                            Icons.person,
                            color: AppColors.primary,
                            size: 40,
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Gap(8),
          Center(
            child: TextButton(
              onPressed: onPickImage,
              child: Text(
                _isEditMode ? 'Tap photo to change' : 'Add photo',
                style: context.semiBold14.copyWith(color: AppColors.primary),
              ),
            ),
          ),
          const Gap(24),

          //    Name
          Text('DOCTOR NAME', style: context.semiBold12.textSecondary),
          const Gap(8),
          CustomTextFormField(
            controller: nameCtrl,
            hintText: 'e.g. Dr. Ahmed Ali',
            prefixIcon: const Icon(
              Icons.person_outline,
              color: AppColors.textHint,
              size: 20,
            ),
            validator: (v) {
              if (v == null || v.isEmpty) {
                return 'Please enter name';
              }
              return null;
            },
          ),
          const Gap(16),

          //    Specialty
          Text('SPECIALTY', style: context.semiBold12.textSecondary),
          const Gap(8),
          CustomDropdown<String>(
            value: selectedSpecialty,
            hintText: 'Select specialty',
            items: specialties,
            onChanged: onSpecialtyChanged,
            validator: (v) => v == null ? 'Please select a specialty' : null,
          ),
          const Gap(16),

          //    Consultation Fee
          Text('CONSULTATION FEE', style: context.semiBold12.textSecondary),
          const Gap(8),
          CustomTextFormField(
            controller: feeCtrl,
            hintText: 'e.g. \$28.00',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (v) {
              if (v == null || v.isEmpty) {
                return 'Please enter fee';
              }
              if (double.tryParse(v) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
          const Gap(16),

          if (_isEditMode && isActive != null && onStatusChanged != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isActive!
                          ? AppColors.success.withValues(alpha: 0.1)
                          : AppColors.error.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isActive!
                          ? Icons.check_circle_outline
                          : Icons.cancel_outlined,
                      color: isActive! ? AppColors.success : AppColors.error,
                      size: 20,
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Doctor Status',
                          style: context.semiBold14.textPrimary,
                        ),
                        Text(
                          isActive! ? 'Active & Available' : 'Inactive',
                          style: context.regular12.textSecondary,
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: isActive!,
                    onChanged: onStatusChanged,
                    activeThumbColor: AppColors.primary,
                  ),
                ],
              ),
            ),
            const Gap(24),
          ],

          //    Submit
          const Gap(16),
          MainButton(
            text: isSubmitting ? submittingLabel : submitLabel,
            onPressed: isSubmitting ? null : onSubmit,
          ),

          if (_isEditMode && onDelete != null) ...[
            const Gap(12),
            MainButton(
              text: 'Delete Doctor',
              onPressed: onDelete,
              bgColor: AppColors.error,
              textColor: Colors.white,
            ),
          ],
          const Gap(32),
        ],
      ),
    );
  }
}
