import '../widgets/doctor_profile_header.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/widgets/custom_back_button.dart';
import '../widgets/appointment_success_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/models/appointment_model.dart';
import '../../../../core/services/admin_service.dart';
import '../../../../core/services/appointment_service.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/favorite_service.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/widgets/app_background.dart';
import '../../../../core/widgets/main_button.dart';
import '../../models/doctor.dart';
import '../../../../i18n/strings.g.dart';

class SelectTimeScreen extends StatefulWidget {
  const SelectTimeScreen({super.key, required this.doctor});

  final Doctor doctor;

  @override
  State<SelectTimeScreen> createState() => _SelectTimeScreenState();
}

class _SelectTimeScreenState extends State<SelectTimeScreen> {
  late List<DateTime> _availableDates;
  DateTime? _selectedDate;
  String? _selectedTime;
  String _clinicLocation = 'Central Clinic';
  bool _isBooking = false;
  bool _isFavorite = false;

  final List<String> _afternoonSlots = [
    '1:00 PM',
    '1:30 PM',
    '2:00 PM',
    '2:30 PM',
    '3:00 PM',
    '3:30 PM',
    '4:00 PM',
  ];

  final List<String> _eveningSlots = [
    '5:00 PM',
    '5:30 PM',
    '6:00 PM',
    '6:30 PM',
    '7:00 PM',
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _availableDates = [
      now,
      now.add(const Duration(days: 1)),
      now.add(const Duration(days: 2)),
    ];
    _selectedDate =
        _availableDates[1]; // default to Tomorrow (as in screenshot)

    sl<AdminService>().getCentralClinicLocation().then((loc) {
      if (mounted) setState(() => _clinicLocation = loc);
    });

    final uid = sl<AuthService>().currentUser?.uid;
    final doctorUid = widget.doctor.uid;
    if (uid != null && doctorUid != null) {
      sl<FavoriteService>()
          .isFavorited(patientUid: uid, doctorUid: doctorUid)
          .then((val) {
        if (mounted) setState(() => _isFavorite = val);
      });
    }
  }

  String _getDateLabel(DateTime date) {
    final now = DateTime.now();
    final diff = DateTime(
      date.year,
      date.month,
      date.day,
    ).difference(DateTime(now.year, now.month, now.day)).inDays;

    final formatter = DateFormat('d MMM');
    if (diff == 0) return t.selectTime.today(date: formatter.format(date));
    if (diff == 1) return t.selectTime.tomorrow(date: formatter.format(date));
    return '${DateFormat('EEEE').format(date)}, ${formatter.format(date)}';
  }

  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: CustomBackButton(),
        title: Text(t.selectTime.title, style: context.bold24.textPrimary),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                16.verticalSpace,
                DoctorProfileHeader(
                  name: widget.doctor.name ?? 'Unknown',
                  clinic: _clinicLocation,
                  rating: widget.doctor.ratingPercentage.toInt(),
                  imagePath:
                      widget.doctor.imageUrl ?? 'assets/images/doctor.png',
                  isFavorite: _isFavorite,
                  onFavoriteToggle: () async {
                    final uid = sl<AuthService>().currentUser?.uid;
                    final doctorUid = widget.doctor.uid;
                    if (uid == null || doctorUid == null) return;
                    final nowFav = await sl<FavoriteService>().toggleFavorite(
                      patientUid: uid,
                      doctorUid: doctorUid,
                    );
                    if (mounted) setState(() => _isFavorite = nowFav);
                  },
                ),
                24.verticalSpace,
              ],
            ),
          ),

          // Horizontal Date List
          SizedBox(
            height: 80.h,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              scrollDirection: Axis.horizontal,
              itemCount: _availableDates.length,
              separatorBuilder: (context, index) => 12.horizontalSpace,
              itemBuilder: (context, index) {
                final date = _availableDates[index];
                final isSelected = date == _selectedDate;
                final slotsCount = index == 0 ? 0 : (index == 1 ? 9 : 10);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDate = date;
                      _selectedTime = null; // reset time
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.surface,
                      borderRadius: BorderRadius.circular(8.r),
                      border: isSelected
                          ? null
                          : Border.all(color: AppColors.textSecondary),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.3),
                                blurRadius: 8.r,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _getDateLabel(date),
                          style: isSelected
                              ? context.bold16.textOnPrimary
                              : context.bold16.textPrimary,
                        ),
                        4.verticalSpace,
                        Text(
                          slotsCount == 0
                              ? t.selectTime.noSlotsAvailable
                              : t.selectTime.slotsAvailable(count: slotsCount),
                          style: isSelected
                              ? context.regular12.textOnPrimary
                              : context.regular12.textSecondary,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          32.verticalSpace,

          // Time Slots Section
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (_selectedDate != null) ...[
                    Text(
                      _getDateLabel(_selectedDate!),
                      style: context.bold20.textPrimary,
                    ),
                    24.verticalSpace,
                  ],

                  if (_selectedDate != null &&
                      _selectedDate != _availableDates[0]) ...[
                    // Afternoon
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        t.selectTime.afternoonSlots(
                          count: _afternoonSlots.length,
                        ),
                        style: context.bold18.textPrimary,
                      ),
                    ),
                    16.verticalSpace,
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                        spacing: 12.w,
                        runSpacing: 12.h,
                        children: _afternoonSlots
                            .map((time) => _buildTimeSlot(time))
                            .toList(),
                      ),
                    ),
                    32.verticalSpace,

                    // Evening
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        t.selectTime.eveningSlots(count: _eveningSlots.length),
                        style: context.bold18.textPrimary,
                      ),
                    ),
                    16.verticalSpace,
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                        spacing: 12.w,
                        runSpacing: 12.h,
                        children: _eveningSlots
                            .map((time) => _buildTimeSlot(time))
                            .toList(),
                      ),
                    ),
                    40.verticalSpace,

                    // Proceed Button
                    MainButton(
                      text: _isBooking ? t.common.loading : t.selectTime.proceed,
                      bgColor: (_selectedTime != null && !_isBooking)
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      onPressed: (_selectedTime != null && !_isBooking)
                          ? () async {
                              final currentUser = sl<AuthService>().currentUser;
                              if (currentUser == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(t.favorite.pleaseLogin)),
                                );
                                return;
                              }

                              setState(() => _isBooking = true);
                              try {
                                final appt = AppointmentModel(
                                  id: '',
                                  patientId: currentUser.uid,
                                  patientName: currentUser.displayName ?? 'Patient',
                                  patientEmail: currentUser.email ?? '',
                                  doctorId: widget.doctor.uid ?? '',
                                  doctorName: widget.doctor.name ?? 'Doctor',
                                  doctorSpecialty: widget.doctor.specialization,
                                  doctorImageUrl: widget.doctor.imageUrl,
                                  clinicLocation: _clinicLocation,
                                  date: _selectedDate!,
                                  timeSlot: _selectedTime!,
                                  status: AppointmentStatus.upcoming,
                                );

                                await sl<AppointmentService>().createAppointment(appt);

                                if (mounted) {
                                  showDialog(
                                    // ignore: use_build_context_synchronously
                                    context: context,
                                    builder: (context) {
                                      return AppointmentSuccessDialog(
                                        onDone: () {
                                          context.go(AppRoutes.home);
                                        },
                                        doctorName: 'Dr. ${widget.doctor.name}',
                                        date: DateFormat('d MMM yyyy').format(_selectedDate!),
                                        time: _selectedTime!,
                                        onEdit: () {
                                          context.pop();
                                        },
                                      );
                                    },
                                  );
                                }
                              } catch (e) {
                                if (mounted) {
                                  // ignore: use_build_context_synchronously
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('${t.common.errorGeneric}: $e')),
                                  );
                                }
                              } finally {
                                if (mounted) setState(() => _isBooking = false);
                              }
                            }
                          : null,
                    ),
                  ] else ...[
                    // Empty state for Today
                    40.verticalSpace,
                    Text(
                      t.selectTime.noSlotsAvailable,
                      style: context.regular14.textSecondary,
                    ),
                    24.verticalSpace,
                    MainButton(
                      text: t.selectTime.nextAvailability,
                      onPressed: () {},
                      bgColor: AppColors.primary,
                      textColor: AppColors.textOnPrimary,
                    ),
                    24.verticalSpace,
                    Text(
                      t.selectTime.or,
                      style: context.regular14.textSecondary,
                    ),
                    24.verticalSpace,
                    MainButton(
                      text: t.selectTime.contactClinic,
                      onPressed: () {},
                      bgColor: AppColors.surface,
                      textColor: AppColors.primary,
                      borderColor: AppColors.textHint,
                    ),
                  ],
                  100.verticalSpace, // extra scroll padding
                ],
              ),
            ),
          ),
        ],
      ),
    );
    return AppBackground(child: scaffold);
  }

  Widget _buildTimeSlot(String time) {
    final isSelected = time == _selectedTime;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTime = time;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          time,
          style: isSelected
              ? context.bold14.textOnPrimary
              : context.bold14.primary,
        ),
      ),
    );
  }
}
