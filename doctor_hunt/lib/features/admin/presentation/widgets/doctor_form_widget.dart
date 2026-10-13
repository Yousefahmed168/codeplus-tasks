import 'dart:io';

import '../../../../core/widgets/custom_dropdown.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../i18n/strings.g.dart';

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
                    width: 100.r,
                    height: 100.r,
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
                        ? Icon(
                            Icons.person,
                            color: AppColors.primary,
                            size: 40.r,
                          )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(6.r),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        color: AppColors.textOnPrimary,
                        size: 16.r,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          8.verticalSpace,
          Center(
            child: TextButton(
              onPressed: onPickImage,
              child: Text(
                _isEditMode
                    ? t.admin.createDoctor.tapPhotoToChange
                    : t.admin.createDoctor.addPhoto,
                style: context.semiBold14.copyWith(color: AppColors.primary),
              ),
            ),
          ),
          24.verticalSpace,

          //    Name
          Text(t.admin.createDoctor.nameLabel.toUpperCase(), style: context.semiBold12.textSecondary),
          8.verticalSpace,
          CustomTextFormField(
            controller: nameCtrl,
            hintText: t.admin.createDoctor.nameHint,
            prefixIcon: Icon(
              Icons.person_outline,
              color: AppColors.textHint,
              size: 20.r,
            ),
            validator: (v) {
              if (v == null || v.isEmpty) {
                return t.common.validation.fieldRequired(field: t.admin.createDoctor.nameLabel);
              }
              return null;
            },
          ),
          16.verticalSpace,

          //    Specialty
          Text(t.admin.createDoctor.specialtyLabel.toUpperCase(), style: context.semiBold12.textSecondary),
          8.verticalSpace,
          CustomDropdown<String>(
            value: selectedSpecialty,
            hintText: t.admin.createDoctor.specialtyHint,
            items: specialties,
            onChanged: onSpecialtyChanged,
            validator: (v) => v == null ? t.admin.createDoctor.specialtyHint : null,
          ),
          16.verticalSpace,

          //    Consultation Fee
          Text(t.admin.createDoctor.feeLabel.toUpperCase(), style: context.semiBold12.textSecondary),
          8.verticalSpace,
          CustomTextFormField(
            controller: feeCtrl,
            hintText: t.admin.createDoctor.feeHint,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (v) {
              if (v == null || v.isEmpty) {
                return t.common.validation.fieldRequired(field: t.admin.createDoctor.feeLabel);
              }
              if (double.tryParse(v) == null) {
                return t.common.validation.invalidNumber;
              }
              return null;
            },
          ),
          16.verticalSpace,

          if (_isEditMode && isActive != null && onStatusChanged != null) ...[
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.r),
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
                      size: 20.r,
                    ),
                  ),
                  12.horizontalSpace,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.admin.createDoctor.statusLabel,
                          style: context.semiBold14.textPrimary,
                        ),
                        Text(
                          isActive! ? t.admin.createDoctor.statusSubtitle : t.admin.doctorDetails.inactive,
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
            24.verticalSpace,
          ],

          //    Submit
          16.verticalSpace,
          MainButton(
            text: isSubmitting ? submittingLabel : submitLabel,
            onPressed: isSubmitting ? null : onSubmit,
          ),

          if (_isEditMode && onDelete != null) ...[
            12.verticalSpace,
            MainButton(
              text: t.admin.editDoctor.deleteBtn,
              onPressed: onDelete,
              bgColor: AppColors.error,
              textColor: AppColors.textOnPrimary,
            ),
          ],
          32.verticalSpace,
        ],
      ),
    );
  }
}
