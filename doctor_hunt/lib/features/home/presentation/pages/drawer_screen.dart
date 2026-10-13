import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/double_back_to_exit.dart';
import 'main_screen.dart';
import '../widgets/menu_content.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({super.key});

  static DrawerScreenState? of(BuildContext context) {
    return context.findAncestorStateOfType<DrawerScreenState>();
  }

  @override
  State<DrawerScreen> createState() => DrawerScreenState();
}

class DrawerScreenState extends State<DrawerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _menuScaleAnimation;
  bool isDrawerOpen = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0.7, 0), // 70% of screen width
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _menuScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  void toggleDrawer() {
    if (isDrawerOpen) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
    setState(() {
      isDrawerOpen = !isDrawerOpen;
    });
  }

  void closeDrawer() {
    if (isDrawerOpen) {
      _animationController.reverse();
      setState(() {
        isDrawerOpen = false;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return DoubleBackToExit(
      onPopIntercept: () {
        if (isDrawerOpen) {
          closeDrawer();
          return true;
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.menuBackground,
        body: Stack(
          children: [
            // Menu layer
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _menuScaleAnimation.value,
                  alignment: Alignment.centerLeft,
                  child: child,
                );
              },
              child: const MenuContent(),
            ),
            // Main Screen layer
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(screenWidth * _slideAnimation.value.dx, 0),
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(isDrawerOpen ? 32.r : 0),
                      child: IgnorePointer(
                        ignoring: isDrawerOpen,
                        child: child,
                      ),
                    ),
                  ),
                );
              },
              child: const MainScreen(),
            ),
            
            // Tap outside to close
            if (isDrawerOpen)
              Positioned(
                top: 0,
                bottom: 0,
                left: screenWidth * 0.7,
                right: 0,
                child: GestureDetector(
                  onTap: closeDrawer,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
