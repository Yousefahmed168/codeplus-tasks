import '../widgets/doctor_profile_header.dart';

import 'dart:async';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/widgets/custom_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/models/booking_draft.dart';
import '../../../../core/services/admin_service.dart';
import '../../../../core/services/appointment_service.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/favorite_service.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/utils/booking_slots.dart';
import '../../../../core/widgets/app_background.dart';
import '../../../../core/widgets/dialogs.dart';
import '../../../../core/widgets/main_button.dart';
import '../../../../core/models/doctor.dart';
import '../../../../i18n/strings.g.dart';
import '../../../../core/utils/snack_bar_helper.dart';
import '../../../../core/utils/app_images.dart';

class SelectTimeScreen extends StatefulWidget {
  const SelectTimeScreen({super.key, required this.doctor});

  final Doctor doctor;

  @override
  State<SelectTimeScreen> createState() => _SelectTimeScreenState();
}

class _SelectTimeScreenState extends State<SelectTimeScreen> {
  /// Slots before this minute-of-day are "afternoon", the rest "evening".
  static const int _afternoonCutoffMinutes = 17 * 60; // 5:00 PM

  late List<DateTime> _availableDates;
  DateTime? _selectedDate;
  String? _selectedTime;
  String _clinicLocation = '';
  bool _isFavorite = false;

  /// Reservation document ids for [widget.doctor] (`bookings` collection).
  Set<String> _bookedSlotIds = const <String>{};
  StreamSubscription<Set<String>>? _bookedSlotsSubscription;

  @override
  void initState() {
    super.initState();
    _availableDates = _buildAvailableDates();
    _selectedDate = _availableDates.firstWhere(
      (date) => _slotsForDate(date).isNotEmpty,
      orElse: () => _availableDates.first,
    );

    final doctorUid = widget.doctor.uid;
    final isSignedIn = sl<AuthService>().currentUser != null;
    if (isSignedIn && doctorUid != null && doctorUid.isNotEmpty) {
      _bookedSlotsSubscription = sl<AppointmentService>()
          .streamBookedSlots(doctorUid)
          .listen(
            (ids) {
              if (!mounted) return;
              final date = _selectedDate;
              final slot = _selectedTime;
              final lostSelection =
                  date != null &&
                  slot != null &&
                  !_isSlotBooked(date, slot) &&
                  ids.contains(
                    BookingSlots.bookingDocId(
                      doctorId: doctorUid,
                      date: date,
                      timeSlot: slot,
                    ),
                  );
              setState(() {
                _bookedSlotIds = ids;
                if (lostSelection) _selectedTime = null;
              });
              if (lostSelection) {
                SnackBarHelper.showWarning(
                  context,
                  t.selectTime.slotJustBooked,
                );
              }
            },
            onError: (Object error) {
              debugPrint('SelectTimeScreen: booked slots stream error: $error');
            },
          );
    }

    sl<AdminService>().getCentralClinicLocation().then((loc) {
      if (mounted) setState(() => _clinicLocation = loc);
    });

    final uid = sl<AuthService>().currentUser?.uid;
    if (uid != null && doctorUid != null) {
      sl<FavoriteService>()
          .isFavorited(patientUid: uid, doctorUid: doctorUid)
          .then((val) {
            if (mounted) setState(() => _isFavorite = val);
          });
    }
  }

  @override
  void dispose() {
    _bookedSlotsSubscription?.cancel();
    super.dispose();
  }

  /// The next bookable dates, limited to the doctor's working days.
  List<DateTime> _buildAvailableDates({int maxDays = 14, int limit = 5}) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final workingDays = widget.doctor.workingDays
        .map((day) => day.toLowerCase().trim())
        .toSet();

    final dates = <DateTime>[];
    for (var i = 0; i < maxDays && dates.length < limit; i++) {
      final date = today.add(Duration(days: i));
      final weekday = BookingSlots.weekdayNames[date.weekday - 1].toLowerCase();
      if (workingDays.isNotEmpty && !workingDays.contains(weekday)) continue;
      dates.add(date);
    }

    // Always render at least today so the empty state can explain itself.
    if (dates.isEmpty) dates.add(today);
    return dates;
  }

  /// Bookable slot labels for [date], excluding already reserved slots.
  List<String> _slotsForDate(DateTime date) => BookingSlots.generate(
    widget.doctor,
    date,
  ).where((slot) => !_isSlotBooked(date, slot)).toList();

  bool _isSlotBooked(DateTime date, String timeSlot) {
    final doctorId = widget.doctor.uid;
    if (doctorId == null || doctorId.isEmpty) return false;
    return _bookedSlotIds.contains(
      BookingSlots.bookingDocId(
        doctorId: doctorId,
        date: date,
        timeSlot: timeSlot,
      ),
    );
  }

  List<String> _afternoonSlotsFor(DateTime date) => _slotsForDate(date)
      .where(
        (label) => BookingSlots.parseMinutes(label) < _afternoonCutoffMinutes,
      )
      .toList();

  List<String> _eveningSlotsFor(DateTime date) => _slotsForDate(date)
      .where(
        (label) => BookingSlots.parseMinutes(label) >= _afternoonCutoffMinutes,
      )
      .toList();

  /// The first bookable date strictly after [from], or null if none.
  DateTime? _nextAvailableDate(DateTime from) {
    for (final date in _availableDates) {
      if (date.isAfter(from) && _slotsForDate(date).isNotEmpty) return date;
    }
    return null;
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
      backgroundColor: AppColors.transparent,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.transparent,
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
                  name: widget.doctor.name ?? '',
                  clinic: _clinicLocation,
                  rating: widget.doctor.rating ?? 0,
                  reviewsCount: widget.doctor.reviewsCount,
                  imagePath: widget.doctor.imageUrl ?? AppImages.doctor,
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
                final slotsCount = _slotsForDate(date).length;

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
                      _slotsForDate(_selectedDate!).isNotEmpty) ...[
                    // Afternoon
                    if (_afternoonSlotsFor(_selectedDate!).isNotEmpty) ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          t.selectTime.afternoonSlots(
                            count: _afternoonSlotsFor(_selectedDate!).length,
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
                          children: _afternoonSlotsFor(
                            _selectedDate!,
                          ).map((time) => _buildTimeSlot(time)).toList(),
                        ),
                      ),
                      32.verticalSpace,
                    ],

                    // Evening
                    if (_eveningSlotsFor(_selectedDate!).isNotEmpty) ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          t.selectTime.eveningSlots(
                            count: _eveningSlotsFor(_selectedDate!).length,
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
                          children: _eveningSlotsFor(
                            _selectedDate!,
                          ).map((time) => _buildTimeSlot(time)).toList(),
                        ),
                      ),
                      32.verticalSpace,
                    ],

                    // Proceed to the Review step (step 3 of 4).
                    MainButton(
                      text: t.selectTime.proceed,
                      bgColor: _selectedTime != null
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      onPressed: _selectedTime != null
                          ? () {
                              if (sl<AuthService>().currentUser == null) {
                                SnackBarHelper.showWarning(
                                  context,
                                  t.common.loginRequired,
                                );
                                return;
                              }
                              context.push(
                                AppRoutes.reviewAppointment,
                                extra: BookingDraft(
                                  doctor: widget.doctor,
                                  date: _selectedDate!,
                                  timeSlot: _selectedTime!,
                                  clinicLocation: _clinicLocation,
                                ),
                              );
                            }
                          : null,
                    ),
                  ] else ...[
                    // Empty state — the selected day has no bookable slots left.
                    40.verticalSpace,
                    Text(
                      t.selectTime.noSlotsAvailable,
                      style: context.regular14.textSecondary,
                    ),
                    24.verticalSpace,
                    Builder(
                      builder: (context) {
                        final next = _selectedDate == null
                            ? null
                            : _nextAvailableDate(_selectedDate!);
                        return MainButton(
                          text: next == null
                              ? t.selectTime.noUpcomingDates
                              : t.selectTime.nextAvailabilityOn(
                                  date: _getDateLabel(next),
                                ),
                          onPressed: next == null
                              ? null
                              : () => setState(() {
                                  _selectedDate = next;
                                  _selectedTime = null;
                                }),
                          bgColor: AppColors.primary,
                          textColor: AppColors.textOnPrimary,
                        );
                      },
                    ),
                    24.verticalSpace,
                    Text(
                      t.selectTime.or,
                      style: context.regular14.textSecondary,
                    ),
                    24.verticalSpace,
                    MainButton(
                      text: t.selectTime.contactClinic,
                      onPressed: () => showMyDialog(
                        context,
                        t.selectTime.clinicLocationLabel(
                          location: _clinicLocation,
                        ),
                      ),
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
