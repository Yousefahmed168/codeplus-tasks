import 'package:doctor_hunt/core/theme/colors.dart';
import 'package:doctor_hunt/i18n/strings.g.dart';
import 'package:doctor_hunt/core/theme/style_atoms.dart';
import 'package:doctor_hunt/core/utils/app_images.dart';
import 'package:doctor_hunt/core/widgets/widgets.dart';
import 'package:doctor_hunt/core/routes/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:doctor_hunt/features/auth/widgets/social_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _onRegister() {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.auth.register.acceptTermsError)));
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Container(
        padding: const EdgeInsets.all(24),

        child: ListView(
          children: [
            const Gap(50),

            //  Headline
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

            //  Social buttons
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
            Gap(30),
            //  Name field
            CustomTextFormField(
              controller: _nameCtrl,
              hintText: t.common.name,
              keyboardType: TextInputType.name,
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return t.common.validation.enterName;
                }
                return null;
              },
            ),

            const Gap(16),

            //  Email field
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

            //  Password field
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

            const Gap(20),

            //  Terms checkbox
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
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
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

            //  Sign up button
            MainButton(text: t.auth.register.submitBtn, onPressed: _onRegister),

            const Gap(40),

            //  Login link
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
    );
  }
}
