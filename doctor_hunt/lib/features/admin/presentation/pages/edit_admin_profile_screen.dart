import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/services/cloudinary_service.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../i18n/strings.g.dart';

import '../../../../core/services/admin_service.dart';

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
  String? _imagePath;
  bool _isSaving = false;

  User? get _user => FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: _user?.displayName ?? '');
    _emailCtrl = TextEditingController(text: _user?.email ?? '');
    _locationCtrl = TextEditingController();
    sl<AdminService>().getCentralClinicLocation().then((loc) {
      if (mounted) {
        _locationCtrl.text = loc;
      }
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        setState(() => _imagePath = pickedFile.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${t.admin.editProfile.failed}: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        );
      }
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      final user = _user;
      if (user == null) return;

      String? photoUrl;
      if (_imagePath != null) {
        photoUrl = await sl<CloudinaryService>().uploadImage(
          filePath: _imagePath!,
          folder: 'admin_profiles',
        );
      }

      // Update display name
      if (_nameCtrl.text.trim() != user.displayName) {
        await user.updateDisplayName(_nameCtrl.text.trim());
      }

      // Update photo URL
      if (photoUrl != null) {
        await user.updatePhotoURL(photoUrl);
      }

      // Update email if changed
      if (_emailCtrl.text.trim() != user.email) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(t.admin.editProfile.reauthRequired),
              backgroundColor: AppColors.warning,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          );
        }
      }

      // Update central clinic location
      if (_locationCtrl.text.trim().isNotEmpty) {
        await sl<AdminService>().updateCentralClinicLocation(
          _locationCtrl.text.trim(),
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.admin.editProfile.success),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${t.admin.editProfile.failed}: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _user;
    final initials = _getInitials(_nameCtrl.text);

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
                onTap: _pickImage,
                child: Stack(
                  children: [
                    Container(
                      width: 100.r,
                      height: 100.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withValues(alpha: 0.1),
                        image: _imagePath != null
                            ? DecorationImage(
                                image: FileImage(File(_imagePath!)),
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
                          _imagePath == null &&
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
                          Icons.camera_alt,
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
                hintText: t.admin.createDoctor.nameHint,
                prefixIcon: Icon(
                  Icons.person_outline,
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
                  Icons.email_outlined,
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
                  t.admin.createDoctor.addressLabel.toUpperCase(),
                  style: context.semiBold12.textSecondary,
                ),
              ),
              8.verticalSpace,
              CustomTextFormField(
                controller: _locationCtrl,
                hintText: t.admin.createDoctor.addressHint,
                prefixIcon: Icon(
                  Icons.location_on_outlined,
                  color: AppColors.textHint,
                  size: 20.r,
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return t.common.validation.fieldRequired(field: t.admin.createDoctor.addressLabel);
                  }
                  return null;
                },
              ),
              32.verticalSpace,

              // Save Changes button
              SizedBox(
                width: double.infinity,
                child: MainButton(
                  text: _isSaving
                      ? t.admin.editProfile.saving
                      : t.admin.editProfile.saveChanges,
                  onPressed: _isSaving ? null : _save,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return 'A';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }
}
