import '../../core/theme/colors.dart';
import '../../i18n/strings.g.dart';
import '../../core/theme/style_atoms.dart';
import '../../core/utils/app_images.dart';
import '../../core/widgets/widgets.dart';
import '../../core/routes/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/utils/snack_bar_helper.dart';
import '../../core/constants/my_icons.dart';

enum AppRole { patient, admin }

class ChooseRoleScreen extends StatefulWidget {
  const ChooseRoleScreen({super.key});

  @override
  State<ChooseRoleScreen> createState() => _ChooseRoleScreenState();
}

class _ChooseRoleScreenState extends State<ChooseRoleScreen> {
  AppRole? _selectedRole;

  void _onContinue() {
    if (_selectedRole == null) return;
    if (_selectedRole == AppRole.admin) {
      context.go(AppRoutes.adminLogin);
    } else {
      context.go(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DoubleBackToExit(
      child: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo
                32.verticalSpace,
                SvgPicture.asset(AppImages.logo, width: 56.r, height: 56.r),
                8.verticalSpace,
                Text(t.common.appName, style: context.bold24.textPrimary),

                // Title & subtitle
                32.verticalSpace,
                Text(
                  t.roleSelection.title,
                  style: context.semiBold20.textPrimary,
                ),
                8.verticalSpace,
                Text(
                  t.roleSelection.subtitle,
                  style: context.regular14.textSecondary,
                  textAlign: TextAlign.center,
                ),

                // Role cards
                32.verticalSpace,
                _RoleCard(
                  role: AppRole.patient,
                  selected: _selectedRole == AppRole.patient,
                  icon: MyIcons.personOutlineRounded,
                  title: t.roleSelection.roles.patient.title,
                  description: t.roleSelection.roles.patient.description,
                  onTap: () => setState(() => _selectedRole = AppRole.patient),
                ),

                16.verticalSpace,
                _RoleCard(
                  role: AppRole.admin,
                  selected: _selectedRole == AppRole.admin,
                  icon: MyIcons.adminPanelSettingsOutlined,
                  title: t.admin.chooseRole.title,
                  description: t.admin.chooseRole.description,
                  onTap: () => setState(() => _selectedRole = AppRole.admin),
                ),

                const Spacer(),

                // Continue button
                MainButton(
                  text: t.common.continueBtn,
                  onPressed: _selectedRole != null
                      ? _onContinue
                      : () {
                          SnackBarHelper.showError(
                            context,
                            t.roleSelection.errorNoRole,
                          );
                        },
                ),
                32.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Role Card

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.role,
    required this.selected,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  final AppRole role;
  final bool selected;
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const selectedColor = AppColors.borderSelected;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: selected ? selectedColor : AppColors.divider,
          width: selected ? 2 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: selected
                ? selectedColor.withValues(alpha: 0.30)
                : AppColors.shadow.withValues(alpha: 0.04),
            blurRadius: selected ? 16.r : 8.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: AppColors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              children: [
                // Icon container
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 48.r,
                  height: 48.r,
                  decoration: BoxDecoration(
                    color: selected
                        ? selectedColor.withValues(alpha: 0.12)
                        : AppColors.background,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    icon,
                    size: 26.r,
                    color: selected ? selectedColor : AppColors.textSecondary,
                  ),
                ),
                16.horizontalSpace,

                // Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: context.semiBold16.textPrimary),
                      4.verticalSpace,
                      Text(description, style: context.regular12.textSecondary),
                    ],
                  ),
                ),

                // Checkmark
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: selected ? 1 : 0,
                  child: Container(
                    width: 24.r,
                    height: 24.r,
                    decoration: const BoxDecoration(
                      color: selectedColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      MyIcons.checkRounded,
                      size: 16.r,
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
