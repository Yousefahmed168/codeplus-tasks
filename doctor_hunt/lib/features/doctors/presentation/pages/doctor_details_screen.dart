import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/services/favorite_service.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/user_service.dart';
import '../../models/doctor.dart';
import '../widgets/doctor_info_card.dart';
import '../widgets/map_preview.dart';
import '../widgets/services_section.dart';
import '../widgets/stats_row.dart';
import '../../../../i18n/strings.g.dart';
import '../../../../core/widgets/app_background.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class DoctorDetailsScreen extends StatefulWidget {
  const DoctorDetailsScreen({super.key, required this.doctor});

  final Doctor doctor;

  @override
  State<DoctorDetailsScreen> createState() => _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
  late Doctor _doctor;
  bool _isFavorite = false;

  String? get _patientUid => AuthService.instance.currentUser?.uid;

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
      final allDoctors = await UserService.instance
          .streamDoctors()
          .first;

      final matched = allDoctors.where((d) =>
          d.name == _doctor.name && d.imageUrl == _doctor.imagePath);

      if (matched.isNotEmpty) {
        final doctorUid = matched.first.uid;
        if (doctorUid != null) {
          await FavoriteService.instance.toggleFavorite(
            patientUid: _patientUid!,
            doctorUid: doctorUid,
          );
        }
      }

      // Show undo snackbar when REMOVING a favorite
      if (wasFavorited && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_doctor.name} removed from favorites'),
            action: SnackBarAction(
              label: t.common.undo,
              textColor: AppColors.primary,
              onPressed: () async {
                // Re-add to favorites
                if (matched.isNotEmpty) {
                  final doctorUid = matched.first.uid;
                  if (doctorUid != null) {
                    await FavoriteService.instance.addFavorite(
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
              borderRadius: BorderRadius.circular(12),
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
                      t.doctorDetails.title,
                      style: context.bold20.textPrimary,
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => context.go(AppRoutes.search),
                      child: const Icon(
                        Icons.search_rounded,
                        size: 24,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Gap(20),

              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Doctor info card
                      DoctorInfoCard(
                        name: _doctor.name,
                        specialty: _doctor.specialty,
                        rating: _doctor.ratingPercentage.round() > 5
                            ? 5
                            : _doctor.ratingPercentage.round(),
                        hourlyRate: _doctor.hourlyRate,
                        imagePath: _doctor.imagePath,
                        isFavorite: _isFavorite,
                        onFavoriteToggle: _toggleFavorite,
                        onBookNow: () {
                          context.push(AppRoutes.selectTime, extra: _doctor);
                        },
                      ),
                      Gap(20),

                      // Stats row
                      StatsRow(running: 100, ongoing: 500, patients: 700),
                      Gap(24),

                      // Services section
                      ServicesSection(
                        services: [
                          t.doctorDetails.service1,
                          t.doctorDetails.service2,
                          t.doctorDetails.service3,
                        ],
                      ),
                      Gap(20),

                      // Map preview
                      const MapPreview(),
                      Gap(32),
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
