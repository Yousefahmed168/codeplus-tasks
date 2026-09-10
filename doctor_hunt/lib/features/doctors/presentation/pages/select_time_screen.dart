import '../../../../core/routes/app_routes.dart';
import '../widgets/appointment_success_dialog.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../core/widgets/app_background.dart';
import '../../../../core/widgets/main_button.dart';
import '../../models/doctor.dart';
import '../widgets/doctor_profile_header.dart';
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
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20,
              color: AppColors.textPrimary,
            ),
            onPressed: () => context.pop(),
          ),
          title: Text(t.selectTime.title, style: context.bold24.textPrimary),
          centerTitle: false,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const Gap(16),
                  DoctorProfileHeader(
                    name: widget.doctor.name ?? 'Unknown',
                    clinic:
                        'Upasana Dental Clinic, salt lake', // hardcoded mockup
                    rating: widget.doctor.ratingPercentage.toInt(),
                    imagePath:
                        widget.doctor.imageUrl ?? 'assets/images/doctor.png',
                    isFavorite: true,
                  ),
                  const Gap(24),
                ],
              ),
            ),

            // Horizontal Date List
            SizedBox(
              height: 80,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: _availableDates.length,
                separatorBuilder: (context, index) => const Gap(12),
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: isSelected
                            ? null
                            : Border.all(color: AppColors.textSecondary),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.3,
                                  ),
                                  blurRadius: 8,
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
                                ? context.bold16.copyWith(color: Colors.white)
                                : context.bold16.textPrimary,
                          ),
                          const Gap(4),
                          Text(
                            slotsCount == 0
                                ? t.selectTime.noSlotsAvailable
                                : t.selectTime.slotsAvailable(
                                    count: slotsCount,
                                  ),
                            style: isSelected
                                ? context.regular12.copyWith(
                                    color: Colors.white,
                                  )
                                : context.regular12.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const Gap(32),

            // Time Slots Section
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (_selectedDate != null) ...[
                      Text(
                        _getDateLabel(_selectedDate!),
                        style: context.bold20.textPrimary,
                      ),
                      const Gap(24),
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
                      const Gap(16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: _afternoonSlots
                              .map((time) => _buildTimeSlot(time))
                              .toList(),
                        ),
                      ),
                      const Gap(32),

                      // Evening
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          t.selectTime.eveningSlots(
                            count: _eveningSlots.length,
                          ),
                          style: context.bold18.textPrimary,
                        ),
                      ),
                      const Gap(16),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: _eveningSlots
                              .map((time) => _buildTimeSlot(time))
                              .toList(),
                        ),
                      ),
                      const Gap(40),

                      // Proceed Button
                      MainButton(
                        text: t.selectTime.proceed,
                        bgColor: _selectedTime != null
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        onPressed: _selectedTime != null
                            ? () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AppointmentSuccessDialog(
                                      onDone: () {
                                        context.go(AppRoutes.home);
                                      },
                                      doctorName: 'Dr. ${widget.doctor.name}',
                                      date: _selectedDate!.toIso8601String(),
                                      time: _selectedTime!,
                                      onEdit: () {
                                        context.pop();
                                      },
                                    );
                                  },
                                );
                              }
                            : null,
                      ),
                    ] else ...[
                      // Empty state for Today
                      const Gap(40),
                      Text(
                        t.selectTime.noSlotsAvailable,
                        style: context.regular14.textSecondary,
                      ),
                      const Gap(24),
                      MainButton(
                        text: t.selectTime.nextAvailability,
                        onPressed: () {},
                        bgColor: AppColors.primary,
                        textColor: AppColors.background,
                      ),
                      const Gap(24),
                      Text(
                        t.selectTime.or,
                        style: context.regular14.textSecondary,
                      ),
                      const Gap(24),
                      MainButton(
                        text: t.selectTime.contactClinic,
                        onPressed: () {},
                        bgColor: Colors.white,
                        textColor: AppColors.primary,
                        borderColor: AppColors.textHint,
                      ),
                    ],
                    const Gap(100), // extra scroll padding
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          time,
          style: isSelected
              ? context.bold14.copyWith(color: Colors.white)
              : context.bold14.primary,
        ),
      ),
    );
  }
}
