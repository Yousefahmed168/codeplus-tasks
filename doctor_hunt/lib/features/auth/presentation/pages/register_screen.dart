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
import '../widgets/social_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, this.role});
  final String? role;
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _specialtyCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();
  final _experienceCtrl = TextEditingController();
  bool _agreeToTerms = false;
  bool get _isDoctor => widget.role == 'doctor';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    _phoneCtrl.dispose();
    _specialtyCtrl.dispose();
    _bioCtrl.dispose();
    _experienceCtrl.dispose();
    super.dispose();
  }

  void _register() {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(t.auth.register.acceptTermsError),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    if (_isDoctor) {
      context.read<AuthCubit>().registerDoctor(
        name: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
        phone: _phoneCtrl.text.trim(),
        specialty: _specialtyCtrl.text.trim(),
        bio: _bioCtrl.text.trim(),
        experienceYears: int.tryParse(_experienceCtrl.text.trim()) ?? 0,
      );
    } else {
      context.read<AuthCubit>().registerPatient(
        name: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        password: _passwordCtrl.text,
        phone: _phoneCtrl.text.trim(),
      );
    }
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
          } else if (state is AuthSuccessState) {
            if (_isDoctor) {
              context.go(AppRoutes.updateDoctorProfile);
            } else {
              context.go(AppRoutes.home);
            }
          } else if (state is AuthLoginSuccessState) {
            // Emitted after Google sign-in on the register screen
            if (state.roleName == null) {
              context.go(AppRoutes.role);
            } else {
              context.go(AppRoutes.home);
            }
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoadingState;
          return Container(
            padding: EdgeInsets.all(24.r),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  // Back button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CustomBackButton(
                      onTap: () => context.go(AppRoutes.role),
                    ),
                  ),
                  10.verticalSpace,
                  Text(
                    t.auth.register.title,
                    style: context.bold24.textPrimary,
                    textAlign: TextAlign.center,
                  ),
                  12.verticalSpace,
                  Text(
                    t.auth.register.subtitle,
                    style: context.medium14.textSecondary,
                    textAlign: TextAlign.center,
                  ),
                  32.verticalSpace,
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
                              : () =>
                                    context.read<AuthCubit>().loginWithGoogle(),
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
                  30.verticalSpace,
                  CustomTextFormField(
                    controller: _nameCtrl,
                    hintText: _isDoctor
                        ? t.auth.register.doctorNameHint
                        : t.common.name,
                    keyboardType: TextInputType.name,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return t.common.validation.enterName;
                      }
                      return null;
                    },
                  ),
                  16.verticalSpace,
                  CustomTextFormField(
                    controller: _emailCtrl,
                    hintText: t.common.email,
                    keyboardType: TextInputType.emailAddress,
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
                      if (v.length < 6) return t.common.validation.minPassword;
                      return null;
                    },
                  ),
                  16.verticalSpace,
                  PasswordTextFormField(
                    controller: _confirmPasswordCtrl,
                    hintText: t.common.confirmPassword,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return t.common.validation.enterConfirmPassword;
                      }
                      if (v != _passwordCtrl.text) {
                        return t.common.validation.passwordsDoNotMatch;
                      }
                      return null;
                    },
                  ),
                  16.verticalSpace,

                  Row(
                    children: [
                      GestureDetector(
                        onTap: () =>
                            setState(() => _agreeToTerms = !_agreeToTerms),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 22.r,
                          height: 22.r,
                          decoration: BoxDecoration(
                            color: _agreeToTerms
                                ? AppColors.primary
                                : Colors.transparent,
                            border: Border.all(
                              color: _agreeToTerms
                                  ? AppColors.primary
                                  : AppColors.border,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: _agreeToTerms
                              ? Icon(
                                  Icons.check,
                                  size: 14.r,
                                  color: AppColors.textOnPrimary,
                                )
                              : null,
                        ),
                      ),
                      10.horizontalSpace,
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: context.regular14.textSecondary,
                            children: [
                              TextSpan(text: t.auth.register.termsPrefix),
                              TextSpan(
                                text: t.auth.register.terms,
                                style: context.semiBold14.primary,
                              ),
                              TextSpan(text: t.auth.register.termsAnd),
                              TextSpan(
                                text: t.auth.register.privacy,
                                style: context.semiBold14.primary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  28.verticalSpace,
                  MainButton(
                    text: isLoading
                        ? t.auth.register.creatingAccount
                        : t.auth.register.submitBtn,
                    onPressed: isLoading ? null : _register,
                  ),
                  40.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        t.auth.register.haveAccount,
                        style: context.regular14.textSecondary,
                      ),
                      GestureDetector(
                        onTap: () => context.go(AppRoutes.login),
                        child: Text(
                          t.auth.register.loginLink,
                          style: context.medium14Primary,
                        ),
                      ),
                    ],
                  ),
                  24.verticalSpace,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
