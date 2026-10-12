import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/widgets/custom_text_form_field.dart';
import '../../../../core/widgets/main_button.dart';
import '../../../../i18n/strings.g.dart';

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
  int _step = 0; // 0: Email, 1: 4-digit code, 2: Reset password

  late final TextEditingController _emailController;
  late final List<TextEditingController> _otpControllers;
  late final List<FocusNode> _otpFocusNodes;
  late final TextEditingController _newPasswordController;
  late final TextEditingController _confirmPasswordController;

  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.initialEmail ?? '');
    _otpControllers = List.generate(4, (_) => TextEditingController());
    _otpFocusNodes = List.generate(4, (_) => FocusNode());
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final f in _otpFocusNodes) {
      f.dispose();
    }
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String get _otpCode => _otpControllers.map((c) => c.text).join();

  Future<void> _onContinueFromEmail() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;

    if (widget.onSend != null) {
      widget.onSend!(email);
    } else {
      try {
        await sl<AuthService>().sendPasswordResetEmail(email);
      } catch (_) {}
    }

    if (mounted) {
      setState(() => _step = 1);
    }
  }

  void _onContinueFromCode() {
    if (_otpCode.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.auth.login.invalidCode),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    setState(() => _step = 2);
  }

  void _onUpdatePassword() {
    final newPass = _newPasswordController.text;
    final confirmPass = _confirmPasswordController.text;

    if (newPass.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.common.validation.minPassword),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (newPass != confirmPass) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.auth.login.passwordsDoNotMatch),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(t.auth.login.passwordUpdatedSuccess),
        backgroundColor: AppColors.success,
      ),
    );
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
            if (_step == 0) _buildEmailStep(),
            if (_step == 1) _buildCodeStep(),
            if (_step == 2) _buildResetPasswordStep(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailStep() {
    return Column(
      key: const ValueKey('step_email'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          text: t.common.continueBtn,
          bgColor: AppColors.primary,
          onPressed: _onContinueFromEmail,
        ),
      ],
    );
  }

  Widget _buildCodeStep() {
    return Column(
      key: const ValueKey('step_code'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t.auth.login.enterCodeTitle,
          style: context.bold24.textPrimary,
        ),
        12.h.verticalSpace,
        Text(
          t.auth.login.enterCodeSubtitle,
          style: context.regular14.textSecondary,
        ),
        32.h.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(4, (index) {
            final isFilled = _otpControllers[index].text.isNotEmpty;
            return Container(
              width: 54.w,
              height: 54.h,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: isFilled ? AppColors.primary : AppColors.border,
                  width: 1.5,
                ),
              ),
              alignment: Alignment.center,
              child: TextField(
                controller: _otpControllers[index],
                focusNode: _otpFocusNodes[index],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: context.bold20.primary,
                maxLength: 1,
                buildCounter: (
                  _, {
                  required currentLength,
                  required isFocused,
                  maxLength,
                }) =>
                    null,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (val) {
                  if (val.isNotEmpty && index < 3) {
                    _otpFocusNodes[index + 1].requestFocus();
                  } else if (val.isEmpty && index > 0) {
                    _otpFocusNodes[index - 1].requestFocus();
                  }
                  setState(() {});
                },
              ),
            );
          }),
        ),
        32.h.verticalSpace,
        MainButton(
          text: t.common.continueBtn,
          bgColor: AppColors.primary,
          onPressed: _onContinueFromCode,
        ),
      ],
    );
  }

  Widget _buildResetPasswordStep() {
    return Column(
      key: const ValueKey('step_reset_password'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t.auth.login.resetPasswordTitle,
          style: context.bold24.textPrimary,
        ),
        12.h.verticalSpace,
        Text(
          t.auth.login.resetPasswordSubtitle,
          style: context.regular14.textSecondary,
        ),
        24.h.verticalSpace,
        CustomTextFormField(
          controller: _newPasswordController,
          hintText: t.auth.login.newPassword,
          obscureText: _obscureNewPassword,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureNewPassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.textSecondary,
              size: 20.sp,
            ),
            onPressed: () =>
                setState(() => _obscureNewPassword = !_obscureNewPassword),
          ),
        ),
        16.h.verticalSpace,
        CustomTextFormField(
          controller: _confirmPasswordController,
          hintText: t.auth.login.reenterPassword,
          obscureText: _obscureConfirmPassword,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureConfirmPassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.textSecondary,
              size: 20.sp,
            ),
            onPressed: () => setState(
                () => _obscureConfirmPassword = !_obscureConfirmPassword),
          ),
        ),
        24.h.verticalSpace,
        MainButton(
          text: t.auth.login.updatePassword,
          bgColor: AppColors.primary,
          onPressed: _onUpdatePassword,
        ),
      ],
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
