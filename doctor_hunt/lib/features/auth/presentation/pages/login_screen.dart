import '../../../../core/widgets/password_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../i18n/strings.g.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/forgot_password_dialog.dart';
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

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _login() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().login(
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: AppColors.error,
              ),
            );
          } else if (state is AuthPasswordResetSuccessState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.success,
              ),
            );
          } else if (state is AuthLoginSuccessState) {
            context.go(AppRoutes.home);
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoadingState;
          return SafeArea(
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
                    10.verticalSpace,
                    Text(
                      t.auth.login.title,
                      style: context.bold24.textPrimary,
                      textAlign: TextAlign.center,
                    ),
                    12.verticalSpace,
                    Text(
                      t.auth.login.subtitle,
                      style: context.regular14.textSecondary,
                      textAlign: TextAlign.center,
                    ),
                    70.verticalSpace,
                    Row(
                      children: [
                        Expanded(
                          child: SocialButton(
                            label: t.common.google,
                            icon: SvgPicture.asset(
                              AppImages.google,
                              width: 20.r,
                              height: 20.r,
                            ),
                            onTap: isLoading
                                ? () {}
                                : () => context
                                      .read<AuthCubit>()
                                      .loginWithGoogle(),
                          ),
                        ),
                        12.horizontalSpace,
                        Expanded(
                          child: SocialButton(
                            label: t.common.facebook,
                            icon: SvgPicture.asset(
                              AppImages.facebook,
                              width: 20.r,
                              height: 20.r,
                            ),
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),
                    28.verticalSpace,
                    CustomTextFormField(
                      textInputAction: TextInputAction.next,
                      controller: _emailCtrl,
                      hintText: t.common.email,
                      keyboardType: TextInputType.emailAddress,
                      suffixIcon: Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.primary,
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
                    16.verticalSpace,
                    PasswordTextFormField(
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
                    28.verticalSpace,
                    MainButton(
                      text: isLoading
                          ? t.auth.login.loggingIn
                          : t.auth.login.submitBtn,
                      onPressed: isLoading ? null : _login,
                    ),
                    16.verticalSpace,
                    ForgotPasswordButton(
                      emailController: _emailCtrl,
                      onSend: (email) =>
                          context.read<AuthCubit>().sendPasswordResetEmail(email),
                    ),
                    70.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          t.auth.login.noAccount,
                          style: context.regular14.textSecondary,
                        ),
                        GestureDetector(
                          onTap: () => context.go(AppRoutes.register),
                          child: Text(
                            t.auth.login.joinUs,
                            style: context.bold14.primaryLight,
                          ),
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
