import '../../../../core/routes/app_routes.dart';
import '../../../../core/widgets/custom_text_form_field.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/utils/app_images.dart';
import 'package:go_router/go_router.dart';
import '../../../../../i18n/strings.g.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

class HomeHeader extends StatelessWidget {
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onClearSearch;
  final VoidCallback? onSearchTap;
  final VoidCallback? onAvatarTap;

  const HomeHeader({
    super.key,
    this.searchController,
    this.onSearchChanged,
    this.onClearSearch,
    this.onSearchTap,
    this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        String? name;
        String? imageUrl;
        bool hasImage = false;
        
        if (state is HomeLoaded) {
          name = state.patient?.name;
          imageUrl = state.patient?.image;
          hasImage = imageUrl != null && imageUrl.isNotEmpty;
        }

        final firstName = name?.split(' ').first ?? '';

        return Stack(
          clipBehavior: Clip.none,
          children: [
            // Top curved green container
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 50,
                bottom: 45,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withValues(alpha: 0.7),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        firstName.isNotEmpty
                            ? 'Hello, $firstName 👋'
                            : t.home.findYourDoctor,
                        style: context.bold24.copyWith(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                  // User Avatar — taps to open profile tab
                  GestureDetector(
                    onTap: onAvatarTap,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: ClipOval(
                        child: hasImage
                            ? CachedNetworkImage(
                                imageUrl: imageUrl!,
                                fit: BoxFit.cover,
                                placeholder: (_, _) => Container(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  child: const Icon(
                                    Icons.person_rounded,
                                    color: Colors.white,
                                    size: 26,
                                  ),
                                ),
                                errorWidget: (_, _, _) => Image.asset(
                                  AppImages.doctor,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Image.asset(AppImages.doctor, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Floating Search Bar
            Positioned(
              left: 20,
              right: 20,
              bottom: -24,
              child: CustomTextFormField(
                suffixIcon: GestureDetector(
                  onTap: onClearSearch,
                  child: Icon(
                    Icons.close_rounded,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.success,
                  size: 16,
                ),
                controller: searchController,
                onChange: onSearchChanged,
                textInputAction: TextInputAction.search,
                hintText: t.home.searchHint,
                onTap: () {
                  context.go(AppRoutes.search);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
