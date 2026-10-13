import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/favorite_service.dart';
import '../../../../core/services/user_service.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/widgets/app_background.dart';
import '../../../../core/widgets/custom_back_button.dart';
import '../../../../i18n/strings.g.dart';
import '../../models/doctor.dart';
import '../widgets/doctor_info_card.dart';
import '../widgets/services_section.dart';

class DoctorDetailsScreen extends StatefulWidget {
  const DoctorDetailsScreen({super.key, required this.doctor});

  final Doctor doctor;

  @override
  State<DoctorDetailsScreen> createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
  late Doctor _doctor;
  bool _isFavorite = false;

  String? get _patientUid => sl<AuthService>().currentUser?.uid;

  @override
  void initState() {
    super.initState();
    _doctor = widget.doctor;
    _isFavorite = _doctor.isFavorite;
  }

  Future<void> _toggleFavorite() async {
    if (_patientUid == null) return;

    final wasFavorited = _isFavorite;
    setState(() {
      _isFavorite = !_isFavorite;
    });

    try {
      // We need the doctor UID from Firestore. Since Doctor model doesn't have uid,
      // we look it up by streaming all doctors and matching by name + image.
      final allDoctors = await sl<UserService>().streamDoctors().first;

      final matched = allDoctors.where(
        (d) => d.name == _doctor.name && d.imageUrl == _doctor.imageUrl,
      );

      if (matched.isNotEmpty) {
        final doctorUid = matched.first.uid;
        if (doctorUid != null) {
          await sl<FavoriteService>().toggleFavorite(
            patientUid: _patientUid!,
            doctorUid: doctorUid,
          );
        }
      }

      // Show undo snackbar when REMOVING a favorite
      if (wasFavorited && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              t.doctorDetails.removedFromFavorites(
                doctorName: _doctor.name ?? 'Doctor',
              ),
            ),
            action: SnackBarAction(
              label: t.common.undo,
              textColor: AppColors.primary,
              onPressed: () async {
                // Re-add to favorites
                if (matched.isNotEmpty) {
                  final doctorUid = matched.first.uid;
                  if (doctorUid != null) {
                    await sl<FavoriteService>().addFavorite(
                      patientUid: _patientUid!,
                      doctorUid: doctorUid,
                    );
                    if (mounted) {
                      setState(() {
                        _isFavorite = true;
                      });
                    }
                  }
                }
              },
            ),
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        );
      }
    } catch (e) {
      // Revert on error
      if (mounted) {
        setState(() {
          _isFavorite = !_isFavorite;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              // Header
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
                        Icons.search_rounded,
                        size: 24.r,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              20.verticalSpace,

              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Doctor info card
                      DoctorInfoCard(
                        name: _doctor.name ?? 'Unknown',
                        specialty: _doctor.specialization ?? 'General',
                        rating: _doctor.ratingPercentage.round() > 5
                            ? 5
                            : _doctor.ratingPercentage.round(),
                        hourlyRate: _doctor.consultationFee,
                        imagePath:
                            _doctor.imageUrl ?? 'assets/images/doctor.png',
                        isFavorite: _isFavorite,
                        onFavoriteToggle: _toggleFavorite,
                        onBookNow: () {
                          context.push(AppRoutes.selectTime, extra: _doctor);
                        },
                      ),
                      20.verticalSpace,

                      // Services section
                      ServicesSection(
                        services: [
                          t.doctorDetails.service1,
                          t.doctorDetails.service2,
                          t.doctorDetails.service3,
                        ],
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
