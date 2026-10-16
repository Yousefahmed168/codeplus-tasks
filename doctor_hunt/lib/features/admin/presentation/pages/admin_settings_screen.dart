import '../../../auth/presentation/widgets/logout_dialog.dart'
    show LogoutDialog;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/utils/string_utils.dart';
import '../../../../i18n/strings.g.dart';
import '../../../../core/constants/my_icons.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  User? get _user => FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final user = _user;
    final displayName = user?.displayName ?? 'Administrator';
    final email = user?.email ?? 'admin@doctorhunt.com';
    final initials = StringUtils.getInitials(displayName);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        automaticallyImplyLeading: false,
        title: Text(
          t.admin.settings.title,
          style: context.bold18.copyWith(color: AppColors.textOnPrimary),
        ),
        centerTitle: true,
        actions: [
          4.horizontalSpace,
          Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: Container(
              width: 32.r,
              height: 32.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.2),
                image: user?.photoURL != null && user!.photoURL!.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(user.photoURL!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: user?.photoURL == null || user!.photoURL!.isEmpty
                  ? Center(
                      child: Text(
                        initials,
                        style: context.semiBold12.copyWith(color: AppColors.textOnPrimary),
                      ),
                    )
                  : null,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16.r),
        children: [
          // Admin profile card
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.textPrimary.withValues(alpha: 0.05),
                  blurRadius: 10.r,
                  offset: Offset(0, 2.h),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 48.r,
                  height: 48.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withValues(alpha: 0.1),
                    image: user?.photoURL != null && user!.photoURL!.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(user.photoURL!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: user?.photoURL == null || user!.photoURL!.isEmpty
                      ? Icon(MyIcons.person, color: AppColors.primary, size: 24.r)
                      : null,
                ),
                12.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(displayName, style: context.semiBold16.textPrimary),
                      2.verticalSpace,
                      Text(email, style: context.regular12.textSecondary),
                    ],
                  ),
                ),
              ],
            ),
          ),
          20.verticalSpace,

          // Admin Profile
          _buildNavRow(
            icon: MyIcons.personOutline,
            title: t.admin.settings.adminProfile,
            subtitle: t.admin.settings.adminProfileDesc,
            onTap: () => context.push(AppRoutes.editAdminProfile),
          ),
          12.verticalSpace,

          // Change Password
          _buildNavRow(
            icon: MyIcons.lockOutline,
            title: t.admin.settings.changePassword,
            subtitle: t.admin.settings.changePasswordDesc,
            onTap: () => context.push(AppRoutes.changePassword),
          ),
          12.verticalSpace,

          // App Information
          _buildInfoRow(
            icon: MyIcons.infoOutline,
            title: t.admin.settings.appInformation,
            subtitle: t.admin.settings.appVersion,
            version: 'v1.0.0',
          ),
          24.verticalSpace,

          // Logout button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () async {
                final confirmed = await LogoutDialog.show(context);
                if (confirmed == true) {
                  await sl<AuthService>().logout();
                  if (!context.mounted) return;
                  context.go(AppRoutes.role);
                }
              },
              icon: Icon(MyIcons.logout, color: AppColors.error, size: 20.r),
              label: Text(
                t.common.logout,
                style: context.semiBold16.copyWith(color: AppColors.error),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.error, width: 1.5.w),
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
            ),
          ),
          32.verticalSpace,
        ],
      ),
    );
  }

  Widget _buildNavRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withValues(alpha: 0.05),
              blurRadius: 10.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, color: AppColors.primary, size: 22.r),
            ),
            12.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: context.semiBold14.textPrimary),
                  2.verticalSpace,
                  Text(subtitle, style: context.regular12.textSecondary),
                ],
              ),
            ),
            Icon(
              MyIcons.chevronRightRounded,
              color: AppColors.textHint,
              size: 24.r,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String subtitle,
    String? version,
  }) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.05),
            blurRadius: 10.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22.r),
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.semiBold14.textPrimary),
                2.verticalSpace,
                Text(subtitle, style: context.regular12.textSecondary),
              ],
            ),
          ),
          if (version != null)
            Text(version, style: context.regular12.textSecondary),
        ],
      ),
    );
  }
}
