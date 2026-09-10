import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/widgets/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../i18n/strings.g.dart';
import '../cubit/admin_login_cubit.dart';
import '../cubit/admin_login_state.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _login(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    context.read<AdminLoginCubit>().login(
      _emailCtrl.text.trim(),
      _passwordCtrl.text.trim(),
    );
  }

  void _showForgotPasswordDialog() {
    final emailCtrl = TextEditingController(text: _emailCtrl.text);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.auth.login.forgotPasswordTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              t.auth.login.forgotPasswordSubtitle,
              style: context.regular14.textSecondary,
            ),
            const Gap(16),
            CustomTextFormField(
              controller: emailCtrl,
              hintText: t.common.email,
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(t.common.cancel),
          ),
          TextButton(
            onPressed: () async {
              if (emailCtrl.text.isEmpty) return;
              final email = emailCtrl.text.trim();
              if (mounted) Navigator.pop(ctx);
              try {
                await AuthService.instance.sendPasswordResetEmail(email);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(t.auth.login.forgotPasswordSuccess),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(t.common.errorGeneric),
                      backgroundColor: AppColors.error,
                    ),
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
    return BlocProvider(
      create: (context) => AdminLoginCubit(),
      child: BlocConsumer<AdminLoginCubit, AdminLoginState>(
        listener: (context, state) {
          if (state is AdminLoginSuccess) {
            context.go(AppRoutes.adminMain);
          } else if (state is AdminLoginError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AdminLoginLoading;
          return AppBackground(
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    const Gap(40),
                    // Back button
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () => context.go(AppRoutes.role),
                        child: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                      ),
                    ),
                    const Gap(24),
                    // Logo
                    SvgPicture.asset(AppImages.logo, width: 56, height: 56),
                    const Gap(12),
                    Text(
                      t.admin.login.title,
                      style: context.bold24.textPrimary,
                      textAlign: TextAlign.center,
                    ),
                    const Gap(8),
                    Text(
                      t.admin.login.subtitle,
                      style: context.regular14.textSecondary,
                      textAlign: TextAlign.center,
                    ),
                    const Gap(60),

                    // Email
                    Text(t.common.email, style: context.semiBold14.textPrimary),
                    const Gap(8),
                    CustomTextFormField(
                      controller: _emailCtrl,
                      hintText: t.common.email,
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
                    const Gap(16),

                    // Password
                    Text(t.common.password, style: context.semiBold14.textPrimary),
                    const Gap(8),
                    CustomTextFormField(
                      controller: _passwordCtrl,
                      hintText: t.common.password,
                      prefixIcon: const Icon(
                        Icons.lock_outline_rounded,
                        color: AppColors.textHint,
                        size: 20,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.textHint,
                          size: 20,
                        ),
                        onPressed: () =>
                            setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return t.common.validation.enterPassword;
                        }
                        if (v.length < 6) return t.common.validation.minPassword;
                        return null;
                      },
                    ),
                    const Gap(8),

                    // Remember me + Forgot password
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (v) => setState(() => _rememberMe = v ?? false),
                          activeColor: AppColors.primary,
                        ),
                        Text(
                          t.admin.login.rememberMe,
                          style: context.regular14.textSecondary,
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: _showForgotPasswordDialog,
                          child: Text(
                            t.auth.login.forgotPassword,
                            style: context.semiBold14.primary,
                          ),
                        ),
                      ],
                    ),
                    const Gap(24),

                    // Login button
                    MainButton(
                      text: isLoading ? t.common.loading : t.admin.login.loginBtn,
                      onPressed: isLoading ? null : () => _login(context),
                    ),
                    const Gap(24),

                    // Secure access note
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.shield_rounded,
                          color: AppColors.primary,
                          size: 16,
                        ),
                        const Gap(8),
                        Text(
                          t.admin.login.secureAccess,
                          style: context.regular12.textSecondary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
