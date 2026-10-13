import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/enums/app_language.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/widgets/custom_back_button.dart';
import '../../../../i18n/strings.g.dart';
import '../../../auth/data/models/patient_model.dart';
import '../../../auth/presentation/widgets/logout_dialog.dart';
import '../cubit/patient_settings_cubit.dart';
import '../cubit/patient_settings_state.dart';
import '../widgets/language_picker_sheet.dart';

/// Patient settings screen.
///
/// Used as the settings tab of the main shell, and as a pushed route from the
/// drawer. The back button only appears when the route can be popped.
class PatientSettingsScreen extends StatelessWidget {
  const PatientSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PatientSettingsCubit()..loadSettings(),
      child: const _PatientSettingsView(),
    );
  }
}

class _PatientSettingsView extends StatelessWidget {
  const _PatientSettingsView();

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);

    return BlocListener<PatientSettingsCubit, PatientSettingsState>(
      listenWhen: (previous, current) =>
          current.error != null && previous.error != current.error,
      listener: (context, state) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.error!),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        );
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          leadingWidth: canPop ? 70.w : 0,
          leading: canPop
              ? Padding(
                  padding: EdgeInsets.only(left: 16.w),
                  child: const CustomBackButton(),
                )
              : null,
          titleSpacing: canPop ? 0 : 20.w,
          title: Text(
            t.patientSettings.title,
            style: context.bold18.textPrimary,
          ),
          centerTitle: false,
        ),
        body: BlocBuilder<PatientSettingsCubit, PatientSettingsState>(
          builder: (context, state) {
            return ListView(
              padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
              children: [
                _UserInfoCard(
                  patient: state.patient,
                  isLoading: state.isLoading,
                ),
                24.verticalSpace,

                // ----- Account settings -----
                _SectionHeader(title: t.patientSettings.accountSettings),
                12.verticalSpace,
                _ActionRow(
                  icon: Icons.lock_outline_rounded,
                  iconBackground: AppColors.settingsIconRed,
                  title: t.patientSettings.changePassword,
                  onTap: () => context.push(AppRoutes.changePassword),
                ),
                10.verticalSpace,
                _SwitchRow(
                  icon: Icons.notifications_none_rounded,
                  iconBackground: AppColors.primary,
                  title: t.patientSettings.notifications,
                  value: state.notificationsEnabled,
                  onChanged: (value) => context
                      .read<PatientSettingsCubit>()
                      .toggleNotifications(value),
                ),
                10.verticalSpace,
                _ActionRow(
                  icon: Icons.privacy_tip_outlined,
                  iconBackground: AppColors.settingsIconOrange,
                  title: t.patientSettings.privacyPolicy,
                  onTap: () => context.push(AppRoutes.privacyPolicy),
                ),

                28.verticalSpace,

                // ----- More options -----
                _SectionHeader(title: t.patientSettings.moreOptions),
                12.verticalSpace,
                _ValueRow(
                  title: t.patientSettings.languages,
                  value: _languageLabel(state.language),
                  onTap: () => _pickLanguage(context, state.language),
                ),
                10.verticalSpace,
                _ValueRow(
                  title: t.patientSettings.buildVersion,
                  value: state.appVersion,
                ),

                32.verticalSpace,
                _LogoutButton(
                  isBusy: state.isLoggingOut,
                  onTap: () => _handleLogout(context),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  String _languageLabel(AppLanguage language) {
    switch (language) {
      case AppLanguage.english:
        return t.patientSettings.languageEnglish;
    }
  }

  Future<void> _pickLanguage(BuildContext context, AppLanguage selected) async {
    final cubit = context.read<PatientSettingsCubit>();
    final chosen = await LanguagePickerSheet.show(context, selected: selected);
    if (chosen == null) return;
    await cubit.setLanguage(chosen);
  }

  Future<void> _handleLogout(BuildContext context) async {
    final cubit = context.read<PatientSettingsCubit>();
    final confirmed = await LogoutDialog.show(context);
    if (confirmed != true) return;
    await cubit.logout();
    if (!context.mounted) return;
    context.go(AppRoutes.role);
  }
}

/// Quick information card: avatar, name and email. Tapping opens the profile.
class _UserInfoCard extends StatelessWidget {
  const _UserInfoCard({required this.patient, required this.isLoading});

  final PatientModel? patient;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final name = patient?.name?.trim() ?? '';
    final email = patient?.email?.trim() ?? '';
    final imageUrl = patient?.image ?? '';

    return InkWell(
      onTap: () => context.push(AppRoutes.patientProfile),
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withValues(alpha: 0.04),
              blurRadius: 10.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52.r,
              height: 52.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surfaceVariant,
              ),
              child: ClipOval(
                child: imageUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (_, _) => Icon(
                          Icons.person_rounded,
                          color: AppColors.primary,
                          size: 28.r,
                        ),
                        errorWidget: (_, _, _) => Icon(
                          Icons.person_rounded,
                          color: AppColors.primary,
                          size: 28.r,
                        ),
                      )
                    : Icon(
                        Icons.person_rounded,
                        color: AppColors.primary,
                        size: 28.r,
                      ),
              ),
            ),
            14.horizontalSpace,
            Expanded(
              child: isLoading
                  ? Shimmer.fromColors(
                      baseColor: AppColors.surfaceVariant,
                      highlightColor: AppColors.surface,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _placeholderBox(120.w, 14.h),
                          8.verticalSpace,
                          _placeholderBox(160.w, 12.h),
                        ],
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name.isEmpty ? t.common.notProvided : name,
                          style: context.semiBold16.textPrimary,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        2.verticalSpace,
                        Text(
                          email.isEmpty ? t.common.notProvided : email,
                          style: context.regular12.textSecondary,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
            ),
            8.horizontalSpace,
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textHint,
              size: 22.r,
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholderBox(double width, double height) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: AppColors.surfaceVariant,
      borderRadius: BorderRadius.circular(6.r),
    ),
  );
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: context.semiBold14.copyWith(color: AppColors.textSecondary),
    );
  }
}

/// Rounded white row used by every settings entry.
class _SettingsRowShell extends StatelessWidget {
  const _SettingsRowShell({required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withValues(alpha: 0.03),
              blurRadius: 8.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

class _IconTile extends StatelessWidget {
  const _IconTile({required this.icon, required this.background});

  final IconData icon;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36.r,
      height: 36.r,
      decoration: BoxDecoration(color: background, shape: BoxShape.circle),
      child: Icon(icon, color: AppColors.textOnPrimary, size: 20.r),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.icon,
    required this.iconBackground,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final Color iconBackground;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _SettingsRowShell(
      onTap: onTap,
      child: Row(
        children: [
          _IconTile(icon: icon, background: iconBackground),
          16.horizontalSpace,
          Expanded(child: Text(title, style: context.medium14.textPrimary)),
          Icon(
            Icons.chevron_right_rounded,
            color: AppColors.textSecondary,
            size: 22.r,
          ),
        ],
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.icon,
    required this.iconBackground,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final Color iconBackground;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return _SettingsRowShell(
      child: Row(
        children: [
          _IconTile(icon: icon, background: iconBackground),
          16.horizontalSpace,
          Expanded(child: Text(title, style: context.medium14.textPrimary)),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

/// Title plus a read-only value; the chevron only shows when [onTap] is set.
class _ValueRow extends StatelessWidget {
  const _ValueRow({required this.title, required this.value, this.onTap});

  final String title;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return _SettingsRowShell(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(child: Text(title, style: context.medium14.textPrimary)),
          8.horizontalSpace,
          Flexible(
            child: Text(
              value,
              style: context.regular12.copyWith(color: AppColors.textSecondary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
            ),
          ),
          if (onTap != null) ...[
            4.horizontalSpace,
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary,
              size: 20.r,
            ),
          ],
        ],
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({required this.isBusy, required this.onTap});

  final bool isBusy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isBusy ? 0.6 : 1,
      child: InkWell(
        onTap: isBusy ? null : onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          height: 52.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.destructiveRedLight,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: AppColors.error.withValues(alpha: 0.25)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout_rounded, color: AppColors.error, size: 20.r),
              8.horizontalSpace,
              Text(
                t.common.logout,
                style: context.semiBold16.copyWith(color: AppColors.error),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
