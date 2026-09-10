import '../../core/theme/colors.dart';
import '../../core/utils/app_images.dart';
import '../../i18n/strings.g.dart';
import '../../core/widgets/widgets.dart';
import '../../core/theme/style_atoms.dart';
import '../../core/routes/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

//  Data model

class _OnboardingPage {
  final String image;

  const _OnboardingPage({required this.image});
}

const _pages = [
  _OnboardingPage(image: AppImages.on1),
  _OnboardingPage(image: AppImages.on2),
  _OnboardingPage(image: AppImages.on3),
];

//  Screen

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
  }

  void _goToNextPage() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _finishOnboarding() {
    context.go(AppRoutes.role);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _currentPage == _pages.length - 1;

    return AppBackground(
      child: Stack(
        children: [
          //  PageView
          PageView.builder(
            controller: _controller,
            itemCount: _pages.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (context, index) =>
                _OnboardingPageView(page: _pages[index], index: index),
          ),

          //  Bottom controls
          Positioned(
            left: 24,
            right: 24,
            bottom: 40,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Dot indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == i ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: _currentPage == i
                            ? AppColors.primaryLight
                            : AppColors.surfaceDim,
                      ),
                    ),
                  ),
                ),
                Gap(24),

                // Next / Get Started button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: MainButton(
                    text: isLast ? t.common.getStarted : t.common.next,
                    onPressed: _goToNextPage,
                  ),
                ),
                Gap(12),

                // Skip button
                TextButton(
                  onPressed: _finishOnboarding,
                  child: Text(
                    t.common.skip,
                    style: context.regular14.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPageView extends StatelessWidget {
  final _OnboardingPage page;
  final int index;

  const _OnboardingPageView({required this.page, required this.index});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        //  Top image section with teal arc background
        SizedBox(
          height: size.height * 0.52,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Circle: top-left on pages 0 & 2, top-right on page 1
              Positioned(
                top: -size.width * 0.35,
                left: index.isEven ? -size.width * 0.36 : null,
                right: index.isOdd ? -size.width * 0.36 : null,
                child: Container(
                  width: size.width * 1.1,
                  height: size.width * 1.1,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              // Circular clipped photo
              Positioned(
                bottom: 0,
                child: Container(
                  width: size.width * 0.72,
                  height: size.width * 0.72,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: ClipOval(
                    child: Image.asset(page.image, fit: BoxFit.cover),
                  ),
                ),
              ),
            ],
          ),
        ),

        Gap(32),

        //  Text content
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              Text(
                t.onboarding.pages[index].title,
                textAlign: TextAlign.center,
                style: context.bold24.textPrimary,
              ),
              Gap(12),
              Text(
                t.onboarding.pages[index].description,
                textAlign: TextAlign.center,
                style: context.regular14.textSecondary.copyWith(height: 1.6),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
