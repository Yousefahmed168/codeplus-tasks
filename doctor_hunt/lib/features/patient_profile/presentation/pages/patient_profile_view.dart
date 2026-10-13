import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/widgets/custom_text_form_field.dart';
import '../../../../i18n/strings.g.dart';

/// The editable field of the profile screen.
enum ProfileField { none, name, phone }

/// Personal information card of the profile screen.
///
/// Each row shows its value with a pencil action; tapping the pencil swaps the
/// row for an inline text field so a single field is edited at a time.
class PatientProfileView extends StatelessWidget {
  final TextEditingController nameCtrl;
  final TextEditingController phoneCtrl;
  final FocusNode nameFocus;
  final FocusNode phoneFocus;
  final ProfileField editingField;
  final ValueChanged<ProfileField> onEditField;
  final VoidCallback onStopEditing;

  const PatientProfileView({
    super.key,
    required this.nameCtrl,
    required this.phoneCtrl,
    required this.nameFocus,
    required this.phoneFocus,
    required this.editingField,
    required this.onEditField,
    required this.onStopEditing,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Padding(
          padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t.patientProfile.personalInfo,
                style: context.semiBold16.textPrimary,
              ),
              12.verticalSpace,
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.textPrimary.withValues(alpha: 0.04),
                      blurRadius: 10.r,
                      offset: Offset(0, 2.h),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _EditableInfoRow(
                      label: t.common.name,
                      controller: nameCtrl,
                      focusNode: nameFocus,
                      isEditing: editingField == ProfileField.name,
                      onEdit: () => onEditField(ProfileField.name),
                      onStopEditing: onStopEditing,
                      textInputAction: TextInputAction.next,
                    ),
                    Divider(
                      height: 1.h,
                      indent: 16.w,
                      endIndent: 16.w,
                      color: AppColors.divider,
                    ),
                    _EditableInfoRow(
                      label: t.patientProfile.contactNumber,
                      controller: phoneCtrl,
                      focusNode: phoneFocus,
                      isEditing: editingField == ProfileField.phone,
                      onEdit: () => onEditField(ProfileField.phone),
                      onStopEditing: onStopEditing,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditableInfoRow extends StatelessWidget {
  const _EditableInfoRow({
    required this.label,
    required this.controller,
    required this.focusNode,
    required this.isEditing,
    required this.onEdit,
    required this.onStopEditing,
    this.keyboardType,
    this.textInputAction,
  });

  final String label;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isEditing;
  final VoidCallback onEdit;
  final VoidCallback onStopEditing;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    if (isEditing) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Row(
          children: [
            Expanded(
              child: CustomTextFormField(
                controller: controller,
                focusNode: focusNode,
                hintText: label,
                keyboardType: keyboardType,
                textInputAction: textInputAction,
              ),
            ),
            4.horizontalSpace,
            IconButton(
              onPressed: onStopEditing,
              icon: Icon(
                Icons.check_circle_rounded,
                color: AppColors.primary,
                size: 26.r,
              ),
            ),
          ],
        ),
      );
    }

    final value = controller.text.trim();

    return InkWell(
      onTap: onEdit,
      borderRadius: BorderRadius.circular(16.r),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: context.regular12.textSecondary,
                  ),
                  4.verticalSpace,
                  Text(
                    value.isEmpty ? t.common.notProvided : value,
                    style: context.medium16.textPrimary,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            8.horizontalSpace,
            Icon(
              Icons.edit_outlined,
              color: AppColors.primary,
              size: 20.r,
            ),
          ],
        ),
      ),
    );
  }
}
