import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../i18n/strings.g.dart';

import '../../../../core/utils/string_utils.dart';
import '../../../../core/utils/snack_bar_helper.dart';
import '../cubit/edit_admin_profile_cubit.dart';
import '../../../../core/constants/my_icons.dart';

class EditAdminProfileScreen extends StatefulWidget {
  const EditAdminProfileScreen({super.key});

  @override
  State<EditAdminProfileScreen> createState() => _EditAdminProfileScreenState();
}

class _EditAdminProfileScreenState extends State<EditAdminProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _locationCtrl;
  User? get _user => FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: _user?.displayName ?? '');
    _emailCtrl = TextEditingController(text: _user?.email ?? '');
    _locationCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  void _pickImage(BuildContext context) {
    context.read<EditAdminProfileCubit>().pickImage();
  }

  void _save(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    context.read<EditAdminProfileCubit>().save(
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      clinicLocation: _locationCtrl.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EditAdminProfileCubit()..load(),
      child: BlocConsumer<EditAdminProfileCubit, EditAdminProfileState>(
        listener: (context, state) {
          if (state.clinicLocation != null && _locationCtrl.text.isEmpty) {
            _locationCtrl.text = state.clinicLocation!;
          }
          if (state.status == EditAdminProfileStatus.success) {
            if (state.emailChangeDetected) {
              SnackBarHelper.showWarning(
                context,
                t.admin.editProfile.reauthRequired,
              );
            }
            SnackBarHelper.showSuccess(context, t.admin.editProfile.success);
            context.pop();
          } else if (state.status == EditAdminProfileStatus.failed) {
            SnackBarHelper.showError(context, t.admin.editProfile.failed);
          }
        },
        builder: (context, state) => _buildScaffold(context, state),
      ),
    );
  }

  Widget _buildScaffold(BuildContext context, EditAdminProfileState state) {
    final user = _user;
    final initials = StringUtils.getInitials(_nameCtrl.text);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryLight,
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: 70.w,
        leading: Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: const CustomBackButton(),
        ),
        title: Text(
          t.admin.editProfile.title,
          style: context.bold18.textPrimary,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.r),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Avatar
              GestureDetector(
                onTap: () => _pickImage(context),
                child: Stack(
                  children: [
                    Container(
                      width: 100.r,
                      height: 100.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withValues(alpha: 0.1),
                        image: state.imagePath != null
                            ? DecorationImage(
                                image: FileImage(File(state.imagePath!)),
                                fit: BoxFit.cover,
                              )
                            : (user?.photoURL != null &&
                                      user!.photoURL!.isNotEmpty
                                  ? DecorationImage(
                                      image: NetworkImage(user.photoURL!),
                                      fit: BoxFit.cover,
                                    )
                                  : null),
                      ),
                      child:
                          state.imagePath == null &&
                              (user?.photoURL == null ||
                                  user!.photoURL!.isEmpty)
                          ? Center(
                              child: Text(
                                initials,
                                style: context.bold28.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
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
                          MyIcons.cameraAlt,
                          color: AppColors.textOnPrimary,
                          size: 16.r,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              8.verticalSpace,
              Text(
                t.admin.editProfile.tapPhotoToChange,
                style: context.regular12.primary,
              ),
              32.verticalSpace,

              // Full Name
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  t.admin.editProfile.fullName,
                  style: context.semiBold12.textSecondary,
                ),
              ),
              8.verticalSpace,
              CustomTextFormField(
                controller: _nameCtrl,
                hintText: t.admin.editProfile.nameHint,
                prefixIcon: Icon(
                  MyIcons.personOutline,
                  color: AppColors.textHint,
                  size: 20.r,
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return t.common.validation.enterName;
                  }
                  return null;
                },
              ),
              20.verticalSpace,

              // Email Address
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  t.admin.editProfile.emailAddress,
                  style: context.semiBold12.textSecondary,
                ),
              ),
              8.verticalSpace,
              CustomTextFormField(
                controller: _emailCtrl,
                hintText: t.common.email,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icon(
                  MyIcons.emailOutlined,
                  color: AppColors.textHint,
                  size: 20.r,
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return t.common.validation.enterEmail;
                  }
                  if (!v.contains('@')) return t.common.validation.validEmail;
                  return null;
                },
              ),
              20.verticalSpace,

              // Clinic Central Location
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  t.admin.editProfile.clinicLocation,
                  style: context.semiBold12.textSecondary,
                ),
              ),
              8.verticalSpace,
              CustomTextFormField(
                controller: _locationCtrl,
                hintText: t.admin.editProfile.clinicLocationHint,
                prefixIcon: Icon(
                  MyIcons.locationOnOutlined,
                  color: AppColors.textHint,
                  size: 20.r,
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return t.common.validation.fieldRequired(
                      field: t.admin.editProfile.clinicLocation,
                    );
                  }
                  return null;
                },
              ),
              32.verticalSpace,

              // Save Changes button
              SizedBox(
                width: double.infinity,
                child: MainButton(
                  text: state.status == EditAdminProfileStatus.saving
                      ? t.admin.editProfile.saving
                      : t.admin.editProfile.saveChanges,
                  onPressed: state.status == EditAdminProfileStatus.saving
                      ? null
                      : () => _save(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
