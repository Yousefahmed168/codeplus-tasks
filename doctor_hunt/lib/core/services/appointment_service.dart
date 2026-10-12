import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/appointment_model.dart';

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

  /// Stream appointments for a specific patient.
  Stream<List<AppointmentModel>> streamPatientAppointments(String patientId) {
    return _firestore
        .collection(appointmentsCollection)
        .where('patientId', isEqualTo: patientId)
        .snapshots()
        .map((snapshot) {
          final list = snapshot.docs
              .map((doc) => AppointmentModel.fromJson(doc.data(), doc.id))
              .toList();
          list.sort((a, b) => b.date.compareTo(a.date));
          return list;
        });
  }

  /// Stream appointments for admin with optional status filtering.
  Stream<List<AppointmentModel>> streamAdminAppointments({AppointmentStatus? status}) {
    Query query = _firestore.collection(appointmentsCollection);
    if (status != null) {
      query = query.where('status', isEqualTo: status.toValue());
    }

    return query.snapshots().map((snapshot) {
      final list = snapshot.docs
          .map((doc) => AppointmentModel.fromJson(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      list.sort((a, b) => b.date.compareTo(a.date));
      return list;
    });
  }

  /// Stream a single appointment by id from Firestore.
  Stream<AppointmentModel?> streamAppointmentById(String appointmentId) {
    return _firestore
        .collection(appointmentsCollection)
        .doc(appointmentId)
        .snapshots()
        .map((doc) => doc.exists && doc.data() != null
            ? AppointmentModel.fromJson(doc.data()!, doc.id)
            : null);
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
