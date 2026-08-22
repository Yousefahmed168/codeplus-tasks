import 'package:doctor_hunt/core/theme/colors.dart';
import 'package:doctor_hunt/i18n/strings.g.dart';
import 'package:doctor_hunt/core/theme/style_atoms.dart';
import 'package:doctor_hunt/core/utils/app_images.dart';
import 'package:doctor_hunt/core/widgets/widgets.dart';
import 'package:doctor_hunt/core/routes/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:doctor_hunt/features/auth/presentation/widgets/social_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
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
              t.auth.login.title,
              style: context.bold24.textPrimary,
              textAlign: TextAlign.center,
            ),
            const Gap(12),
            Text(
              t.auth.login.subtitle,
              style: context.regular14.textSecondary,
              textAlign: TextAlign.center,
            ),

            const Gap(70),

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
            const Gap(28),
            //  Email field
            CustomTextFormField(
              controller: _emailCtrl,
              hintText: t.common.email,
              suffixIcon: const Icon(
                Icons.check_circle_rounded,
                color: AppColors.primary,
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

            const Gap(28),

            //  Login button
            MainButton(
              onPressed: () {
                context.go(AppRoutes.home);
              },
              text: t.auth.login.submitBtn,
            ),

            const Gap(16),

            //  Forgot password
            TextButton(
              onPressed: () {},
              child: Text(
                t.auth.login.forgotPassword,
                style: context.semiBold14.primary,
              ),
            ),

            const Gap(70),

            //  Register link
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
    );
  }
}
