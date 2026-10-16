import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/double_back_to_exit.dart';
import '../../../../i18n/strings.g.dart';
import 'admin_appointments_screen.dart';
import 'admin_doctors_screen.dart';
import 'admin_settings_screen.dart';
import '../../../../core/constants/my_icons.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int _currentTab = 0;

  final List<Widget> _screens = [
    const AdminDoctorsScreen(),
    const AdminAppointmentsScreen(),
    const AdminSettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return DoubleBackToExit(
      onPopIntercept: () {
        if (_currentTab != 0) {
          setState(() => _currentTab = 0);
          return true;
        }
        return false;
      },
      child: Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: _currentTab, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTab,
        onTap: (i) => setState(() => _currentTab = i),
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textHint,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(MyIcons.peopleOutline),
            activeIcon: const Icon(MyIcons.people),
            label: t.admin.doctors.title,
          ),
          BottomNavigationBarItem(
            icon: const Icon(MyIcons.menuBookOutlined),
            activeIcon: const Icon(MyIcons.menuBook),
            label: t.admin.appointments.title,
          ),
          BottomNavigationBarItem(
            icon: const Icon(MyIcons.settingsOutlined),
            activeIcon: const Icon(MyIcons.settings),
            label: t.admin.settings.title,
          ),
        ],
      ),
    ),
    );
  }
}
