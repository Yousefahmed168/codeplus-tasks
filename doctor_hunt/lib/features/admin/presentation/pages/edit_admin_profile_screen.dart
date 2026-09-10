import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../core/services/cloudinary_service.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../i18n/strings.g.dart';

class EditAdminProfileScreen extends StatefulWidget {
  const EditAdminProfileScreen({super.key});

  @override
  State<EditAdminProfileScreen> createState() => _EditAdminProfileScreenState();
}

class _EditAdminProfileScreenState extends State<EditAdminProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  String? _imagePath;
  bool _isSaving = false;

  User? get _user => FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: _user?.displayName ?? '');
    _emailCtrl = TextEditingController(text: _user?.email ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
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
        photoUrl = await CloudinaryService.instance.uploadImage(
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
        // Note: Changing email requires re-authentication in Firebase
        // For now, we just show a message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Email change requires re-authentication'),
              backgroundColor: AppColors.warning,
            ),
          );
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.admin.editProfile.success),
            backgroundColor: AppColors.success,
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
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimary,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          t.admin.editProfile.title,
          style: context.bold18.textPrimary,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
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
                      width: 100,
                      height: 100,
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
              const Gap(8),
              Text(
                t.admin.editProfile.tapPhotoToChange,
                style: context.regular12.primary,
              ),
              const Gap(32),

              // Full Name
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  t.admin.editProfile.fullName,
                  style: context.semiBold12.textSecondary,
                ),
              ),
              const Gap(8),
              CustomTextFormField(
                controller: _nameCtrl,
                hintText: 'Enter your full name',
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
              const Gap(20),

              // Email Address
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  t.admin.editProfile.emailAddress,
                  style: context.semiBold12.textSecondary,
                ),
              ),
              const Gap(8),
              CustomTextFormField(
                controller: _emailCtrl,
                hintText: 'Enter your email',
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
              const Gap(32),

              // Save Changes button
              SizedBox(
                width: double.infinity,
                height: 50,
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
