import 'package:doctor_hunt/core/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/admin_service.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../features/doctors/models/doctor_model.dart';
import '../widgets/admin_doctor_card.dart';

class AdminDoctorsScreen extends StatefulWidget {
  const AdminDoctorsScreen({super.key});

  @override
  State<AdminDoctorsScreen> createState() => _AdminDoctorsScreenState();
}

class _AdminDoctorsScreenState extends State<AdminDoctorsScreen> {
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _showDeleteDialog(DoctorModel doctor) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Doctor'),
        content: Text('Are you sure you want to remove Dr. ${doctor.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              if (doctor.uid != null) {
                await AdminService.instance.deleteDoctor(doctor.uid!);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Dr. ${doctor.name} deleted'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              }
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
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
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded, color: Colors.white),
          onPressed: () {},
        ),
        title: Text(
          'Doctors',
          style: context.bold18.copyWith(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: _buildDoctorsList(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.createDoctor),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'Add Doctor',
          style: context.semiBold14.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildDoctorsList() {
    return StreamBuilder<List<DoctorModel>>(
      stream: AdminService.instance.streamDoctors(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        final allDoctors = snapshot.data ?? [];
        final filteredDoctors = _searchQuery.isEmpty
            ? allDoctors
            : allDoctors
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

        final totalDoctors = allDoctors.length;
        final activeDoctors = allDoctors.length; // All are active by default

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Search bar
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchCtrl,
                    decoration: InputDecoration(
                      hintText: 'Search doctors...',
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.textHint,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.border),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onChanged: (v) => setState(() => _searchQuery = v),
                  ),
                ),
                const Gap(12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.filter_list_rounded,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const Gap(16),

            // Stats row
            Row(
              children: [
                _buildStatCard(
                  icon: Icons.people_outline,
                  label: 'Total Doctors',
                  count: totalDoctors,
                ),
                const Gap(16),
                _buildStatCard(
                  icon: Icons.check_circle_outline,
                  label: 'Active',
                  count: activeDoctors,
                  isGreen: true,
                ),
              ],
            ),
            const Gap(20),

            // Doctor list
            if (filteredDoctors.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: Column(
                    children: [
                      SvgPicture.asset(AppImages.logo, width: 80, height: 80),
                      const Gap(16),
                      Text(
                        'No doctors found',
                        style: context.semiBold16.textSecondary,
                      ),
                    ],
                  ),
                ),
              )
            else
              ...filteredDoctors.map(
                (doctor) => AdminDoctorCard(
                  doctor: doctor,
                  onDelete: () => _showDeleteDialog(doctor),
                  onEdit: () =>
                      context.push(AppRoutes.editDoctor, extra: doctor),
                ),
              ),
            const Gap(80), // Space for FAB
          ],
        );
      },
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required int count,
    bool isGreen = false,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
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
            Icon(icon, color: AppColors.primary, size: 28),
            const Gap(12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: context.regular12.textSecondary),
                const Gap(2),
                Text('$count', style: context.bold20.textPrimary),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
