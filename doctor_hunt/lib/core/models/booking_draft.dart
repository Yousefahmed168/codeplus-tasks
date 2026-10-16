import 'doctor.dart';

/// Immutable payload passed from the date/time picker into the review step of
/// the 4-step booking flow (Date -> Time -> Review -> Confirm).
class BookingDraft {
  final Doctor doctor;
  final DateTime date;
  final String timeSlot;
  final String clinicLocation;

  const BookingDraft({
    required this.doctor,
    required this.date,
    required this.timeSlot,
    required this.clinicLocation,
  });
}
