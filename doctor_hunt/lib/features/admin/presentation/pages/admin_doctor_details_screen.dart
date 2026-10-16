import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widgets/custom_back_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/admin_service.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/models/doctor.dart';
import '../../../../i18n/strings.g.dart';
import '../../../../core/utils/snack_bar_helper.dart';
import '../../../../core/widgets/main_button.dart';
import '../../../../core/constants/my_icons.dart';

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

  Future<void> _toggleStatus() async {
    final uid = _doctor.uid;
    if (uid == null) return;
    final willActivate = !_doctor.isActive;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Text(t.admin.doctors.statusConfirmTitle),
        content: Text(
          (willActivate
                  ? t.admin.doctors.activateConfirm
                  : t.admin.doctors.deactivateConfirm)
              .replaceAll('@name', _doctor.name ?? ''),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(t.common.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              willActivate
                  ? t.admin.doctors.activate
                  : t.admin.doctors.deactivate,
              style: context.semiBold14.copyWith(
                color: willActivate ? AppColors.success : AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;
    try {
      await sl<AdminService>().toggleDoctorStatus(uid, willActivate);
      if (mounted) {
        setState(() => _doctor = _doctor.copyWith(isActive: willActivate));
        SnackBarHelper.show(
          context,
          (willActivate
                  ? t.admin.doctors.activated
                  : t.admin.doctors.deactivated)
              .replaceAll('@name', _doctor.name ?? ''),
        );
      }
    } catch (_) {
      if (mounted) SnackBarHelper.showError(context, t.common.errorGeneric);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leadingWidth: 70.w,
        leading: Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: const CustomBackButton(),
        ),
        title: Text(
          t.admin.doctorDetails.title,
          style: context.bold18.copyWith(color: AppColors.textOnPrimary),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.r),
        child: Column(
          children: [
            // Doctor photo
            Center(
              child: Container(
                width: 100.r,
                height: 100.r,
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
                    ? Icon(
                        MyIcons.person,
                        color: AppColors.primary,
                        size: 48.r,
                      )
                    : null,
              ),
            ),
            16.verticalSpace,

            // Doctor Name
            Text(
              _doctor.name ?? '',
              style: context.bold20.textPrimary,
            ),
            8.verticalSpace,

            // Active status pill
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: _doctor.isActive
                    ? AppColors.success.withValues(alpha: 0.1)
                    : AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6.r,
                    height: 6.r,
                    decoration: BoxDecoration(
                      color: _doctor.isActive
                          ? AppColors.success
                          : AppColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                  6.horizontalSpace,
                  Text(
                    _doctor.isActive ? t.admin.doctors.active : t.admin.doctorDetails.inactive,
                    style: context.semiBold12.copyWith(
                      color: _doctor.isActive
                          ? AppColors.success
                          : AppColors.error,
                    ),
                  ),
                ],
              ),
            ),
            24.verticalSpace,

            // Info section
            _buildInfoSection(),
            32.verticalSpace,

            // Edit Doctor button
            MainButton(
              text: t.admin.doctorDetails.editDoctor,
              onPressed: () async {
                await context.push(AppRoutes.editDoctor, extra: _doctor);
                if (mounted) setState(() {});
              },
              bgColor: AppColors.primary,
            ),
            16.verticalSpace,

            // Manage Availability button
            MainButton(
              text: t.admin.availability.title,
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
            16.verticalSpace,

            // Status Switch (Activate / Deactivate)
            MainButton(
              text: _doctor.isActive
                  ? t.admin.doctors.deactivate
                  : t.admin.doctors.activate,
              onPressed: _toggleStatus,
              bgColor: _doctor.isActive ? AppColors.error : AppColors.success,
              textColor: AppColors.textOnPrimary,
            ),
            32.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.05),
            blurRadius: 10.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(
            icon: MyIcons.medicalServicesOutlined,
            label: t.admin.doctorDetails.specialty,
            value: _doctor.specialization ?? '',
          ),
          Divider(height: 32.h, color: AppColors.border),
          _buildInfoRow(
            icon: MyIcons.starBorder,
            label: t.doctorDetails.reviews,
            value: '${_doctor.rating ?? 0.0}',
          ),
          Divider(height: 32.h, color: AppColors.border),
          _buildInfoRow(
            icon: MyIcons.rateReviewRounded,
            label: t.admin.doctorDetails.reviewCount,
            value: '${_doctor.reviewsCount}',
          ),
          Divider(height: 32.h, color: AppColors.border),
          _buildInfoRow(
            icon: MyIcons.attachMoney,
            label: t.admin.createDoctor.feeLabel,
            value: t.common.amount(
              amount: _doctor.consultationFee.toStringAsFixed(2),
            ),
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
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primary, size: 20.r),
        ),
        16.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: context.regular12.textSecondary),
              4.verticalSpace,
              Text(value, style: context.semiBold14.textPrimary),
            ],
          ),
        ),
      ],
    );
  }
}
