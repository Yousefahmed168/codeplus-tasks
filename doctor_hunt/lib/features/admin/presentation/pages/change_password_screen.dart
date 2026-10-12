import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
            content: Text(t.admin.changePassword.success),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${t.admin.changePassword.failed}: $e'),
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: const CustomBackButton(),

        title: Text(
          t.admin.changePassword.title,
          style: context.bold18.textLight,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Current Password
              PasswordTextFormField(
                controller: _currentPasswordCtrl,
                hintText: '••••••••',
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: AppColors.textHint,
                  size: 20,
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return t.admin.changePassword.currentPasswordRequired;
                  }
                  return null;
                },
                labelText: t.admin.changePassword.currentPassword,
              ),
              const Gap(20),

              // New Password
              PasswordTextFormField(
                controller: _newPasswordCtrl,
                hintText: '••••••••',
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: AppColors.textHint,
                  size: 20,
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return t.common.validation.enterPassword;
                  }
                  if (v.length < 6) return t.common.validation.minPassword;
                  return null;
                },
                labelText: t.admin.changePassword.newPassword,
              ),
              const Gap(20),

              // Confirm New Password
              PasswordTextFormField(
                controller: _confirmPasswordCtrl,
                hintText: '••••••••',
                prefixIcon: const Icon(
                  Icons.lock_outline,
                  color: AppColors.textHint,
                  size: 20,
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
                labelText: t.admin.changePassword.confirmNewPassword,
              ),
              const Gap(32),

              // Update Password button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: MainButton(
                  text: _isSaving
                      ? t.admin.changePassword.updating
                      : t.admin.changePassword.updatePassword,
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
