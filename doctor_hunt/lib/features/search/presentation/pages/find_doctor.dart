import '../../../doctors/models/doctor_model.dart';

import '../../../../core/widgets/custom_text_form_field.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/widgets/app_background.dart';
import '../../../../core/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../i18n/strings.g.dart';

class FindDoctorScreen extends StatefulWidget {
  const FindDoctorScreen({super.key});

  @override
  State<FindDoctorScreen> createState() => _FindDoctorScreenState();
}

class _FindDoctorScreenState extends State<FindDoctorScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String _searchQuery = "";


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go(AppRoutes.home);
                        }
                      },
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 20,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Gap(12),
                    Text(
                      t.findDoctors.title,
                      style: context.bold20.textPrimary,
                    ),
                  ],
                ),
              ),
              Gap(20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        suffixIcon: GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
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
                        controller: _searchController,
                        onChange: (v) => setState(() => _searchQuery = v),
                        textInputAction: TextInputAction.search,
                        hintText: t.home.searchHint,
                      ),
                    ),
                  ],
                ),
              ),
              Gap(24),
              Expanded(
                child: _buildSearchResults(),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildSearchResults() {
    return StreamBuilder<List<DoctorModel>>(
      stream: UserService.instance.streamDoctors(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text(
              t.home.failedToLoadDoctors,
              style: context.regular14.textSecondary,
            ),
          );
        }

        final allDoctors = snapshot.data ?? [];
        final results = allDoctors
            .where(
              (d) =>
                  (d.name ?? '').toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ) ||
                  (d.specialization ?? '').toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ),
            )
            .toList();

        if (results.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off_rounded,
                  size: 64,
                  color: AppColors.textHint.withValues(alpha: 0.5),
                ),
                Gap(16),
                Text(
                  t.findDoctors.noDoctorsFound,
                  style: context.bold16.textSecondary,
                ),
                Gap(8),
                Text(
                  t.findDoctors.tryDifferentSearchTerm,
                  style: context.regular14.textHint,
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: results.length,
          separatorBuilder: (_, _) => Gap(16),
          itemBuilder: (context, index) {
            final doctor = results[index];
            return _buildDoctorResultCard(context, doctor);
          },
        );
      },
    );
  }

  Widget _buildDoctorResultCard(BuildContext context, DoctorModel doctor) {
    return GestureDetector(
      onTap: () {
        context.push(
          AppRoutes.doctorDetails,
          extra: doctor.toDoctor(),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: (doctor.imageUrl != null && doctor.imageUrl!.isNotEmpty)
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
            Gap(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name ?? 'Unknown',
                    style: context.bold16.textPrimary,
                  ),
                  Gap(2),
                  Text(
                    doctor.specialization ?? 'General',
                    style: context.regular14.primary,
                  ),
                  Gap(4),
                  Text(
                    t.findDoctors.tenYearsExperience,
                    style: context.regular12.textSecondary,
                  ),
                  Gap(6),
                  Row(
                    children: [
                      Icon(Icons.star_rounded, size: 14, color: AppColors.star),
                      Gap(4),
                      Text(
                        (doctor.rating ?? 0).toStringAsFixed(1),
                        style: context.regular12.textSecondary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
