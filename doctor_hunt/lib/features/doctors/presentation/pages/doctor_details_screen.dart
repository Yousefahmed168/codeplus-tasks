import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../models/doctor_model.dart';
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

  @override
  void initState() {
    super.initState();
    _doctor = widget.doctor;
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
                        isFavorite: _doctor.isFavorite,
                        onFavoriteToggle: () {
                          setState(() {
                            _doctor = _doctor.copyWith(
                              isFavorite: !_doctor.isFavorite,
                            );
                          });
                        },
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
