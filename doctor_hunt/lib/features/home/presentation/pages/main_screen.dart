import 'package:flutter/material.dart';

import '../../../../core/widgets/app_background.dart';
import '../../../../features/home/presentation/pages/home_screen.dart';
import '../../../../features/home/presentation/widgets/home_bottom_nav_bar.dart';
import '../../../doctors/presentation/pages/favorite_doctors_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: IndexedStack(
          index: _currentIndex,
          children: [
            const HomeScreen(),
            const FavoriteDoctorsScreen(),
            // Map/Book screen placeholder
            const Center(child: Text('Map / Bookings Screen')),
            // Chat screen placeholder
            const Center(child: Text('Chat Screen')),
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
    );
  }
}
