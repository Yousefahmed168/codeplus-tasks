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
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;
  bool _isLoading = false;
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

  Future<void> _register() async {
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
    setState(() => _isLoading = true);
    try {
      if (_isDoctor) {
        await AuthService.instance.registerDoctor(
          name: _nameCtrl.text,
          email: _emailCtrl.text,
          password: _passwordCtrl.text,
          phone: _phoneCtrl.text,
          specialty: _specialtyCtrl.text,
          bio: _bioCtrl.text,
          experienceYears: int.tryParse(_experienceCtrl.text) ?? 0,
        );
        if (mounted) context.go(AppRoutes.updateDoctorProfile);
      } else {
        await AuthService.instance.registerPatient(
          name: _nameCtrl.text,
          email: _emailCtrl.text,
          password: _passwordCtrl.text,
          phone: _phoneCtrl.text,
        );
        if (mounted) context.go(AppRoutes.home);
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AuthService.instance.getErrorMessage(e.code)),
            backgroundColor: AppColors.error,
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
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Gap(50),
              Text(
                t.auth.register.title,
                style: context.bold24.textPrimary,
                textAlign: TextAlign.center,
              ),
              const Gap(12),
              Text(
                t.auth.register.subtitle,
                style: context.medium14.textSecondary,
                textAlign: TextAlign.center,
              ),
              const Gap(32),
              Row(
                children: [
                  Expanded(
                    child: SocialButton(
                      label: t.common.google,
                      icon: SvgPicture.asset(
                        AppImages.google,
                        width: 20,
                        height: 20,
                      ),
                      onTap: () {},
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: SocialButton(
                      label: t.common.facebook,
                      icon: SvgPicture.asset(
                        AppImages.facebook,
                        width: 20,
                        height: 20,
                      ),
                      onTap: () {},
                    ),
                  ),
                ],
              ),
              const Gap(30),
              CustomTextFormField(
                controller: _nameCtrl,
                hintText: _isDoctor ? t.auth.register.doctorNameHint : t.common.name,
                keyboardType: TextInputType.name,
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return t.common.validation.enterName;
                  }
                  return null;
                },
              ),
              const Gap(16),
              CustomTextFormField(
                controller: _emailCtrl,
                hintText: t.common.email,
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return t.common.validation.enterEmail;
                  }
                  if (!v.contains('@')) return t.common.validation.validEmail;
                  return null;
                },
              ),
              const Gap(16),
              CustomTextFormField(
                controller: _passwordCtrl,
                hintText: t.common.password,
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
              const Gap(16),
              CustomTextFormField(
                controller: _confirmPasswordCtrl,
                hintText: t.common.confirmPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.textHint,
                    size: 20,
                  ),
                  onPressed: () => setState(
                    () => _obscureConfirmPassword = !_obscureConfirmPassword,
                  ),
                ),
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
              const Gap(16),

              Row(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _agreeToTerms = !_agreeToTerms),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 22,
                      height: 22,
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
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: _agreeToTerms
                          ? const Icon(
                              Icons.check,
                              size: 14,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                  const Gap(10),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: context.regular14.textSecondary,
                        children: [
                          TextSpan(text: t.auth.register.termsPrefix),
                          TextSpan(
                            text: t.auth.register.terms,
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(text: t.auth.register.termsAnd),
                          TextSpan(
                            text: t.auth.register.privacy,
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(28),
              MainButton(
                text: _isLoading
                    ? t.auth.register.creatingAccount
                    : t.auth.register.submitBtn,
                onPressed: _isLoading ? null : _register,
              ),
              const Gap(40),
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
                      style: context.bold16.textPrimary,
                    ),
                  ),
                ],
              ),
              const Gap(24),
            ],
          ),
        ),
      ),
    );
  }
}
