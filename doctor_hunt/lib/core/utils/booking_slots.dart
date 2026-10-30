import '../models/doctor.dart';

/// Pure, side-effect free helpers for slot generation and booking identity.
///
/// Slot labels use the exact `h:mm a` format that has always been persisted on
/// the appointment document, so reservations created before this helper existed
/// still map onto the same slot label.
abstract final class BookingSlots {
  BookingSlots._();

  /// Monday-first, matching [DateTime.weekday] (1 = Monday). These are the
  /// canonical values persisted in [Doctor.workingDays].
  static const List<String> weekdayNames = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  /// Locale-independent day identifier, e.g. `2026-10-19`.
  static String dateKey(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  /// `9:00 AM` -> `900AM`, keeping the booking id deterministic and URL-safe.
  static String slotKey(String timeSlot) =>
      timeSlot.replaceAll(RegExp(r'\s+'), '').replaceAll(':', '').toUpperCase();

  /// Deterministic reservation id: one document per doctor/day/slot.
  static String bookingDocId({
    required String doctorId,
    required DateTime date,
    required String timeSlot,
  }) => '${doctorId}_${dateKey(date)}_${slotKey(timeSlot)}';

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// Parses a time such as `09:00 AM` into minutes since midnight.
  static int parseMinutes(String time) {
    final parts = time.trim().split(' ');
    final hm = parts.first.split(':');
    if (hm.length != 2) return 0;
    var hours = int.tryParse(hm[0]) ?? 0;
    final minutes = int.tryParse(hm[1]) ?? 0;
    final period = parts.length > 1 ? parts[1].toUpperCase() : '';
    if (period == 'PM' && hours != 12) hours += 12;
    if (period == 'AM' && hours == 12) hours = 0;
    return hours * 60 + minutes;
  }

  /// `570` -> `9:30 AM`, locale-independent so booking ids never drift.
  static String formatMinutes(int minutes) {
    final hour24 = (minutes ~/ 60) % 24;
    final minute = minutes % 60;
    final period = hour24 >= 12 ? 'PM' : 'AM';
    final hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12;
    return '$hour12:${minute.toString().padLeft(2, '0')} $period';
  }

  /// Bookable slot labels for [date], derived from the doctor's working hours
  /// and slot duration. Past slots are removed for today.
  ///
  /// Reservations are *not* filtered here — callers subtract
  /// [bookingDocId] values they receive from the reservations stream.
  static List<String> generate(Doctor doctor, DateTime date, {DateTime? now}) {
    final start = parseMinutes(doctor.startTime);
    final end = parseMinutes(doctor.endTime);
    final step = doctor.slotDuration > 0 ? doctor.slotDuration : 30;
    if (end <= start) return const [];

    final current = now ?? DateTime.now();
    final isToday = isSameDay(date, current);
    final currentMinutes = current.hour * 60 + current.minute;

    final slots = <String>[];
    for (var minute = start; minute + step <= end; minute += step) {
      if (isToday && minute <= currentMinutes) continue;
      slots.add(formatMinutes(minute));
    }
    return slots;
  }
}
