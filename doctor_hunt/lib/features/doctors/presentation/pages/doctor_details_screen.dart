import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/admin_service.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/favorite_service.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/widgets/app_background.dart';
import '../../../../core/widgets/custom_back_button.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../i18n/strings.g.dart';
import '../../../../core/models/doctor.dart';
import '../widgets/doctor_info_card.dart';
import '../widgets/clinic_info_card.dart';
import '../widgets/doctor_reviews_section.dart';
import '../../../../core/utils/snack_bar_helper.dart';
import '../../../../core/constants/my_icons.dart';

class DoctorDetailsScreen extends StatefulWidget {
  const DoctorDetailsScreen({super.key, required this.doctor});

  final Doctor doctor;

  @override
  State<DoctorDetailsScreen> createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
  late Doctor _doctor;
  bool _isFavorite = false;
  String _clinicLocation = '';

  String? get _patientUid => sl<AuthService>().currentUser?.uid;

  @override
  void initState() {
    super.initState();
    _doctor = widget.doctor;
    _isFavorite = _doctor.isFavorite;

    sl<AdminService>().getCentralClinicLocation().then((location) {
      if (mounted) setState(() => _clinicLocation = location);
    });
  }

  Future<void> _toggleFavorite() async {
    final patientUid = _patientUid;
    final doctorUid = _doctor.uid;
    if (patientUid == null || doctorUid == null) return;

    final wasFavorited = _isFavorite;
    setState(() {
      _isFavorite = !_isFavorite;
    });

    try {
      await sl<FavoriteService>().toggleFavorite(
        patientUid: patientUid,
        doctorUid: doctorUid,
      );

      // Show undo snackbar when REMOVING a favorite
      if (wasFavorited && mounted) {
        SnackBarHelper.show(
          context,
          t.doctorDetails.removedFromFavorites(doctorName: _doctor.name ?? ''),
          action: SnackBarAction(
            label: t.common.undo,
            textColor: AppColors.primary,
            onPressed: () async {
              // Re-add to favorites
              await sl<FavoriteService>().addFavorite(
                patientUid: patientUid,
                doctorUid: doctorUid,
              );
              if (mounted) {
                setState(() {
                  _isFavorite = true;
                });
              }
            },
          ),
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      // Revert on error
      if (mounted) {
        setState(() {
          _isFavorite = wasFavorited;
        });
      }
    }
  }

  String get _imagePath =>
      (_doctor.imageUrl != null && _doctor.imageUrl!.isNotEmpty)
      ? _doctor.imageUrl!
      : AppImages.doctor;

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: AppColors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              16.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    CustomBackButton(
                      onTap: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go(AppRoutes.home);
                        }
                      },
                    ),
                    12.horizontalSpace,
                    Text(
                      t.doctorDetails.title,
                      style: context.bold20.textPrimary,
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => context.go(AppRoutes.search),
                      child: Icon(
                        MyIcons.searchRounded,
                        size: 24.r,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              20.verticalSpace,

              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DoctorInfoCard(
                        name: _doctor.name ?? '',
                        specialty: _doctor.specialization ?? '',
                        rating: _doctor.rating ?? 0,
                        reviewsCount: _doctor.reviewsCount,
                        consultationFee: _doctor.consultationFee,
                        imagePath: _imagePath,
                        isFavorite: _isFavorite,
                        onFavoriteToggle: _toggleFavorite,
                        onBookNow: () {
                          context.push(AppRoutes.selectTime, extra: _doctor);
                        },
                      ),
                      20.verticalSpace,

                      ClinicInfoCard(
                        location: _clinicLocation,
                        workingDays: _doctor.workingDays,
                        startTime: _doctor.startTime,
                        endTime: _doctor.endTime,
                      ),
                      24.verticalSpace,

                      if (_doctor.uid != null)
                        DoctorReviewsSection(
                          doctorId: _doctor.uid!,
                          rating: _doctor.rating ?? 0,
                          reviewsCount: _doctor.reviewsCount,
                        ),
                      32.verticalSpace,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
