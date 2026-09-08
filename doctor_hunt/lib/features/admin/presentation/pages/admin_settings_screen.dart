import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});
  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  bool _notifications = true,
      _maintenance = false,
      _autoApprove = false,
      _emailNotif = true,
      _darkMode = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    setState(() {
      _notifications = p.getBool('admin_notifications') ?? true;
      _maintenance = p.getBool('admin_maintenance') ?? false;
      _autoApprove = p.getBool('admin_auto_approve') ?? false;
      _emailNotif = p.getBool('admin_email_notifications') ?? true;
      _darkMode = p.getBool('admin_dark_mode') ?? false;
    });
  }

  Future<void> _save(String k, bool v) async {
    await (await SharedPreferences.getInstance()).setBool(k, v);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        automaticallyImplyLeading: false,
        title: Text('Settings', style: context.bold18.copyWith(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
            onPressed: () async {
              await AuthService.instance.logout();
              if (mounted) context.go(AppRoutes.role);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _header('App Settings'),
          const Gap(12),
          _card([
            _switch(
              Icons.notifications_outlined,
              'Push Notifications',
              'Enable push notifications for all users',
              _notifications,
              (v) {
                setState(() => _notifications = v);
                _save('admin_notifications', v);
              },
            ),
            _div,
            _switch(
              Icons.email_outlined,
              'Email Notifications',
              'Send email notifications for important events',
              _emailNotif,
              (v) {
                setState(() => _emailNotif = v);
                _save('admin_email_notifications', v);
              },
            ),
          ]),
          const Gap(20),
          _header('Doctor Management'),
          const Gap(12),
          _card([
            _switch(
              Icons.person_add_outlined,
              'Auto-Approve Doctors',
              'Automatically approve new doctor registrations',
              _autoApprove,
              (v) {
                setState(() => _autoApprove = v);
                _save('admin_auto_approve', v);
              },
            ),
          ]),
          const Gap(20),
          _header('System'),
          const Gap(12),
          _card([
            _switch(
              Icons.build_outlined,
              'Maintenance Mode',
              'Put the app in maintenance mode for all users',
              _maintenance,
              (v) {
                setState(() => _maintenance = v);
                _save('admin_maintenance', v);
              },
              destructive: true,
            ),
            _div,
            _switch(
              Icons.dark_mode_outlined,
              'Dark Mode',
              'Enable dark mode for admin interface',
              _darkMode,
              (v) {
                setState(() => _darkMode = v);
                _save('admin_dark_mode', v);
              },
            ),
          ]),
          const Gap(20),
          _header('Account'),
          const Gap(12),
          _card([
            _nav(
              Icons.person_outline,
              'Admin Profile',
              'Manage your admin account',
              () {},
            ),
            _div,
            _nav(
              Icons.help_outline,
              'Help & Support',
              'Get help with the admin panel',
              () {},
            ),
            _div,
            _nav(
              Icons.info_outline,
              'About',
              'App version and information',
              () {},
            ),
          ]),
          const Gap(32),
        ],
      ),
    );
  }

  Widget _header(String t) => Text(t, style: context.semiBold16.textPrimary);
  Widget get _div => Divider(height: 1, indent: 68, color: AppColors.divider);

  Widget _card(List<Widget> children) => Container(
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
    child: Column(children: children),
  );

  Widget _switch(
    IconData icon,
    String title,
    String sub,
    bool val,
    ValueChanged<bool> onChanged, {
    bool destructive = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (destructive ? AppColors.error : AppColors.primary)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: destructive ? AppColors.error : AppColors.primary,
              size: 22,
            ),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.semiBold14.textPrimary),
                const Gap(2),
                Text(sub, style: context.regular12.textSecondary),
              ],
            ),
          ),
          Switch(
            value: val,
            onChanged: onChanged,
            activeThumbColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _nav(IconData icon, String title, String sub, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                  Text(sub, style: context.regular12.textSecondary),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textHint,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
