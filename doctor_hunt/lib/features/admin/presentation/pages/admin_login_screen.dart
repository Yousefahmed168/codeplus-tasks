import '../../../../core/widgets/password_text_form_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/colors.dart';
import '../../../auth/presentation/widgets/forgot_password_dialog.dart';
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
  final _emailCtrl = TextEditingController(
    text: kDebugMode ? "admin@gmail.com" : "",
  );
  final _passwordCtrl = TextEditingController(
    text: kDebugMode ? "12345678" : "",
  );
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
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AdminLoginLoading;
          return AppBackground(
            child: Container(
              padding: EdgeInsets.all(24.r),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    3.verticalSpace,
                    // Back button
                    Align(
                      alignment: Alignment.centerLeft,
                      child: CustomBackButton(
                        onTap: () => context.go(AppRoutes.role),
                      ),
                    ),
                    24.verticalSpace,
                    // Logo
                    SvgPicture.asset(AppImages.logo, width: 56.r, height: 56.r),
                    12.verticalSpace,
                    Text(
                      t.admin.login.title,
                      style: context.bold24.textPrimary,
                      textAlign: TextAlign.center,
                    ),
                    8.verticalSpace,
                    Text(
                      t.admin.login.subtitle,
                      style: context.regular14.textSecondary,
                      textAlign: TextAlign.center,
                    ),
                    60.verticalSpace,

                    // Email
                    Text(t.common.email, style: context.semiBold14.textPrimary),
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
                        if (!v.contains('@')) {
                          return t.common.validation.validEmail;
                        }
                        return null;
                      },
                    ),

                    8.verticalSpace,
                    PasswordTextFormField(
                      labelText: t.common.password,
                      controller: _passwordCtrl,
                      hintText: t.common.password,
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return t.common.validation.enterPassword;
                        }
                        if (v.length < 6) {
                          return t.common.validation.minPassword;
                        }
                        return null;
                      },
                    ),
                    8.verticalSpace,

                    // Remember me + Forgot password
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (v) =>
                              setState(() => _rememberMe = v ?? false),
                          activeColor: AppColors.primary,
                        ),
                        Text(
                          t.admin.login.rememberMe,
                          style: context.regular14.textSecondary,
                        ),
                        const Spacer(),
                        ForgotPasswordButton(
                          emailController: _emailCtrl,
                        ),
                      ],
                    ),
                    24.verticalSpace,

                    // Login button
                    MainButton(
                      text: isLoading
                          ? t.common.loading
                          : t.admin.login.loginBtn,
                      onPressed: isLoading ? null : () => _login(context),
                    ),
                    24.verticalSpace,

                    // Secure access note
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shield_rounded,
                          color: AppColors.primary,
                          size: 16.r,
                        ),
                        8.horizontalSpace,
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
