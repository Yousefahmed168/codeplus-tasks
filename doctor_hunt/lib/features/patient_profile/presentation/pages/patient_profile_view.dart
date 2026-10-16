import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/widgets/custom_text_form_field.dart';
import '../../../../i18n/strings.g.dart';
import '../../../../core/constants/my_icons.dart';

/// The inline-editable field of the profile screen.
enum ProfileField { none, name, phone }

/// Personal information card of the profile screen.
///
/// Name and phone are edited inline; date of birth and gender open a picker;
/// the email is read-only because it is owned by Firebase Authentication.
class PatientProfileView extends StatelessWidget {
  final TextEditingController nameCtrl;
  final TextEditingController phoneCtrl;
  final FocusNode nameFocus;
  final FocusNode phoneFocus;
  final ProfileField editingField;
  final ValueChanged<ProfileField> onEditField;
  final VoidCallback onStopEditing;

  final String email;
  final String? dob;
  final int? gender;
  final VoidCallback onPickDob;
  final VoidCallback onPickGender;

  const PatientProfileView({
    super.key,
    required this.nameCtrl,
    required this.phoneCtrl,
    required this.nameFocus,
    required this.phoneFocus,
    required this.editingField,
    required this.onEditField,
    required this.onStopEditing,
    required this.email,
    required this.dob,
    required this.gender,
    required this.onPickDob,
    required this.onPickGender,
  });

  String get _genderLabel {
    switch (gender) {
      case 0:
        return t.patientProfile.male;
      case 1:
        return t.patientProfile.female;
      default:
        return t.common.notProvided;
    }
  }

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
                    const _RowDivider(),
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
                    const _RowDivider(),
                    _ReadOnlyInfoRow(
                      label: t.common.email,
                      value: email.isEmpty ? t.common.notProvided : email,
                    ),
                    const _RowDivider(),
                    _PickerInfoRow(
                      label: t.patientProfile.dateOfBirth,
                      value: (dob == null || dob!.isEmpty)
                          ? t.common.notProvided
                          : dob!,
                      onTap: onPickDob,
                    ),
                    const _RowDivider(),
                    _PickerInfoRow(
                      label: t.patientProfile.gender,
                      value: _genderLabel,
                      onTap: onPickGender,
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

class _RowDivider extends StatelessWidget {
  const _RowDivider();

  @override
  Widget build(BuildContext context) => Divider(
        height: 1.h,
        indent: 16.w,
        endIndent: 16.w,
        color: AppColors.divider,
      );
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
                MyIcons.checkCircleRounded,
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
      child: _InfoRowBody(
        label: label,
        value: value.isEmpty ? t.common.notProvided : value,
        showEditIcon: true,
      ),
    );
  }
}

/// Read-only row (no pencil action).
class _ReadOnlyInfoRow extends StatelessWidget {
  const _ReadOnlyInfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return _InfoRowBody(label: label, value: value, showEditIcon: false);
  }
}

/// Row whose value is chosen through a picker rather than typed.
class _PickerInfoRow extends StatelessWidget {
  const _PickerInfoRow({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: _InfoRowBody(label: label, value: value, showEditIcon: true),
    );
  }
}

class _InfoRowBody extends StatelessWidget {
  const _InfoRowBody({
    required this.label,
    required this.value,
    required this.showEditIcon,
  });

  final String label;
  final String value;
  final bool showEditIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: context.regular12.textSecondary),
                4.verticalSpace,
                Text(
                  value,
                  style: context.medium16.textPrimary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (showEditIcon) ...[
            8.horizontalSpace,
            Icon(
              MyIcons.editOutlined,
              color: AppColors.primary,
              size: 20.r,
            ),
          ],
        ],
      ),
    );
  }
}
