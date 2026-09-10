import 'package:doctor_hunt/features/auth/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/user_service.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/widgets/app_background.dart';
import '../../../../features/doctors/models/doctor.dart';
import '../../../../i18n/strings.g.dart';

class DoctorDashboardScreen extends StatefulWidget {
  const DoctorDashboardScreen({super.key});
  @override
  State<DoctorDashboardScreen> createState() => _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends State<DoctorDashboardScreen> {
  Doctor? _doctor;
  bool _isLoading = true;
  bool _isAvailable = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = AuthService.instance.currentUser;
    if (user == null) return;
    final profile = await UserService.instance.getUser(user.uid);
    if (mounted) {
      setState(() {
        _doctor = profile as Doctor?;
        _isAvailable =
            true; 
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleAvailability() async {
    final user = AuthService.instance.currentUser;
    if (user == null) return;
    final newStatus = !_isAvailable;
    await UserService.instance.updateUser(user.uid, {
      'isAvailable': newStatus,
    }, role: UserRole.doctor);
    if (mounted) setState(() => _isAvailable = newStatus);
  }

  Future<void> _logout() async {
    await AuthService.instance.logout();
    if (mounted) context.go(AppRoutes.role);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return AppBackground(
        child: const Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        ),
      );
    }

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              const Gap(20),
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(t.dashboard.title, style: context.bold24.textPrimary),
                  GestureDetector(
                    onTap: _logout,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.logout_rounded,
                        color: AppColors.error,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(24),
              // Profile card
              _buildProfileCard(),
              const Gap(20),
              // Availability toggle
              _buildAvailabilityToggle(),
              const Gap(20),
              // Stats grid
              _buildStatsGrid(),
              const Gap(20),
              // Doctor Details
              if (_doctor != null) ...[
                _buildDoctorDetails(),
                const Gap(20),
              ],
              // Menu items
              _buildMenuItem(
                icon: Icons.person_outline,
                title: t.dashboard.profile,
                onTap: () {},
              ),
              _buildMenuItem(
                icon: Icons.calendar_today_outlined,
                title: t.dashboard.appointments,
                onTap: () {},
              ),
              _buildMenuItem(
                icon: Icons.people_outline,
                title: t.dashboard.myPatients,
                onTap: () {},
              ),
              _buildMenuItem(
                icon: Icons.settings_outlined,
                title: t.dashboard.settings,
                onTap: () {},
              ),
              const Gap(32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.1),
              image: _doctor?.imageUrl != null && _doctor!.imageUrl!.isNotEmpty
                  ? DecorationImage(
                      image: CachedNetworkImageProvider(_doctor!.imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: (_doctor?.imageUrl == null || _doctor!.imageUrl!.isEmpty)
                ? Icon(Icons.person, color: AppColors.primary, size: 32)
                : null,
          ),
          const Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _doctor?.name ?? 'Doctor',
                  style: context.bold16.textPrimary,
                ),
                const Gap(4),
                Text(
                  _doctor?.specialization ?? '',
                  style: context.regular14.primary,
                ),
                const Gap(4),
                Text(
                  _doctor?.email ?? '',
                  style: context.regular12.textSecondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailabilityToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                _isAvailable ? Icons.check_circle : Icons.cancel,
                color: _isAvailable ? AppColors.success : AppColors.error,
                size: 20,
              ),
              const Gap(8),
              Text(
                _isAvailable ? t.dashboard.available : t.dashboard.unavailable,
                style: context.semiBold14.textPrimary,
              ),
            ],
          ),
          Switch(
            value: _isAvailable,
            onChanged: (_) => _toggleAvailability(),
            activeThumbColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: t.dashboard.totalPatients,
            icon: Icons.people_outline,
          ),
        ),
        const Gap(12),
      ],
    );
  }

  Widget _buildStatCard({required String title, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const Gap(4),
          Text(
            title,
            style: context.regular12.textSecondary,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 22),
              const Gap(12),
              Expanded(
                child: Text(title, style: context.semiBold14.textPrimary),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textHint,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.dashboard.doctorInfo, style: context.bold16.textPrimary),
          const Gap(16),
          if (_doctor?.bio != null && _doctor!.bio!.isNotEmpty) ...[
            _buildInfoRow(Icons.info_outline, _doctor!.bio!),
            const Gap(12),
          ],
          if (_doctor?.phone1 != null && _doctor!.phone1!.isNotEmpty) ...[
            _buildInfoRow(Icons.phone_outlined, _doctor!.phone1!),
            const Gap(12),
          ],
          if (_doctor?.phone2 != null && _doctor!.phone2!.isNotEmpty) ...[
            _buildInfoRow(Icons.phone_outlined, _doctor!.phone2!),
            const Gap(12),
          ],
          if (_doctor?.address != null && _doctor!.address!.isNotEmpty) ...[
            _buildInfoRow(Icons.location_on_outlined, _doctor!.address!),
            const Gap(12),
          ],
          if (_doctor?.openHour != null && _doctor!.openHour!.isNotEmpty &&
              _doctor?.closeHour != null && _doctor!.closeHour!.isNotEmpty) ...[
            _buildInfoRow(
              Icons.access_time_outlined,
              '${_doctor!.openHour} - ${_doctor!.closeHour}',
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const Gap(12),
        Expanded(
          child: Text(
            text,
            style: context.regular14.textSecondary,
          ),
        ),
      ],
    );
  }
}
