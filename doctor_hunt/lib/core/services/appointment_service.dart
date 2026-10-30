import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../errors/exceptions.dart';
import '../models/appointment_model.dart';
import '../models/review_model.dart';
import '../utils/booking_slots.dart';

class AppointmentService {
  AppointmentService._();
  static final AppointmentService instance = AppointmentService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String appointmentsCollection = 'appointments';
  static const String reviewsCollection = 'reviews';
  static const String doctorsCollection = 'doctors';
  static const String bookingsCollection = 'bookings';

  /// Create a new appointment in 'upcoming' status.
  ///
  /// Slot uniqueness is enforced through a deterministic reservation document
  /// (`bookings/{doctorId}_{yyyy-MM-dd}_{slot}`). The existence check and both
  /// writes run in a single transaction, so two patients racing for the same
  /// slot can never both succeed.
  Future<String> createAppointment(AppointmentModel appointment) async {
    final appointmentRef = _firestore.collection(appointmentsCollection).doc();
    final bookingRef = _firestore
        .collection(bookingsCollection)
        .doc(
          BookingSlots.bookingDocId(
            doctorId: appointment.doctorId,
            date: appointment.date,
            timeSlot: appointment.timeSlot,
          ),
        );

    try {
      // Appointments created before the `bookings` collection existed have no
      // reservation document, so check them once before opening the transaction.
      await _assertNoLegacyBooking(appointment);

      await _firestore.runTransaction((transaction) async {
        final existing = await transaction.get(bookingRef);
        if (existing.exists) throw SlotUnavailableException();

        transaction.set(bookingRef, {
          'doctorId': appointment.doctorId,
          'dateKey': BookingSlots.dateKey(appointment.date),
          'timeSlot': appointment.timeSlot,
          'appointmentId': appointmentRef.id,
          'patientId': appointment.patientId,
          'createdAt': FieldValue.serverTimestamp(),
        });
        transaction.set(
          appointmentRef,
          appointment
              .copyWith(
                id: appointmentRef.id,
                status: AppointmentStatus.upcoming,
                createdAt: DateTime.now(),
              )
              .toJson(),
        );
      });
      return appointmentRef.id;
    } on SlotUnavailableException {
      rethrow;
    } catch (e) {
      debugPrint('AppointmentService.createAppointment error: $e');
      rethrow;
    }
  }

  /// Guards against reservations booked before the `bookings` collection was
  /// introduced. Queries by doctor only so no composite index is required.
  Future<void> _assertNoLegacyBooking(AppointmentModel appointment) async {
    final snapshot = await _firestore
        .collection(appointmentsCollection)
        .where('doctorId', isEqualTo: appointment.doctorId)
        .get();

    final conflict = snapshot.docs.any((doc) {
      final data = doc.data();
      if (AppointmentStatus.fromString(data['status']?.toString()) !=
          AppointmentStatus.upcoming) {
        return false;
      }
      if (data['timeSlot']?.toString() != appointment.timeSlot) return false;
      final date = _readDate(data['date']);
      return date != null && BookingSlots.isSameDay(date, appointment.date);
    });

    if (conflict) throw SlotUnavailableException();
  }

  /// Patient or Admin can cancel upcoming appointment.
  Future<void> cancelAppointment(String appointmentId) => _updateStatus(
    appointmentId,
    AppointmentStatus.cancelled,
    {'cancelledAt': FieldValue.serverTimestamp()},
  );

  /// Admin can mark an appointment as completed.
  Future<void> completeAppointment(String appointmentId) => _updateStatus(
    appointmentId,
    AppointmentStatus.completed,
    {'completedAt': FieldValue.serverTimestamp()},
  );

  /// Updates the lifecycle status and releases the slot reservation in the
  /// same transaction, so a cancelled appointment frees its slot immediately.
  Future<void> _updateStatus(
    String appointmentId,
    AppointmentStatus status,
    Map<String, dynamic> extraFields,
  ) async {
    final appointmentRef = _firestore
        .collection(appointmentsCollection)
        .doc(appointmentId);
    try {
      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(appointmentRef);
        if (!snapshot.exists) return;

        final data = snapshot.data()!;
        transaction.update(appointmentRef, {
          'status': status.toValue(),
          ...extraFields,
        });

        final doctorId = data['doctorId']?.toString() ?? '';
        final timeSlot = data['timeSlot']?.toString() ?? '';
        final date = _readDate(data['date']);
        if (doctorId.isEmpty || timeSlot.isEmpty || date == null) return;

        transaction.delete(
          _firestore
              .collection(bookingsCollection)
              .doc(
                BookingSlots.bookingDocId(
                  doctorId: doctorId,
                  date: date,
                  timeSlot: timeSlot,
                ),
              ),
        );
      });
    } catch (e) {
      debugPrint('AppointmentService._updateStatus error: $e');
      rethrow;
    }
  }

  /// Live set of reserved slot document ids for [doctorId].
  ///
  /// The booking document id is deterministic, so the UI can compute the id for
  /// any generated slot and check membership directly.
  Stream<Set<String>> streamBookedSlots(String doctorId) {
    if (doctorId.isEmpty) return Stream.value(const <String>{});
    return _firestore
        .collection(bookingsCollection)
        .where('doctorId', isEqualTo: doctorId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toSet());
  }

  DateTime? _readDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  /// Decodes a Firestore payload into an [AppointmentModel].
  ///
  /// A single malformed document is skipped instead of tearing down the whole
  /// stream, so one bad record can never blank out the patient or admin list.
  AppointmentModel? _decodeAppointment(Map<String, dynamic>? data, String? id) {
    if (data == null) return null;
    try {
      return AppointmentModel.fromJson(data, id);
    } catch (e) {
      debugPrint('AppointmentService._decodeAppointment($id) error: $e');
      return null;
    }
  }

  /// Stream appointments for a specific patient.
  Stream<List<AppointmentModel>> streamPatientAppointments(String patientId) {
    return _firestore
        .collection(appointmentsCollection)
        .where('patientId', isEqualTo: patientId)
        .snapshots()
        .map((snapshot) {
          final list = snapshot.docs
              .map((doc) => _decodeAppointment(doc.data(), doc.id))
              .whereType<AppointmentModel>()
              .toList();
          list.sort((a, b) => b.date.compareTo(a.date));
          return list;
        });
  }

  /// Stream appointments for admin with optional status filtering.
  Stream<List<AppointmentModel>> streamAdminAppointments({
    AppointmentStatus? status,
  }) {
    Query<Map<String, dynamic>> query = _firestore.collection(
      appointmentsCollection,
    );
    if (status != null) {
      query = query.where('status', isEqualTo: status.toValue());
    }

    return query.snapshots().map((snapshot) {
      final list = snapshot.docs
          .map((doc) => _decodeAppointment(doc.data(), doc.id))
          .whereType<AppointmentModel>()
          .toList();
      list.sort((a, b) => b.date.compareTo(a.date));
      return list;
    });
  }

  /// Stream a single appointment by id from Firestore.
  ///
  /// Emits `null` when the document is missing or malformed.
  Stream<AppointmentModel?> streamAppointmentById(String appointmentId) {
    return _firestore
        .collection(appointmentsCollection)
        .doc(appointmentId)
        .snapshots()
        .map((doc) => _decodeAppointment(doc.data(), doc.id));
  }

  /// Streams the most recent reviews for a doctor, newest first.
  ///
  /// Ordering happens client-side so no composite Firestore index is needed.
  Stream<List<ReviewModel>> streamReviewsForDoctor(
    String doctorId, {
    int limit = 20,
  }) {
    return _firestore
        .collection(reviewsCollection)
        .where('doctorId', isEqualTo: doctorId)
        .snapshots()
        .map((snapshot) {
          final reviews = snapshot.docs
              .map((doc) => ReviewModel.fromJson(doc.data(), doc.id))
              .toList();
          reviews.sort(
            (a, b) => (b.createdAt ?? DateTime(0)).compareTo(
              a.createdAt ?? DateTime(0),
            ),
          );
          return reviews.take(limit).toList();
        });
  }

  /// Submit a doctor review. Strictly requires appointment to be completed.
  Future<void> submitReview({
    required String appointmentId,
    required String doctorId,
    required String patientId,
    required double rating,
    String? comment,
  }) async {
    try {
      final apptDoc = await _firestore
          .collection(appointmentsCollection)
          .doc(appointmentId)
          .get();
      if (!apptDoc.exists) {
        throw Exception('Appointment not found');
      }

      final appt = AppointmentModel.fromJson(apptDoc.data()!, apptDoc.id);
      if (appt.status != AppointmentStatus.completed) {
        throw Exception('Only completed appointments can be rated.');
      }
      if (appt.hasReviewed) {
        throw Exception('This appointment has already been reviewed.');
      }

      // Add review record
      await _firestore.collection(reviewsCollection).add({
        'appointmentId': appointmentId,
        'doctorId': doctorId,
        'patientId': patientId,
        'patientName': appt.patientName,
        'rating': rating,
        'comment': comment?.trim() ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Mark appointment as reviewed
      await _firestore
          .collection(appointmentsCollection)
          .doc(appointmentId)
          .update({
            'hasReviewed': true,
            'reviewRating': rating,
            'reviewComment': comment?.trim() ?? '',
          });

      // Recalculate doctor rating and review count
      await _recalculateDoctorRating(doctorId);
    } catch (e) {
      debugPrint('AppointmentService.submitReview error: $e');
      rethrow;
    }
  }

  Future<void> _recalculateDoctorRating(String doctorId) async {
    try {
      final reviewsSnap = await _firestore
          .collection(reviewsCollection)
          .where('doctorId', isEqualTo: doctorId)
          .get();

      if (reviewsSnap.docs.isEmpty) return;

      double total = 0.0;
      for (final doc in reviewsSnap.docs) {
        final r = (doc.data()['rating'] as num?)?.toDouble() ?? 0.0;
        total += r;
      }
      final double avgRating = double.parse(
        (total / reviewsSnap.docs.length).toStringAsFixed(1),
      );

      await _firestore.collection(doctorsCollection).doc(doctorId).update({
        'rating': avgRating,
        'reviewsCount': reviewsSnap.docs.length,
      });
    } catch (e) {
      debugPrint('AppointmentService._recalculateDoctorRating error: $e');
    }
  }
}
