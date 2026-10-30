import 'package:doctor_hunt/core/models/doctor.dart';
import 'package:doctor_hunt/core/utils/booking_slots.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final today = DateTime(2026, 10, 19);
  final tomorrow = DateTime(2026, 10, 20);

  Doctor doctor({
    String start = '09:00 AM',
    String end = '11:00 AM',
    int step = 30,
  }) =>
      Doctor(uid: 'doc-1', startTime: start, endTime: end, slotDuration: step);

  group('BookingSlots.generate', () {
    test('builds slots from working hours and slot duration', () {
      final slots = BookingSlots.generate(
        doctor(),
        today,
        now: DateTime(2026, 10, 19, 8),
      );

      expect(slots, ['9:00 AM', '9:30 AM', '10:00 AM', '10:30 AM']);
    });

    test('drops slots that already passed earlier today', () {
      final slots = BookingSlots.generate(
        doctor(),
        today,
        now: DateTime(2026, 10, 19, 10, 15),
      );

      expect(slots, ['10:30 AM']);
    });

    test('does not drop slots for future days', () {
      final slots = BookingSlots.generate(
        doctor(),
        tomorrow,
        now: DateTime(2026, 10, 19, 10, 15),
      );

      expect(slots, hasLength(4));
    });

    test('returns no slots when working hours are invalid', () {
      final slots = BookingSlots.generate(
        doctor(start: '05:00 PM', end: '09:00 AM'),
        today,
        now: DateTime(2026, 10, 19, 8),
      );

      expect(slots, isEmpty);
    });
  });

  group('BookingSlots.bookingDocId', () {
    test('is deterministic and ignores the time of day', () {
      final morning = BookingSlots.bookingDocId(
        doctorId: 'doc-1',
        date: today,
        timeSlot: '9:00 AM',
      );
      final lateEvening = BookingSlots.bookingDocId(
        doctorId: 'doc-1',
        date: DateTime(2026, 10, 19, 23, 59),
        timeSlot: '9:00 AM',
      );

      expect(morning, 'doc-1_2026-10-19_900AM');
      expect(morning, lateEvening);
    });

    test('normalises whitespace and casing inside the slot label', () {
      expect(
        BookingSlots.slotKey(' 9:00   am '),
        BookingSlots.slotKey('9:00 AM'),
      );
    });
  });

  test('a reserved slot can be removed using its booking id', () {
    final reserved = <String>{
      BookingSlots.bookingDocId(
        doctorId: 'doc-1',
        date: tomorrow,
        timeSlot: '9:30 AM',
      ),
    };

    final available =
        BookingSlots.generate(
          doctor(),
          tomorrow,
          now: DateTime(2026, 10, 19, 8),
        ).where(
          (slot) => !reserved.contains(
            BookingSlots.bookingDocId(
              doctorId: 'doc-1',
              date: tomorrow,
              timeSlot: slot,
            ),
          ),
        );

    expect(available, isNot(contains('9:30 AM')));
    expect(available, hasLength(3));
  });
}
