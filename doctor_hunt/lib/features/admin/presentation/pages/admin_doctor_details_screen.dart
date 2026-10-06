import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctor_hunt/core/widgets/custom_back_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../features/doctors/models/doctor.dart';
import '../../../../i18n/strings.g.dart';
import '../../../../core/widgets/main_button.dart';

class AdminDoctorDetailsScreen extends StatefulWidget {
  final Doctor doctor;

  const AdminDoctorDetailsScreen({super.key, required this.doctor});

  @override
  State<AdminDoctorDetailsScreen> createState() =>
      _AdminDoctorDetailsScreenState();
}

class _AdminDoctorDetailsScreenState extends State<AdminDoctorDetailsScreen> {
  late Doctor _doctor;

  @override
  void initState() {
    super.initState();
    _doctor = widget.doctor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leadingWidth: 70,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16),
          child: CustomBackButton(),
        ),
        title: Text(
          t.admin.doctorDetails.title,
          style: context.bold18.textPrimary,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Doctor photo
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.1),
                  image:
                      _doctor.imageUrl != null && _doctor.imageUrl!.isNotEmpty
                      ? DecorationImage(
                          image: CachedNetworkImageProvider(_doctor.imageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: _doctor.imageUrl == null || _doctor.imageUrl!.isEmpty
                    ? const Icon(
                        Icons.person,
                        color: AppColors.primary,
                        size: 48,
                      )
                    : null,
              ),
            ),
            const Gap(16),

            // Doctor Name
            Text(
              _doctor.name ?? 'Unknown Doctor',
              style: context.bold20.textPrimary,
            ),
            const Gap(8),

            // Active status pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: _doctor.isActive
                    ? AppColors.success.withValues(alpha: 0.1)
                    : AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: _doctor.isActive
                          ? AppColors.success
                          : AppColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const Gap(6),
                  Text(
                    _doctor.isActive ? 'Active' : 'Inactive',
                    style: context.semiBold12.copyWith(
                      color: _doctor.isActive
                          ? AppColors.success
                          : AppColors.error,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(24),

            // Info section
            _buildInfoSection(),
            const Gap(32),

            // Edit Doctor button
            MainButton(
              text:
                  'Edit Doctor', // MVP text or t.admin.doctorDetails.editDoctor
              onPressed: () async {
                await context.push(AppRoutes.editDoctor, extra: _doctor);
                if (mounted) setState(() {});
              },
              bgColor: AppColors.primary,
            ),
            const Gap(16),

            // Manage Availability button
            MainButton(
              text: 'Manage Availability',
              onPressed: () async {
                await context.push(
                  AppRoutes.adminDoctorAvailability,
                  extra: _doctor,
                );
                if (mounted) setState(() {});
              },
              bgColor: AppColors.background,
              textColor: AppColors.primary,
            ),
            const Gap(32),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(
            icon: Icons.medical_services_outlined,
            label: 'Specialty',
            value: _doctor.specialization ?? 'General',
          ),
          const Divider(height: 32, color: AppColors.border),
          _buildInfoRow(
            icon: Icons.star_border,
            label: 'Rating',
            value: '${_doctor.rating ?? 0.0} • 128 reviews', // Mock reviews
          ),
          const Divider(height: 32, color: AppColors.border),
          _buildInfoRow(
            icon: Icons.attach_money,
            label: 'Consultation Fee',
            value: '\$${_doctor.consultationFee.toStringAsFixed(2)}',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const Gap(16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: context.regular12.textSecondary),
              const Gap(4),
              Text(value, style: context.semiBold14.textPrimary),
            ],
          ),
        ),
      ],
    );
  }
}
