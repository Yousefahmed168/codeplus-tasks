import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/widgets/custom_text_form_field.dart';
import '../../../../core/widgets/main_button.dart';
import '../../../../i18n/strings.g.dart';
import '../../../../core/utils/snack_bar_helper.dart';

class ForgotPasswordDialog extends StatefulWidget {
  final String? initialEmail;
  final void Function(String email)? onSend;

  const ForgotPasswordDialog({
    super.key,
    this.initialEmail,
    this.onSend,
  });

  static Future<void> show(
    BuildContext context, {
    String? initialEmail,
    void Function(String email)? onSend,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: ForgotPasswordDialog(
          initialEmail: initialEmail,
          onSend: onSend,
        ),
      ),
    );
  }

  @override
  State<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  late final TextEditingController _emailController;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail ?? '');
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _onSendResetLink() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      SnackBarHelper.showError(context, t.common.validation.validEmail);
      return;
    }

    setState(() => _isSending = true);
    try {
      if (widget.onSend != null) {
        widget.onSend!(email);
      } else {
        await sl<AuthService>().sendPasswordResetEmail(email);
      }
      if (!mounted) return;
      Navigator.of(context).pop();
      SnackBarHelper.showSuccess(context, t.auth.login.forgotPasswordSuccess);
    } catch (e) {
      if (mounted) {
        SnackBarHelper.showError(context, t.auth.login.forgotPasswordError);
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 130.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
            28.h.verticalSpace,
            Text(
              t.auth.login.forgotPasswordTitle,
              style: context.bold24.textPrimary,
            ),
            12.h.verticalSpace,
            Text(
              t.auth.login.forgotPasswordSubtitle,
              style: context.regular14.textSecondary,
            ),
            32.h.verticalSpace,
            CustomTextFormField(
              controller: _emailController,
              hintText: t.common.email,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
            ),
            32.h.verticalSpace,
            MainButton(
              text: _isSending
                  ? t.auth.login.forgotPasswordSending
                  : t.auth.login.forgotPasswordSend,
              bgColor: AppColors.primary,
              onPressed: _isSending ? null : _onSendResetLink,
            ),
          ],
        ),
      ),
    );
  }
}

class ForgotPasswordButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final TextEditingController? emailController;
  final void Function(String email)? onSend;

  const ForgotPasswordButton({
    super.key,
    this.onPressed,
    this.emailController,
    this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed ??
          () {
            ForgotPasswordDialog.show(
              context,
              initialEmail: emailController?.text,
              onSend: onSend,
            );
          },
      child: Text(
        t.auth.login.forgotPassword,
        style: context.semiBold14.primary,
      ),
    );
  }
}
