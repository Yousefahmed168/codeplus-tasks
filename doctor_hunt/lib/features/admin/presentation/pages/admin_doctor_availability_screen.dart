import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/widgets/custom_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/services/admin_service.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/models/doctor.dart';
import '../../../../core/widgets/main_button.dart';
import '../../../../core/widgets/custom_dropdown.dart';
import '../../../../i18n/strings.g.dart';
import '../../../../core/utils/snack_bar_helper.dart';
import '../cubit/doctor_availability_cubit.dart';
import '../../../../core/constants/my_icons.dart';

class AdminDoctorAvailabilityScreen extends StatefulWidget {
  final Doctor doctor;

  const AdminDoctorAvailabilityScreen({super.key, required this.doctor});

  @override
  State<AdminDoctorAvailabilityScreen> createState() =>
      _AdminDoctorAvailabilityScreenState();
}

class _AdminDoctorAvailabilityScreenState
    extends State<AdminDoctorAvailabilityScreen> {
  /// Canonical weekday values persisted to Firestore (matched against
  /// [Doctor.workingDays]); localized for display only, via [_dayLabel].
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
  String _clinicLocation = '';

  /// Selectable slot durations, in minutes.
  static const List<int> _slotDurationMinutes = [15, 30, 45, 60];

  /// Default selectable working hours (persisted verbatim).
  static const List<String> _startTimeOptionsBase = [
    '08:00 AM',
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
  ];
  static const List<String> _endTimeOptionsBase = [
    '03:00 PM',
    '04:00 PM',
    '05:00 PM',
    '06:00 PM',
    '07:00 PM',
  ];

  /// The selectable options, always including the doctor's stored value so the
  /// dropdown never receives a value that is missing from its items.
  List<int> get _slotDurationOptions =>
      <int>{..._slotDurationMinutes, _slotDuration}.toList()..sort();

  List<String> get _startTimeOptions => _startTimeOptionsBase.contains(_startTime)
      ? _startTimeOptionsBase
      : [..._startTimeOptionsBase, _startTime];

  List<String> get _endTimeOptions => _endTimeOptionsBase.contains(_endTime)
      ? _endTimeOptionsBase
      : [..._endTimeOptionsBase, _endTime];

  @override
  void initState() {
    super.initState();
    _selectedDays = List.from(widget.doctor.workingDays);
    _startTime = widget.doctor.startTime;
    _endTime = widget.doctor.endTime;
    _slotDuration = widget.doctor.slotDuration;

    sl<AdminService>().getCentralClinicLocation().then((location) {
      if (mounted) setState(() => _clinicLocation = location);
    });
  }

  /// Localized label for a persisted weekday value (`Monday`..`Sunday`).
  String _dayLabel(String day) {
    switch (day) {
      case 'Monday':
        return t.admin.availability.days.monday;
      case 'Tuesday':
        return t.admin.availability.days.tuesday;
      case 'Wednesday':
        return t.admin.availability.days.wednesday;
      case 'Thursday':
        return t.admin.availability.days.thursday;
      case 'Friday':
        return t.admin.availability.days.friday;
      case 'Saturday':
        return t.admin.availability.days.saturday;
      case 'Sunday':
        return t.admin.availability.days.sunday;
      default:
        return day;
    }
  }

  String _slotDurationLabel(int minutes) =>
      t.admin.availability.minutes(count: minutes);

  /// Specialty and clinic location, falling back to a single placeholder.
  String _doctorSubtitle() {
    final specialty = widget.doctor.specialization?.trim();
    final parts = [
      if (specialty != null && specialty.isNotEmpty) specialty,
      if (_clinicLocation.isNotEmpty) _clinicLocation,
    ];
    return parts.isEmpty ? t.common.notProvided : parts.join(' • ');
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

  void _saveAvailability(BuildContext context) {
    context.read<DoctorAvailabilityCubit>().saveAvailability(
      doctor: widget.doctor,
      workingDays: _selectedDays,
      startTime: _startTime,
      endTime: _endTime,
      slotDuration: _slotDuration,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DoctorAvailabilityCubit(),
      child: BlocListener<DoctorAvailabilityCubit, DoctorAvailabilityState>(
        listener: (context, state) {
          if (state.status == DoctorAvailabilityStatus.saved) {
            SnackBarHelper.showSuccess(context, t.admin.availability.updated);
            context.pop();
          } else if (state.status == DoctorAvailabilityStatus.failed) {
            SnackBarHelper.showError(context, t.admin.availability.failed);
          }
        },
        // A [Builder] gives the subtree a context below the [BlocProvider] so
        // `context.watch`/`context.read` can resolve the cubit. The State's own
        // context is an ancestor of the provider and would throw.
        child: Builder(builder: _buildScaffold),
      ),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    final state = context.watch<DoctorAvailabilityCubit>().state;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leadingWidth: 70.w,
        leading: Padding(
          padding: EdgeInsets.only(left: 16.w),
          child: const CustomBackButton(),
        ),
        title: Text(t.admin.availability.title, style: context.bold18.textPrimary),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor Header Card
            _buildDoctorHeader(),
            24.verticalSpace,

            // Working Days
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(t.admin.availability.workingDays, style: context.bold16.textPrimary),
                Text(
                  t.admin.availability.daysEnabled(count: _selectedDays.length),
                  style: context.regular12.textHint,
                ),
              ],
            ),
            16.verticalSpace,
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: _allDays.map((day) => _buildDayTile(day)).toList(),
              ),
            ),
            24.verticalSpace,

            // Working Hours
            Text(t.admin.availability.workingHours, style: context.bold16.textPrimary),
            16.verticalSpace,
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16.r),
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
                              t.admin.availability.startTime,
                              style: context.semiBold11.textSecondary,
                            ),
                            5.verticalSpace,
                            CustomDropdown<String>(
                              value: _startTime,
                              isExpanded: true,
                              prefixIcon: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.w),
                                child: Icon(MyIcons.accessTime, size: 16.r, color: AppColors.primary),
                              ),
                              items: _startTimeOptions,
                              onChanged: (v) => setState(() => _startTime = v!),
                            ),
                          ],
                        ),
                      ),
                      16.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t.admin.availability.endTime,
                              style: context.semiBold11.textSecondary,
                            ),
                            5.verticalSpace,
                            CustomDropdown<String>(
                              value: _endTime,
                              isExpanded: true,
                              prefixIcon: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.w),
                                child: Icon(MyIcons.accessTime, size: 16.r, color: AppColors.primary),
                              ),
                              items: _endTimeOptions,
                              onChanged: (v) => setState(() => _endTime = v!),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  16.verticalSpace,
                  Text(
                    t.admin.availability.slotDuration,
                    style: context.semiBold11.textSecondary,
                  ),
                  5.verticalSpace,
                  CustomDropdown<String>(
                    value: _slotDurationLabel(_slotDuration),
                    isExpanded: true,
                    prefixIcon: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Icon(MyIcons.accessTime, size: 16.r, color: AppColors.primary),
                    ),
                    items: _slotDurationOptions
                        .map(_slotDurationLabel)
                        .toList(),
                    onChanged: (v) {
                      if (v == null) return;
                      final minutes = _slotDurationOptions.firstWhere(
                        (m) => _slotDurationLabel(m) == v,
                        orElse: () => _slotDuration,
                      );
                      setState(() => _slotDuration = minutes);
                    },
                  ),
                ],
              ),
            ),
            32.verticalSpace,

            MainButton(
              text: state.status == DoctorAvailabilityStatus.saving
                  ? t.admin.editDoctor.updatingBtn
                  : t.admin.editDoctor.updateBtn,
              onPressed: state.status == DoctorAvailabilityStatus.saving
                  ? null
                  : () => _saveAvailability(context),
              bgColor: AppColors.primary,
            ),
            32.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorHeader() {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 50.r,
            height: 50.r,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(12.r),
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
                ? const Icon(MyIcons.person, color: AppColors.primary)
                : null,
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.doctor.name ?? '',
                  style: context.bold14.textPrimary,
                ),
                Text(
                  _doctorSubtitle(),
                  style: context.regular12.textSecondary,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: widget.doctor.isActive
                  ? AppColors.success.withValues(alpha: 0.1)
                  : AppColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              children: [
                Container(
                  width: 6.r,
                  height: 6.r,
                  decoration: BoxDecoration(
                    color: widget.doctor.isActive
                        ? AppColors.success
                        : AppColors.error,
                    shape: BoxShape.circle,
                  ),
                ),
                4.horizontalSpace,
                Text(
                  widget.doctor.isActive ? t.admin.doctors.active : t.admin.doctorDetails.inactive,
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
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              MyIcons.calendarTodayOutlined,
              size: 16.r,
              color: AppColors.primary,
            ),
          ),
          12.horizontalSpace,
          Expanded(
            child: Text(
              _dayLabel(day),
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
