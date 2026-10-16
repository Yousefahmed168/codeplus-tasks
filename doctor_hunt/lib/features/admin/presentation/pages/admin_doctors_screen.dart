import '../../../../core/widgets/widgets.dart';

import '../../../../core/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/admin_service.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../i18n/strings.g.dart';
import '../../../../core/models/doctor.dart';
import '../widgets/admin_doctor_card.dart';
import '../../../../core/utils/snack_bar_helper.dart';
import '../../../../core/widgets/doctor_shimmer.dart';
import '../../../../core/constants/my_icons.dart';

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
    _doctorsStream = sl<AdminService>().streamDoctors();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _showDeleteDialog(Doctor doctor) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Text(t.admin.doctors.deleteTitle),
        content: Text(
          t.admin.doctors.deleteConfirm.replaceAll('@name', doctor.name ?? ''),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(t.common.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              if (doctor.uid != null) {
                await sl<AdminService>().deleteDoctor(doctor.uid!);
                if (mounted) {
                  SnackBarHelper.showError(
                    context,
                    t.admin.doctors.deleted.replaceAll(
                      '@name',
                      doctor.name ?? '',
                    ),
                  );
                }
              }
            },
            child: Text(
              t.common.delete,
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
        title: Text(
          t.admin.doctors.title,
          style: context.bold18.copyWith(color: AppColors.textOnPrimary),
        ),
        centerTitle: true,
      ),
      body: _buildDoctorsList(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.createDoctor),
        backgroundColor: AppColors.primary,
        icon: Icon(MyIcons.add, color: AppColors.textOnPrimary, size: 20.r),
        label: Text(
          t.admin.doctors.addDoctor,
          style: context.semiBold14.copyWith(color: AppColors.textOnPrimary),
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
          return ListView(
            padding: EdgeInsets.all(16.r),
            children: [
              const DoctorListRowShimmer(),
              12.verticalSpace,
              const DoctorListRowShimmer(),
              12.verticalSpace,
              const DoctorListRowShimmer(),
            ],
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
        final activeDoctors = allDoctors
            .where((doctor) => doctor.isActive)
            .length;

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
          padding: EdgeInsets.all(16.r),
          children: [
            // Search bar
            CustomTextFormField(
              maxLines: 1,
              hintText: t.admin.doctors.searchHint,
              prefixIcon: Icon(MyIcons.search, size: 20.r),
              controller: _searchCtrl,
              onChange: (v) => setState(() => _searchQuery = v),
            ),
            14.verticalSpace,

            // Horizontal Category Pills
            SizedBox(
              height: 38.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categoryPills.length,
                separatorBuilder: (_, _) => 8.horizontalSpace,
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : AppColors.surface,
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.border,
                        ),
                        boxShadow: [
                          if (isSelected)
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 6.r,
                              offset: Offset(0, 2.h),
                            ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          cat,
                          style: context.semiBold12.copyWith(
                            color: isSelected
                                ? AppColors.textOnPrimary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            16.verticalSpace,

            // Stats row
            Row(
              children: [
                _buildStatCard(
                  icon: MyIcons.peopleOutline,
                  label: t.admin.doctors.totalDoctors,
                  count: totalDoctors,
                ),
                16.horizontalSpace,
                _buildStatCard(
                  icon: MyIcons.checkCircleOutline,
                  label: t.admin.doctors.active,
                  count: activeDoctors,
                  isGreen: true,
                ),
              ],
            ),
            20.verticalSpace,

            // Doctor list
            if (filteredDoctors.isEmpty)
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 60.h),
                  child: Column(
                    children: [
                      SvgPicture.asset(AppImages.logo, width: 80.r, height: 80.r),
                      16.verticalSpace,
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
            80.verticalSpace,
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
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withValues(alpha: 0.05),
              blurRadius: 10.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 28.r),
            12.horizontalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: context.regular12.textSecondary),
                2.verticalSpace,
                Text('$count', style: context.bold20.textPrimary),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
