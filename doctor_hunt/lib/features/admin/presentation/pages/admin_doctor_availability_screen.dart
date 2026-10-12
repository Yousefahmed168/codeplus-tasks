import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/widgets/custom_back_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/services/admin_service.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../features/doctors/models/doctor.dart';
import '../../../../core/widgets/main_button.dart';
import '../../../../core/widgets/custom_dropdown.dart';

class AdminDoctorAvailabilityScreen extends StatefulWidget {
  final Doctor doctor;

  const AdminDoctorAvailabilityScreen({super.key, required this.doctor});

  @override
  State<AdminDoctorAvailabilityScreen> createState() =>
      _AdminDoctorAvailabilityScreenState();
}

class _AdminDoctorAvailabilityScreenState
    extends State<AdminDoctorAvailabilityScreen> {
  final List<String> _allDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  late List<String> _selectedDays;
  late String _startTime;
  late String _endTime;
  late int _slotDuration;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedDays = List.from(widget.doctor.workingDays);
    _startTime = widget.doctor.startTime;
    _endTime = widget.doctor.endTime;
    _slotDuration = widget.doctor.slotDuration;
  }

  void _toggleDay(String day, bool isSelected) {
    setState(() {
      if (isSelected) {
        if (!_selectedDays.contains(day)) _selectedDays.add(day);
      } else {
        _selectedDays.remove(day);
      }
    });
  }

  Future<void> _saveAvailability() async {
    if (widget.doctor.uid == null) return;
    setState(() => _isSaving = true);

    try {
      await sl<AdminService>().updateDoctor(widget.doctor.uid!, {
        'workingDays': _selectedDays,
        'startTime': _startTime,
        'endTime': _endTime,
        'slotDuration': _slotDuration,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Availability updated successfully'),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update availability: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
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
        title: Text('Doctor Availability', style: context.bold18.textPrimary),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor Header Card
            _buildDoctorHeader(),
            const Gap(24),

            // Working Days
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Working Days', style: context.bold16.textPrimary),
                Text(
                  '${_selectedDays.length} days enabled',
                  style: context.regular12.textHint,
                ),
              ],
            ),
            const Gap(16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: _allDays.map((day) => _buildDayTile(day)).toList(),
              ),
            ),
            const Gap(24),

            // Working Hours
            Text('Working Hours', style: context.bold16.textPrimary),
            const Gap(16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'START TIME',
                              style: context.semiBold11.textSecondary,
                            ),
                            const Gap(5),
                            CustomDropdown<String>(
                              value: _startTime,
                              isExpanded: true,
                              prefixIcon: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Icon(Icons.access_time, size: 16, color: AppColors.primary),
                              ),
                              items: const [
                                '08:00 AM',
                                '09:00 AM',
                                '10:00 AM',
                                '11:00 AM',
                              ],
                              onChanged: (v) => setState(() => _startTime = v!),
                            ),
                          ],
                        ),
                      ),
                      const Gap(16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'END TIME',
                              style: context.semiBold11.textSecondary,
                            ),
                            const Gap(5),
                            CustomDropdown<String>(
                              value: _endTime,
                              isExpanded: true,
                              prefixIcon: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Icon(Icons.access_time, size: 16, color: AppColors.primary),
                              ),
                              items: const [
                                '03:00 PM',
                                '04:00 PM',
                                '05:00 PM',
                                '06:00 PM',
                                '07:00 PM',
                              ],
                              onChanged: (v) => setState(() => _endTime = v!),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Gap(16),
                  Text(
                    'SLOT DURATION',
                    style: context.semiBold11.textSecondary,
                  ),
                  const Gap(5),
                  CustomDropdown<String>(
                    value: '$_slotDuration Minutes',
                    isExpanded: true,
                    prefixIcon: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(Icons.access_time, size: 16, color: AppColors.primary),
                    ),
                    items: const [
                      '15 Minutes',
                      '30 Minutes',
                      '45 Minutes',
                      '60 Minutes',
                    ],
                    onChanged: (v) {
                      setState(() {
                        _slotDuration = int.parse(v!.split(' ')[0]);
                      });
                    },
                  ),
                ],
              ),
            ),
            const Gap(32),

            MainButton(
              text: _isSaving ? 'Saving...' : 'Save Availability',
              onPressed: _isSaving ? null : _saveAvailability,
              bgColor: AppColors.primary,
            ),
            const Gap(32),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorHeader() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(12),
              color: AppColors.primary.withValues(alpha: 0.1),
              image:
                  widget.doctor.imageUrl != null &&
                      widget.doctor.imageUrl!.isNotEmpty
                  ? DecorationImage(
                      image: CachedNetworkImageProvider(
                        widget.doctor.imageUrl!,
                      ),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child:
                widget.doctor.imageUrl == null ||
                    widget.doctor.imageUrl!.isEmpty
                ? const Icon(Icons.person, color: AppColors.primary)
                : null,
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.doctor.name ?? 'Unknown',
                  style: context.bold14.textPrimary,
                ),
                Text(
                  '${widget.doctor.specialization ?? 'General'} • Central Clinic',
                  style: context.regular12.textSecondary,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: widget.doctor.isActive
                  ? AppColors.success.withValues(alpha: 0.1)
                  : AppColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: widget.doctor.isActive
                        ? AppColors.success
                        : AppColors.error,
                    shape: BoxShape.circle,
                  ),
                ),
                const Gap(4),
                Text(
                  widget.doctor.isActive ? 'Active' : 'Inactive',
                  style: context.semiBold12.copyWith(
                    color: widget.doctor.isActive
                        ? AppColors.success
                        : AppColors.error,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayTile(String day) {
    final isSelected = _selectedDays.contains(day);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.calendar_today_outlined,
              size: 16,
              color: AppColors.primary,
            ),
          ),
          const Gap(12),
          Expanded(
            child: Text(
              day,
              style: context.semiBold14.copyWith(
                color: isSelected ? AppColors.textPrimary : AppColors.textHint,
              ),
            ),
          ),
          Switch(
            value: isSelected,
            onChanged: (v) => _toggleDay(day, v),
            activeThumbColor: AppColors.primary,
          ),
        ],
      ),
    );
  }


}
