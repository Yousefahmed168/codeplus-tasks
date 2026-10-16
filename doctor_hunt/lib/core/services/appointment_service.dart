import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/appointment_model.dart';
import '../models/review_model.dart';

class AppointmentService {
  AppointmentService._();
  static final AppointmentService instance = AppointmentService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String appointmentsCollection = 'appointments';
  static const String reviewsCollection = 'reviews';
  static const String doctorsCollection = 'doctors';

  /// Create a new appointment in 'upcoming' status.
  Future<String> createAppointment(AppointmentModel appointment) async {
    try {
      final docRef = _firestore.collection(appointmentsCollection).doc();
      final data = appointment.copyWith(
        id: docRef.id,
        status: AppointmentStatus.upcoming,
        createdAt: DateTime.now(),
      ).toJson();

      await docRef.set(data);
      return docRef.id;
    } catch (e) {
      debugPrint('AppointmentService.createAppointment error: $e');
      rethrow;
    }
  }

  /// Patient or Admin can cancel upcoming appointment.
  Future<void> cancelAppointment(String appointmentId) async {
    try {
      await _firestore.collection(appointmentsCollection).doc(appointmentId).update({
        'status': AppointmentStatus.cancelled.toValue(),
        'cancelledAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('AppointmentService.cancelAppointment error: $e');
      rethrow;
    }
  }

  /// Admin can mark an appointment as completed.
  Future<void> completeAppointment(String appointmentId) async {
    try {
      await _firestore.collection(appointmentsCollection).doc(appointmentId).update({
        'status': AppointmentStatus.completed.toValue(),
        'completedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('AppointmentService.completeAppointment error: $e');
      rethrow;
    }
  }

  /// Decodes a Firestore payload into an [AppointmentModel].
  ///
  /// A single malformed document is skipped instead of tearing down the whole
  /// stream, so one bad record can never blank out the patient or admin list.
  AppointmentModel? _decodeAppointment(
    Map<String, dynamic>? data,
    String? id,
  ) {
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
  Stream<List<AppointmentModel>> streamAdminAppointments({AppointmentStatus? status}) {
    Query<Map<String, dynamic>> query =
        _firestore.collection(appointmentsCollection);
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
      final apptDoc = await _firestore.collection(appointmentsCollection).doc(appointmentId).get();
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
      await _firestore.collection(appointmentsCollection).doc(appointmentId).update({
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
      final double avgRating = double.parse((total / reviewsSnap.docs.length).toStringAsFixed(1));

      await _firestore.collection(doctorsCollection).doc(doctorId).update({
        'rating': avgRating,
        'reviewsCount': reviewsSnap.docs.length,
      });
    } catch (e) {
      debugPrint('AppointmentService._recalculateDoctorRating error: $e');
    }
  }
}
