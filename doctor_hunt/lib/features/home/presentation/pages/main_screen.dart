import '../../../appointments/views/appointments_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/favorite_service.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/app_background.dart';
import '../../../../features/home/presentation/pages/home_screen.dart';
import '../../../../features/home/presentation/widgets/home_bottom_nav_bar.dart';
import '../../../doctors/presentation/pages/favorite_doctors_screen.dart';
import '../../../patient_profile/presentation/pages/patient_settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  String? get _patientUid => sl<AuthService>().currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    // Stream favorite count for the badge
    final Stream<Set<String>> favoriteStream = _patientUid != null
        ? sl<FavoriteService>().streamFavoriteIds(_patientUid!)
        : Stream.value(<String>{});

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
            const FavoriteDoctorsScreen(),
            const AppointmentsScreen(),
            const PatientSettingsScreen(),
          ],
        ),
        bottomNavigationBar: StreamBuilder<Set<String>>(
          stream: favoriteStream,
          builder: (context, snapshot) {
            final count = snapshot.data?.length ?? 0;
            return HomeBottomNavBar(
              currentIndex: _currentIndex,
              favoritesCount: count,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            );
          },
        ),
      ),
    ),
    );
  }
}
