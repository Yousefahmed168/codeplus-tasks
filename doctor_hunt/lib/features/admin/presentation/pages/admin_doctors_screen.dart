import 'package:doctor_hunt/core/widgets/widgets.dart';
import 'package:doctor_hunt/features/auth/data/models/specializations.dart';

import '../../../../core/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/admin_service.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../i18n/strings.g.dart';
import '../../../../features/doctors/models/doctor.dart';
import '../widgets/admin_doctor_card.dart';

class AdminDoctorsScreen extends StatefulWidget {
  const AdminDoctorsScreen({super.key});

  @override
  State<AdminDoctorsScreen> createState() => _AdminDoctorsScreenState();
}

class _AdminDoctorsScreenState extends State<AdminDoctorsScreen> {
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';
  String? _selectedCategory;
  late final Stream<List<Doctor>> _doctorsStream;

  @override
  void initState() {
    super.initState();
    _doctorsStream = AdminService.instance.streamDoctors();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _showFilterBottomSheet() {
    final categories = ['All', ...specializations];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter by Specialization',
                    style: context.bold18.textPrimary,
                  ),
                  if (_selectedCategory != null && _selectedCategory != 'All')
                    TextButton(
                      onPressed: () {
                        setState(() => _selectedCategory = null);
                        Navigator.pop(ctx);
                      },
                      child: const Text(
                        'Reset',
                        style: TextStyle(color: AppColors.error),
                      ),
                    ),
                ],
              ),
              const Gap(12),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    final isSelected =
                        (_selectedCategory == cat) ||
                        (_selectedCategory == null && cat == 'All');
                    return ListTile(
                      title: Text(
                        cat,
                        style: isSelected
                            ? context.bold16.primary
                            : context.regular14.textPrimary,
                      ),
                      trailing: isSelected
                          ? const Icon(
                              Icons.check_circle_rounded,
                              color: AppColors.primary,
                            )
                          : null,
                      onTap: () {
                        setState(
                          () => _selectedCategory = cat == 'All' ? null : cat,
                        );
                        Navigator.pop(ctx);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteDialog(Doctor doctor) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.admin.doctors.deleteTitle),
        content: Text(
          t.admin.doctors.deleteConfirm.replaceAll('@name', doctor.name ?? ''),
        ),
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
                      content: Text(
                        t.admin.doctors.deleted.replaceAll(
                          '@name',
                          doctor.name ?? '',
                        ),
                      ),
                      backgroundColor: AppColors.error,
                    ),
                  );
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
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded, color: Colors.white),
          onPressed: () {},
        ),
        title: Text(
          t.admin.doctors.title,
          style: context.bold18.copyWith(color: AppColors.background),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.background,
            ),
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
    return StreamBuilder<List<Doctor>>(
      stream: _doctorsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            !snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        final allDoctors = snapshot.data ?? [];
        final filteredDoctors = allDoctors.where((d) {
          final matchesSearch =
              _searchQuery.isEmpty ||
              (d.name ?? '').toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              (d.specialization ?? '').toLowerCase().contains(
                _searchQuery.toLowerCase(),
              );

          final matchesCategory =
              _selectedCategory == null ||
              _selectedCategory == 'All' ||
              (d.specialization ?? '').toLowerCase().contains(
                _selectedCategory!.toLowerCase(),
              );

          return matchesSearch && matchesCategory;
        }).toList();

        final totalDoctors = allDoctors.length;
        final activeDoctors = allDoctors.length;

        final categoryPills = [
          'All',
          'Dentist',
          'Cardiologist',
          'Pediatrician',
          'Neurologist',
          'General Practitioner',
          'Orthopedist',
        ];

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Search bar & Filter button
            Row(
              children: [
                Expanded(
                  child: CustomTextFormField(
                    hintText: 'Search by name ',
                    prefixIcon: const Icon(Icons.search),
                    controller: _searchCtrl,
                    onChange: (v) => setState(() => _searchQuery = v),
                  ),
                ),
                const Gap(12),
                GestureDetector(
                  onTap: _showFilterBottomSheet,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color:
                          _selectedCategory != null &&
                              _selectedCategory != 'All'
                          ? AppColors.primary
                          : AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.filter_list_rounded,
                      color:
                          _selectedCategory != null &&
                              _selectedCategory != 'All'
                          ? Colors.white
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const Gap(14),

            // Horizontal Category Pills
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categoryPills.length,
                separatorBuilder: (_, _) => const Gap(8),
                itemBuilder: (context, index) {
                  final cat = categoryPills[index];
                  final isSelected =
                      (_selectedCategory == cat) ||
                      (_selectedCategory == null && cat == 'All');
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = cat == 'All' ? null : cat;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.border,
                        ),
                        boxShadow: [
                          if (isSelected)
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          cat,
                          style: context.semiBold12.copyWith(
                            color: isSelected
                                ? Colors.white
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Gap(16),

            // Stats row
            Row(
              children: [
                _buildStatCard(
                  icon: Icons.people_outline,
                  label: t.admin.doctors.totalDoctors,
                  count: totalDoctors,
                ),
                const Gap(16),
                _buildStatCard(
                  icon: Icons.check_circle_outline,
                  label: t.admin.doctors.active,
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
                        t.admin.doctors.noDoctorsFound,
                        style: context.semiBold16.textSecondary,
                      ),
                    ],
                  ),
                ),
              )
            else
              ...filteredDoctors.map(
                (doctor) => GestureDetector(
                  onTap: () =>
                      context.push(AppRoutes.adminDoctorDetails, extra: doctor),
                  child: AdminDoctorCard(
                    doctor: doctor,
                    onDelete: () => _showDeleteDialog(doctor),
                    onEdit: () => context.push(
                      AppRoutes.adminDoctorDetails,
                      extra: doctor,
                    ),
                  ),
                ),
              ),
            const Gap(80),
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
