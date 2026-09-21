import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../i18n/strings.g.dart';

import '../../../../core/widgets/widgets.dart';

class PatientSettingsScreen extends StatefulWidget {
  const PatientSettingsScreen({super.key});

  @override
  State<PatientSettingsScreen> createState() => _PatientSettingsScreenState();
}

class _PatientSettingsScreenState extends State<PatientSettingsScreen> {
  bool _textMessages = true;
  bool _phoneCalls = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _textMessages = prefs.getBool('patient_text_messages') ?? true;
      _phoneCalls = prefs.getBool('patient_phone_calls') ?? true;
    });
  }

  Future<void> _saveSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 70,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16),
          child: CustomBackButton(),
        ),
        title: Text(
          t.patientSettings.title,
          style: context.bold18.textPrimary,
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Account Settings Section
          Text(
            t.patientSettings.accountSettings,
            style: context.semiBold14.copyWith(color: AppColors.textSecondary),
          ),
          const Gap(12),
          _buildActionItem(
            context,
            icon: Icons.lock_outline_rounded,
            iconBgColor: const Color(0xFFFF6B6B),
            title: t.patientSettings.changePassword,
            onTap: () => context.push(AppRoutes.changePassword),
          ),
          const Gap(10),
          _buildActionItem(
            context,
            icon: Icons.notifications_none_rounded,
            iconBgColor: const Color(0xFF0EBE7E),
            title: t.patientSettings.notifications,
            onTap: () {},
          ),
          const Gap(10),
          _buildActionItem(
            context,
            icon: Icons.bar_chart_rounded,
            iconBgColor: const Color(0xFF4C84FF),
            title: t.patientSettings.statistics,
            onTap: () {},
          ),
          const Gap(10),
          _buildActionItem(
            context,
            icon: Icons.person_outline_rounded,
            iconBgColor: const Color(0xFFFF9F43),
            title: t.patientSettings.aboutUs,
            onTap: () {},
          ),

          const Gap(28),

          // More Options Section
          Text(
            t.patientSettings.moreOptions,
            style: context.semiBold14.copyWith(color: AppColors.textSecondary),
          ),
          const Gap(12),
          _buildSwitchItem(
            context,
            title: t.patientSettings.textMessages,
            value: _textMessages,
            onChanged: (v) {
              setState(() => _textMessages = v);
              _saveSetting('patient_text_messages', v);
            },
          ),
          const Gap(10),
          _buildSwitchItem(
            context,
            title: t.patientSettings.phoneCalls,
            value: _phoneCalls,
            onChanged: (v) {
              setState(() => _phoneCalls = v);
              _saveSetting('patient_phone_calls', v);
            },
          ),
          const Gap(10),
          _buildValueItem(
            context,
            title: t.patientSettings.languages,
            value: 'English',
            onTap: () {},
          ),
          const Gap(10),
          _buildValueItem(
            context,
            title: t.patientSettings.currency,
            value: '\$-USD',
            onTap: () {},
          ),
          const Gap(10),
          _buildValueItem(
            context,
            title: t.patientSettings.linkedAccounts,
            value: 'Facebook, Google',
            onTap: () {},
          ),
          const Gap(32),
        ],
      ),
    );
  }

  Widget _buildActionItem(
    BuildContext context, {
    required IconData icon,
    required Color iconBgColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const Gap(16),
            Expanded(
              child: Text(
                title,
                style: context.medium14.textPrimary,
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchItem(
    BuildContext context, {
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: context.medium14.textPrimary,
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

  Widget _buildValueItem(
    BuildContext context, {
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: context.medium14.textPrimary,
            ),
            Row(
              children: [
                Text(
                  value,
                  style: context.regular12.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const Gap(4),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
