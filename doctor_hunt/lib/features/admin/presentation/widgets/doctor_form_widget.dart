import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../i18n/strings.g.dart';

class DoctorFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  final TextEditingController nameCtrl;
  final TextEditingController emailCtrl;

  final String? imagePath; // local file path after picking
  final String? existingImageUrl; // only for Edit — pre-existing network image
  final VoidCallback onPickImage;

  final TextEditingController? openHourCtrl;
  final TextEditingController? closeHourCtrl;

  // Submit button
  final bool isSubmitting;
  final String submitLabel;
  final String submittingLabel;
  final VoidCallback onSubmit;

  const DoctorFormWidget({
    super.key,
    required this.formKey,
    required this.nameCtrl,
    required this.emailCtrl,
    required this.imagePath,
    required this.onPickImage,
    required this.isSubmitting,
    required this.submitLabel,
    required this.submittingLabel,
    required this.onSubmit,
    this.existingImageUrl,
    this.openHourCtrl,
    this.closeHourCtrl,
  });

  bool get _isEditMode => openHourCtrl != null || closeHourCtrl != null;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //    Avatar (Edit-only circular picker)
          if (_isEditMode) ...[
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
                                image: FileImage(File(imagePath!)),
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
            const Gap(24),
          ],

          //    Name
          Text(
            t.admin.createDoctor.nameLabel,
            style: context.semiBold14.textPrimary,
          ),
          const Gap(8),
          CustomTextFormField(
            controller: nameCtrl,
            hintText: t.admin.createDoctor.nameHint,
            prefixIcon: const Icon(
              Icons.person_outline,
              color: AppColors.textHint,
              size: 20,
            ),
            validator: (v) {
              if (v == null || v.isEmpty) {
                return t.common.validation.enterName;
              }
              return null;
            },
          ),
          const Gap(16),

          //    Email
          Text(t.common.email, style: context.semiBold14.textPrimary),
          const Gap(8),
          CustomTextFormField(
            controller: emailCtrl,
            hintText: t.admin.createDoctor.emailHint,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(
              Icons.email_outlined,
              color: AppColors.textHint,
              size: 20,
            ),
            validator: (v) {
              if (v == null || v.isEmpty) {
                return t.common.validation.enterEmail;
              }
              if (!v.contains('@')) return t.common.validation.validEmail;
              return null;
            },
          ),
          const Gap(16),

          //    Open / Close Hour (Edit only)
          if (openHourCtrl != null && closeHourCtrl != null) ...[
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Open Hour', style: context.semiBold14.textPrimary),
                      const Gap(8),
                      CustomTextFormField(
                        controller: openHourCtrl!,
                        hintText: '09:00',
                      ),
                    ],
                  ),
                ),
                const Gap(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Close Hour', style: context.semiBold14.textPrimary),
                      const Gap(8),
                      CustomTextFormField(
                        controller: closeHourCtrl!,
                        hintText: '17:00',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Gap(16),
          ],

          //    Image picker (Create-only banner)
          if (!_isEditMode) ...[
            Text(
              t.admin.createDoctor.imageLabel,
              style: context.semiBold14.textPrimary,
            ),
            const Gap(8),
            GestureDetector(
              onTap: onPickImage,
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border, width: 2),
                  image: imagePath != null
                      ? DecorationImage(
                          image: FileImage(File(imagePath!)),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: imagePath == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.image_outlined,
                            size: 48,
                            color: AppColors.textHint,
                          ),
                          const Gap(8),
                          Text(
                            t.admin.createDoctor.imageUpload,
                            style: context.semiBold14.textSecondary,
                          ),
                          const Gap(4),
                          Text(
                            t.admin.createDoctor.imageTapHint,
                            style: context.regular12.textHint,
                          ),
                        ],
                      )
                    : null,
              ),
            ),
            const Gap(16),
          ],

          //    Submit
          const Gap(16),
          MainButton(
            text: isSubmitting ? submittingLabel : submitLabel,
            onPressed: isSubmitting ? null : onSubmit,
          ),
          const Gap(32),
        ],
      ),
    );
  }
}
