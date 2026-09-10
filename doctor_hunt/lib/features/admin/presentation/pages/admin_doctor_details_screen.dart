import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/admin_service.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../features/doctors/models/doctor.dart';
import '../../../../i18n/strings.g.dart';

class AdminDoctorDetailsScreen extends StatefulWidget {
  final Doctor doctor;

  const AdminDoctorDetailsScreen({super.key, required this.doctor});

  @override
  State<AdminDoctorDetailsScreen> createState() =>
      _AdminDoctorDetailsScreenState();
}

class _AdminDoctorDetailsScreenState extends State<AdminDoctorDetailsScreen> {
  late Doctor _doctor;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _doctor = widget.doctor;
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.admin.doctors.deleteTitle),
        content: Text(
          t.admin.doctors.deleteConfirm.replaceAll('@name', _doctor.name ?? ''),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              if (_doctor.uid != null) {
                await AdminService.instance.deleteDoctor(_doctor.uid!);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        t.admin.doctors.deleted.replaceAll(
                          '@name',
                          _doctor.name ?? '',
                        ),
                      ),
                      backgroundColor: AppColors.error,
                    ),
                  );
                  context.pop();
                }
              }
            },
            child: Text(
              'Delete',
              style: context.semiBold14.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimary,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          t.admin.doctorDetails.title,
          style: context.bold18.textPrimary,
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                context.push(AppRoutes.editDoctor, extra: _doctor);
              }
              if (value == 'delete') _showDeleteDialog();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'edit', child: Text('Edit')),
              PopupMenuItem(
                value: 'delete',
                child: Text(
                  'Delete',
                  style: context.regular12.copyWith(color: AppColors.error),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Doctor photo with camera overlay
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withValues(alpha: 0.1),
                      image:
                          _doctor.imageUrl != null &&
                              _doctor.imageUrl!.isNotEmpty
                          ? DecorationImage(
                              image: CachedNetworkImageProvider(
                                _doctor.imageUrl!,
                              ),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _doctor.imageUrl == null || _doctor.imageUrl!.isEmpty
                        ? Icon(Icons.person, color: AppColors.primary, size: 48)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(16),

            // Doctor name
            Text(
              'Dr. ${_doctor.name ?? 'Unknown'}',
              style: context.bold20.textPrimary,
              textAlign: TextAlign.center,
            ),
            const Gap(4),

            // Specialization + experience
            Text(
              _doctor.specialization ?? 'General',
              style: context.regular14.textSecondary,
              textAlign: TextAlign.center,
            ),
            const Gap(8),

            // Active status badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: _isActive
                    ? AppColors.success.withValues(alpha: 0.1)
                    : AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isActive ? AppColors.success : AppColors.error,
                    ),
                  ),
                  const Gap(6),
                  Text(
                    _isActive
                        ? t.admin.doctorDetails.active
                        : t.admin.doctorDetails.inactive,
                    style: context.semiBold12.copyWith(
                      color: _isActive ? AppColors.success : AppColors.error,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(24),

            // Doctor Info section
            _buildInfoSection(),
            const Gap(20),

            // Account Status
            _buildAccountStatus(),
            const Gap(32),

            // Edit Doctor button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await context.push(
                    AppRoutes.editDoctor,
                    extra: _doctor,
                  );
                  // Refresh doctor data when coming back
                  if (mounted) setState(() {});
                },
                icon: const Icon(Icons.edit, color: Colors.white),
                label: Text(
                  t.admin.doctorDetails.editDoctor,
                  style: context.semiBold16.copyWith(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
            const Gap(12),

            // Delete Doctor button
            TextButton(
              onPressed: _showDeleteDialog,
              child: Text(
                t.admin.doctorDetails.deleteDoctor,
                style: context.semiBold14.copyWith(color: AppColors.error),
              ),
            ),
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
          Text(
            t.admin.doctorDetails.doctorInfo,
            style: context.semiBold16.textPrimary,
          ),
          const Gap(16),
          // Specialty chip
          _buildInfoRow(
            label: t.admin.doctorDetails.specialty,
            child: Wrap(
              spacing: 8,
              children: [
                _buildChip(_doctor.specialization ?? 'General'),
                if (_doctor.bio != null && _doctor.bio!.isNotEmpty)
                  _buildChip(_doctor.bio!),
              ],
            ),
          ),
          if (_doctor.email != null && _doctor.email!.isNotEmpty) ...[
            const Gap(12),
            _buildInfoRow(
              label: t.common.email,
              child: Text(
                _doctor.email!,
                style: context.regular14.textSecondary,
              ),
            ),
          ],
          if (_doctor.phone1 != null && _doctor.phone1!.isNotEmpty) ...[
            const Gap(12),
            _buildInfoRow(
              label: t.common.phone,
              child: Text(
                _doctor.phone1!,
                style: context.regular14.textSecondary,
              ),
            ),
          ],
          if (_doctor.address != null && _doctor.address!.isNotEmpty) ...[
            const Gap(12),
            _buildInfoRow(
              label: 'Address',
              child: Text(
                _doctor.address!,
                style: context.regular14.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow({required String label, required Widget child}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(label, style: context.semiBold12.textSecondary),
        ),
        Expanded(child: child),
      ],
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: context.semiBold12.copyWith(color: AppColors.primary),
      ),
    );
  }

  Widget _buildAccountStatus() {
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
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.person_outline,
              color: AppColors.primary,
              size: 22,
            ),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.admin.doctorDetails.accountStatus,
                  style: context.semiBold14.textPrimary,
                ),
                const Gap(2),
                Text(
                  _isActive
                      ? t.admin.doctorDetails.active
                      : t.admin.doctorDetails.inactive,
                  style: context.regular12.textSecondary,
                ),
              ],
            ),
          ),
          Switch(
            value: _isActive,
            onChanged: (value) {
              setState(() => _isActive = value);
              if (_doctor.uid != null) {
                AdminService.instance.updateDoctor(_doctor.uid!, {
                  'isActive': value,
                });
              }
            },
            activeThumbColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
