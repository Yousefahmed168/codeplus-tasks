import '../../../../core/widgets/password_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
import '../../../../core/utils/snack_bar_helper.dart';
import '../../../../core/constants/my_icons.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  static const String _rememberMeKey = 'admin_remember_me';
  static const String _savedEmailKey = 'admin_saved_email';

  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _restoreRememberMe();
  }

  Future<void> _restoreRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    final remember = prefs.getBool(_rememberMeKey) ?? false;
    final savedEmail = prefs.getString(_savedEmailKey);
    if (!mounted) return;
    setState(() {
      _rememberMe = remember;
      if (remember && savedEmail != null && savedEmail.isNotEmpty) {
        _emailCtrl.text = savedEmail;
      }
    });
  }

  Future<void> _persistRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    if (_rememberMe) {
      await prefs.setBool(_rememberMeKey, true);
      await prefs.setString(_savedEmailKey, _emailCtrl.text.trim());
    } else {
      await prefs.remove(_rememberMeKey);
      await prefs.remove(_savedEmailKey);
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _login(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    _persistRememberMe();
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
            SnackBarHelper.showError(context, state.message);
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
                        MyIcons.emailOutlined,
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
                          MyIcons.shieldRounded,
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
