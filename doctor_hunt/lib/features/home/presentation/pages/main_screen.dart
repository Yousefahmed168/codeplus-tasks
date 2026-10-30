import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/app_background.dart';
import '../../../appointments/views/appointments_screen.dart';
import '../../../patient_profile/presentation/pages/patient_profile_screen.dart';
import '../../../search/presentation/pages/find_doctor.dart';
import 'home_screen.dart';
import '../widgets/home_bottom_nav_bar.dart';

/// Patient shell with the four MVP tabs: Home, Doctors, Appointments, Profile.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
        }
      },
      child: AppBackground(
        // AppBackground wraps this shell in a Scaffold. If it resizes for the
        // keyboard it shrinks the shell first and the nav bar rides up on top
        // of the keyboard, so the outer background must not resize either.
        resizeToAvoidBottomInset: false,
        child: Scaffold(
          backgroundColor: AppColors.transparent,
          // Keep the bottom nav bar pinned below the keyboard instead of
          // letting it ride up on top of it when a tab's field is focused.
          resizeToAvoidBottomInset: false,
          body: IndexedStack(
            index: _currentIndex,
            children: [
              HomeScreen(
                onAvatarTap: () => context.push(AppRoutes.patientProfile),
              ),
              const FindDoctorScreen(isTab: true),
              const AppointmentsScreen(),
              const PatientProfileScreen(isTab: true),
            ],
          ),
          // While the keyboard is open the nav bar is removed from the layout
          // instead of only being painted behind the keyboard. Otherwise its
          // reserved height leaves a blank band between the content and the
          // keyboard.
          bottomNavigationBar: MediaQuery.viewInsetsOf(context).bottom > 0
              ? null
              : HomeBottomNavBar(
                  currentIndex: _currentIndex,
                  onTap: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
        ),
      ),
    );
  }
}
