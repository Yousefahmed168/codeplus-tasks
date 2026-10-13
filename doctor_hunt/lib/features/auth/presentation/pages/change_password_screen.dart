import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../core/widgets/password_text_form_field.dart';
import '../../../../i18n/strings.g.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordCtrl = TextEditingController();
  final _newPasswordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _currentPasswordCtrl.dispose();
    _newPasswordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  Future<void> _updatePassword() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Re-authenticate with current password
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: _currentPasswordCtrl.text,
      );
      await user.reauthenticateWithCredential(credential);

      // Update to new password
      await user.updatePassword(_newPasswordCtrl.text.trim());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.changePassword.success),
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
            content: Text('${t.changePassword.failed}: $e'),
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: 70.w,
        leading: Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: const CustomBackButton(),
        ),
        title: Text(
          t.changePassword.title,
          style: context.bold18.textLight,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.r),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Current Password
              PasswordTextFormField(
                controller: _currentPasswordCtrl,
                hintText: '••••••••',
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: AppColors.textHint,
                  size: 20.r,
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return t.changePassword.currentPasswordRequired;
                  }
                  return null;
                },
                labelText: t.changePassword.currentPassword,
              ),
              20.verticalSpace,

              // New Password
              PasswordTextFormField(
                controller: _newPasswordCtrl,
                hintText: '••••••••',
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: AppColors.textHint,
                  size: 20.r,
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return t.common.validation.enterPassword;
                  }
                  if (v.length < 6) return t.common.validation.minPassword;
                  return null;
                },
                labelText: t.changePassword.newPassword,
              ),
              20.verticalSpace,

              // Confirm New Password
              PasswordTextFormField(
                controller: _confirmPasswordCtrl,
                hintText: '••••••••',
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: AppColors.textHint,
                  size: 20.r,
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return t.common.validation.enterConfirmPassword;
                  }
                  if (v != _newPasswordCtrl.text) {
                    return t.common.validation.passwordsDoNotMatch;
                  }
                  return null;
                },
                labelText: t.changePassword.confirmNewPassword,
              ),
              32.verticalSpace,

              // Update Password button
              SizedBox(
                width: double.infinity,
                child: MainButton(
                  text: _isSaving
                      ? t.changePassword.updating
                      : t.changePassword.updatePassword,
                  onPressed: _isSaving ? null : _updatePassword,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
