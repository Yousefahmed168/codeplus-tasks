import '../../core/theme/colors.dart';
import '../../i18n/strings.g.dart';
import '../../core/theme/style_atoms.dart';
import '../../core/utils/app_images.dart';
import '../../core/widgets/widgets.dart';
import '../../core/routes/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

enum AppRole { patient, doctor, admin }

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
    return AppBackground(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //  Logo
              const Gap(32),
              SvgPicture.asset(AppImages.logo, width: 56, height: 56),
              const Gap(8),
              Text(t.common.appName, style: context.bold24.textPrimary),

              //  Title & subtitle
              const Gap(32),
              Text(
                t.roleSelection.title,
                style: context.semiBold20.textPrimary,
              ),
              const Gap(8),
              Text(
                t.roleSelection.subtitle,
                style: context.regular14.textSecondary,
                textAlign: TextAlign.center,
              ),

              //  Role cards
              const Gap(32),
              _RoleCard(
                role: AppRole.patient,
                selected: _selectedRole == AppRole.patient,
                icon: Icons.person_outline_rounded,
                title: t.roleSelection.roles.patient.title,
                description: t.roleSelection.roles.patient.description,
                onTap: () => setState(() => _selectedRole = AppRole.patient),
              ),
              const Gap(16),
              _RoleCard(
                role: AppRole.doctor,
                selected: _selectedRole == AppRole.doctor,
                icon: Icons.medical_services_outlined,
                title: t.roleSelection.roles.doctor.title,
                description: t.roleSelection.roles.doctor.description,
                onTap: () => setState(() => _selectedRole = AppRole.doctor),
              ),
              const Gap(16),
              _RoleCard(
                role: AppRole.admin,
                selected: _selectedRole == AppRole.admin,
                icon: Icons.admin_panel_settings_outlined,
                title: t.admin.chooseRole.title,
                description: t.admin.chooseRole.description,
                onTap: () => setState(() => _selectedRole = AppRole.admin),
              ),

              const Spacer(),

              //  Continue button
              MainButton(
                text: t.common.continueBtn,
                onPressed: _selectedRole != null
                    ? _onContinue
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(t.roleSelection.errorNoRole),
                            backgroundColor: AppColors.error,
                          ),
                        );
                      },
              ),
              const Gap(32),
            ],
          ),
        ),
      ),
    );
  }
}

//  Role Card

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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: selected ? selectedColor : AppColors.divider,
          width: selected ? 2 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: selected
                ? selectedColor.withValues(alpha: 0.30)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: selected ? 16 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon container
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: selected
                        ? selectedColor.withValues(alpha: 0.12)
                        : AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    size: 26,
                    color: selected ? selectedColor : AppColors.textSecondary,
                  ),
                ),
                const Gap(16),

                // Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: context.semiBold16.textPrimary),
                      const Gap(4),
                      Text(description, style: context.regular12.textSecondary),
                    ],
                  ),
                ),

                // Checkmark
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: selected ? 1 : 0,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: selectedColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      size: 16,
                      color: Colors.white,
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
