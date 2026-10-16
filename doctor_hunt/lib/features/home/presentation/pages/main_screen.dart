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
        child: Scaffold(
          backgroundColor: AppColors.transparent,
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
          bottomNavigationBar: HomeBottomNavBar(
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
