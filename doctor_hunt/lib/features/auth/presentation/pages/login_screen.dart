import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../i18n/strings.g.dart';
import '../widgets/social_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _forgotPasswordEmailCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _forgotPasswordEmailCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await AuthService.instance.login(
        email: _emailCtrl.text,
        password: _passwordCtrl.text,
      );
      final user = AuthService.instance.currentUser;
      if (user == null || !mounted) return;
      final role = await AuthService.instance.getUserRole(user.uid);
      if (!mounted) return;
      if (role == null) {
        context.go(AppRoutes.role);
      } else if (role.name == 'doctor') {
        context.go(AppRoutes.doctorDashboard);
      } else {
        context.go(AppRoutes.home);
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AuthService.instance.getErrorMessage(e.code)), backgroundColor: AppColors.error),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.common.errorGeneric), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showForgotPasswordDialog() {
    _forgotPasswordEmailCtrl.text = _emailCtrl.text;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.auth.login.forgotPasswordTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(t.auth.login.forgotPasswordSubtitle, style: context.regular14.textSecondary),
            Gap(16),
            CustomTextFormField(
              controller: _forgotPasswordEmailCtrl,
              hintText: t.common.email,
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(t.common.cancel)),
          TextButton(
            onPressed: () async {
              if (_forgotPasswordEmailCtrl.text.isEmpty) return;
              final email = _forgotPasswordEmailCtrl.text.trim();
              if (mounted) Navigator.pop(ctx);
              try {
                await AuthService.instance.sendPasswordResetEmail(email);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(t.auth.login.forgotPasswordSuccess), backgroundColor: AppColors.success),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(t.common.errorGeneric), backgroundColor: AppColors.error),
                  );
                }
              }
            },
            child: Text(t.auth.login.forgotPasswordSend),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(children: [
            const Gap(50),
            Text(t.auth.login.title, style: context.bold24.textPrimary, textAlign: TextAlign.center),
            const Gap(12),
            Text(t.auth.login.subtitle, style: context.regular14.textSecondary, textAlign: TextAlign.center),
            const Gap(70),
            Row(children: [
              Expanded(child: SocialButton(label: t.common.google, icon: SvgPicture.asset(AppImages.google, width: 20, height: 20), onTap: () {})),
              const Gap(12),
              Expanded(child: SocialButton(label: t.common.facebook, icon: SvgPicture.asset(AppImages.facebook, width: 20, height: 20), onTap: () {})),
            ]),
            const Gap(28),
            CustomTextFormField(
              controller: _emailCtrl,
              hintText: t.common.email,
              keyboardType: TextInputType.emailAddress,
              suffixIcon: const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 20),
              validator: (v) {
                if (v == null || v.isEmpty) return t.common.validation.enterEmail;
                if (!v.contains('@')) return t.common.validation.validEmail;
                return null;
              },
            ),
            const Gap(16),
            CustomTextFormField(
              controller: _passwordCtrl,
              hintText: t.common.password,
              suffixIcon: IconButton(
                icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: AppColors.textHint, size: 20),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return t.common.validation.enterPassword;
                if (v.length < 6) return t.common.validation.minPassword;
                return null;
              },
            ),
            const Gap(28),
            MainButton(
              text: _isLoading ? t.auth.login.loggingIn : t.auth.login.submitBtn,
              onPressed: _isLoading ? null : _login,
            ),
            const Gap(16),
            TextButton(
              onPressed: _showForgotPasswordDialog,
              child: Text(t.auth.login.forgotPassword, style: context.semiBold14.primary),
            ),
            const Gap(70),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(t.auth.login.noAccount, style: context.regular14.textSecondary),
              GestureDetector(
                onTap: () => context.go(AppRoutes.register),
                child: Text(t.auth.login.joinUs, style: context.bold14.primaryLight),
              ),
            ]),
          ]),
        ),
      ),
    );
  }
}
