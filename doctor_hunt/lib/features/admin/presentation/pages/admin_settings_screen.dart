import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../i18n/strings.g.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  bool _notifications = true;

  User? get _user => FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    setState(() {
      _notifications = p.getBool('admin_notifications') ?? true;
    });
  }

  Future<void> _saveNotifications(bool v) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool('admin_notifications', v);
  }

  String _getInitials(String name) {
    if (name.isEmpty) return 'A';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final user = _user;
    final displayName = user?.displayName ?? 'Administrator';
    final email = user?.email ?? 'admin@doctorhunt.com';
    final initials = _getInitials(displayName);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        automaticallyImplyLeading: false,
        title: Text(
          t.admin.settings.title,
          style: context.bold18.copyWith(color: AppColors.background),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.background,
            ),
            onPressed: () {},
          ),
          const Gap(4),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              width: 32,
              height: 32,
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
                        style: context.semiBold12.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    )
                  : null,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Admin profile card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
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
                      ? Icon(
                          Icons.person,
                          color: AppColors.primary,
                          size: 24,
                        )
                      : null,
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: context.semiBold16.textPrimary,
                      ),
                      const Gap(2),
                      Text(
                        email,
                        style: context.regular12.textSecondary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Gap(20),

          // Admin Profile
          _buildNavRow(
            icon: Icons.person_outline,
            title: t.admin.settings.adminProfile,
            subtitle: t.admin.settings.adminProfileDesc,
            onTap: () => context.push(AppRoutes.editAdminProfile),
          ),
          const Gap(12),

          // Change Password
          _buildNavRow(
            icon: Icons.lock_outline,
            title: t.admin.settings.changePassword,
            subtitle: t.admin.settings.changePasswordDesc,
            onTap: () => context.push(AppRoutes.changePassword),
          ),
          const Gap(12),

          // Notification Preferences
          _buildSwitchRow(
            icon: Icons.notifications_outlined,
            title: t.admin.settings.notificationPreferences,
            subtitle: t.admin.settings.notificationPreferencesDesc,
            value: _notifications,
            onChanged: (v) {
              setState(() => _notifications = v);
              _saveNotifications(v);
            },
          ),
          const Gap(12),

          // App Information
          _buildInfoRow(
            icon: Icons.info_outline,
            title: t.admin.settings.appInformation,
            subtitle: t.admin.settings.appVersion,
            version: 'v1.0.0',
          ),
          const Gap(24),

          // Logout button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              onPressed: () async {
                await AuthService.instance.logout();
                if (!context.mounted) return;
                context.go(AppRoutes.role);
              },
              icon: const Icon(Icons.logout, color: AppColors.error),
              label: Text(
                t.common.logout,
                style: context.semiBold16.copyWith(color: AppColors.error),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.error, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
          const Gap(32),
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primary, size: 22),
            ),
            const Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: context.semiBold14.textPrimary),
                  const Gap(2),
                  Text(subtitle, style: context.regular12.textSecondary),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textHint,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.semiBold14.textPrimary),
                const Gap(2),
                Text(subtitle, style: context.regular12.textSecondary),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.primary,
          ),
        ],
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.semiBold14.textPrimary),
                const Gap(2),
                Text(subtitle, style: context.regular12.textSecondary),
              ],
            ),
          ),
          if (version != null)
            Text(
              version,
              style: context.regular12.textSecondary,
            ),
        ],
      ),
    );
  }
}
