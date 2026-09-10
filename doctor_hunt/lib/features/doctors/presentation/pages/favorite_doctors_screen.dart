import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../i18n/strings.g.dart';
import '../cubit/favorite_cubit.dart';
import '../cubit/favorite_state.dart';

class FavoriteDoctorsScreen extends StatelessWidget {
  const FavoriteDoctorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final patientUid = AuthService.instance.currentUser?.uid;

    if (patientUid == null) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(child: Text(t.favorite.pleaseLogin)),
      );
    }

    return BlocProvider(
      create: (context) => FavoriteCubit()..loadFavorites(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const Padding(
            padding: EdgeInsets.only(left: 20, top: 8, bottom: 8),
          ),
          leadingWidth: 64,
          title: Text(
            t.home.favouriteDoctors,
            style: context.bold.px20.textPrimary,
          ),
          centerTitle: false,
        ),
        body: BlocBuilder<FavoriteCubit, FavoriteState>(
          builder: (context, state) {
            if (state is FavoriteLoading || state is FavoriteInitial) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }
            if (state is FavoriteError) {
              return Center(
                child: Text(
                  state.message,
                  style: context.regular14.textSecondary,
                ),
              );
            }
            if (state is FavoriteLoaded) {
              final favoriteDoctors = state.favoriteDoctors;

              if (favoriteDoctors.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.favorite_border_rounded,
                        size: 64,
                        color: AppColors.textHint,
                      ),
                      const Gap(16),
                      Text(
                        t.favorite.noFavoriteDoctors,
                        style: context.regular16.textSecondary,
                      ),
                      const Gap(8),
                      Text(
                        t.favorite.tapHeartHint,
                        style: context.regular14.textHint,
                      ),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                itemCount: favoriteDoctors.length,
                separatorBuilder: (context, index) => const Gap(16),
                itemBuilder: (context, index) {
                  final doctor = favoriteDoctors[index];
                  final hasImage =
                      doctor.imageUrl != null && doctor.imageUrl!.isNotEmpty;

                  return GestureDetector(
                    onTap: () {
                      context.push(AppRoutes.doctorDetails, extra: doctor);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.textPrimary.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: hasImage
                                ? CachedNetworkImage(
                                    imageUrl: doctor.imageUrl!,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      width: 80,
                                      height: 80,
                                      color: AppColors.primaryLight
                                          .withValues(alpha: 0.1),
                                      child: const Center(
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2)),
                                    ),
                                    errorWidget: (context, url, error) => Image.asset(
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
                          const Gap(16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  doctor.name ?? 'Doctor',
                                  style: context.bold16.textPrimary,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Gap(4),
                                Text(
                                  doctor.specialization ?? 'Specialist',
                                  style: context.regular14.textSecondary,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              final doctorName = doctor.name ?? 'Doctor';
                              
                              await context.read<FavoriteCubit>().removeFavorite(doctor.uid!);
                              
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    t.favorite.doctorRemoved(doctorName: doctorName),
                                  ),
                                  action: SnackBarAction(
                                    label: t.common.undo,
                                    textColor: AppColors.background,
                                    onPressed: () {
                                      context.read<FavoriteCubit>().addFavorite(doctor.uid!);
                                    },
                                  ),
                                  duration: const Duration(seconds: 3),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              );
                            },
                            child: const Icon(
                              Icons.favorite_rounded,
                              color: AppColors.error,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
