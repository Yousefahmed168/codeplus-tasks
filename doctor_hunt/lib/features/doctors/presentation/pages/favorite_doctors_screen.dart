import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/services/user_service.dart';
import '../../../../core/services/favorite_service.dart';
import '../../../../core/services/auth_service.dart';
import '../../models/doctor_model.dart';
import '../../../../i18n/strings.g.dart';

class FavoriteDoctorsScreen extends StatefulWidget {
  const FavoriteDoctorsScreen({super.key});

  @override
  State<FavoriteDoctorsScreen> createState() => _FavoriteDoctorsScreenState();
}

class _FavoriteDoctorsScreenState extends State<FavoriteDoctorsScreen> {
  String? get _patientUid => AuthService.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    // If not logged in, show nothing
    if (_patientUid == null) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(child: Text(t.favorite.pleaseLogin)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20, top: 8, bottom: 8),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.textPrimary,
                size: 16,
              ),
              onPressed: () {},
            ),
          ),
        ),
        leadingWidth: 64,
        title: Text(
          t.home.favouriteDoctors,
          style: context.bold.px20.textPrimary,
        ),
        centerTitle: false,
      ),
      body: StreamBuilder<Set<String>>(
        stream: FavoriteService.instance.streamFavoriteIds(_patientUid!),
        builder: (context, favSnapshot) {
          final favoriteIds = favSnapshot.data ?? {};

          return StreamBuilder<List<DoctorModel>>(
            stream: UserService.instance.streamDoctors(),
            builder: (context, docSnapshot) {
              if (docSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }
              if (docSnapshot.hasError) {
                return Center(
                  child: Text(
                    'Failed to load doctors',
                    style: context.regular14.textSecondary,
                  ),
                );
              }

              final allDoctors = docSnapshot.data ?? [];
              // Filter to only show favorited doctors
              final favoriteDoctors = allDoctors
                  .where((d) => d.uid != null && favoriteIds.contains(d.uid))
                  .toList();

              if (favoriteDoctors.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_border_rounded,
                        size: 64,
                        color: AppColors.textHint,
                      ),
                      const Gap(16),
                      Text(
                        'No favorite doctors yet',
                        style: context.regular16.textSecondary,
                      ),
                      const Gap(8),
                      Text(
                        'Tap the heart icon on any doctor to add them here',
                        style: context.regular14.textHint,
                      ),
                    ],
                  ),
                );
              }

              return CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(20),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.85,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final doctor = favoriteDoctors[index];
                          return _buildDoctorGridCard(context, doctor);
                        },
                        childCount: favoriteDoctors.length,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDoctorGridCard(BuildContext context, DoctorModel doctor) {
    final patientUid = _patientUid!;
    return GestureDetector(
      onTap: () =>
          context.push(AppRoutes.doctorDetails, extra: doctor.toDoctor(isFavorite: true)),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipOval(
                    child: (doctor.imageUrl != null &&
                            doctor.imageUrl!.isNotEmpty)
                        ? CachedNetworkImage(
                            imageUrl: doctor.imageUrl!,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorWidget: (_, _, _) => Image.asset(
                              AppImages.doctor,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Image.asset(
                            AppImages.doctor,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                  ),
                  const Gap(12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      doctor.name ?? 'Unknown',
                      style: context.bold16.textPrimary,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Gap(4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      doctor.specialization ?? 'General',
                      style: context.regular12.primary,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            // Favorite heart - tap to REMOVE from favorites
            Positioned(
              top: 12,
              right: 12,
              child: GestureDetector(
                onTap: () async {
                  final doctorName = doctor.name ?? 'Doctor';
                  await FavoriteService.instance.toggleFavorite(
                    patientUid: patientUid,
                    doctorUid: doctor.uid!,
                  );
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('$doctorName removed from favorites'),
                        action: SnackBarAction(
                          label: t.common.undo,
                          textColor: AppColors.primary,
                          onPressed: () async {
                            await FavoriteService.instance.addFavorite(
                              patientUid: patientUid,
                              doctorUid: doctor.uid!,
                            );
                          },
                        ),
                        duration: const Duration(seconds: 3),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  }
                },
                child: const Icon(
                  Icons.favorite_rounded,
                  color: Colors.red,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
