import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../core/models/doctor.dart';

class AdminService {
  AdminService._();
  static final AdminService instance = AdminService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String adminsCollection = 'admins';
  static const String doctorsCollection = 'doctors';
  static const String bookingsCollection = 'bookings';
  static const String clinicCollection = 'clinic_info';
  static const String centralClinicDocId = 'central_clinic';

  Future<bool> isAdmin(String uid) async {
    try {
      final doc = await _firestore.collection(adminsCollection).doc(uid).get();
      return doc.exists;
    } catch (e) {
      debugPrint('AdminService.isAdmin error: $e');
      return false;
    }
  }

  Stream<List<Doctor>> streamDoctors() {
    return _firestore
        .collection(doctorsCollection)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            data['uid'] = doc.id;
            return Doctor.fromJson(data);
          }).toList(),
        );
  }

  /// Create doctor profile strictly as a Firestore document.
  /// No Firebase Auth user is created (Managed entirely by Clinic Admin).
  Future<String> createDoctor(Doctor doctor) async {
    try {
      final docRef = _firestore.collection(doctorsCollection).doc();
      final docData = doctor.toJson();
      docData['uid'] = docRef.id;
      docData['isActive'] = doctor.isActive;

      await docRef.set(docData);
      return docRef.id;
    } catch (e) {
      debugPrint('AdminService.createDoctor error: $e');
      rethrow;
    }
  }

  Future<void> updateDoctor(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(doctorsCollection).doc(uid).update(data);
    } catch (e) {
      debugPrint('AdminService.updateDoctor error: $e');
      rethrow;
    }
  }

  Future<void> toggleDoctorStatus(String uid, bool isActive) async {
    try {
      await _firestore.collection(doctorsCollection).doc(uid).update({
        'isActive': isActive,
      });
    } catch (e) {
      debugPrint('AdminService.toggleDoctorStatus error: $e');
      rethrow;
    }
  }

  /// Permanently removes a doctor profile.
  ///
  /// Appointment and review documents are intentionally kept so the clinic
  /// keeps its history (the doctor name is denormalised on each appointment).
  /// Active slot reservations are deleted so they are not left dangling.
  Future<void> deleteDoctor(String uid) async {
    try {
      final reservationsSnapshot = await _firestore
          .collection(bookingsCollection)
          .where('doctorId', isEqualTo: uid)
          .get();

      // Firestore batches are capped at 500 writes; chunk to stay well below.
      // Reservations go first so a failure never leaves the profile deleted
      // with reservations still attached to it.
      const chunkSize = 400;
      final reservations = reservationsSnapshot.docs;
      for (var start = 0; start < reservations.length; start += chunkSize) {
        final batch = _firestore.batch();
        final end = start + chunkSize < reservations.length
            ? start + chunkSize
            : reservations.length;
        for (final doc in reservations.sublist(start, end)) {
          batch.delete(doc.reference);
        }
        await batch.commit();
      }

      await _firestore.collection(doctorsCollection).doc(uid).delete();
    } catch (e) {
      debugPrint('AdminService.deleteDoctor error: $e');
      rethrow;
    }
  }

  // --- Single Central Clinic Location ---

  Stream<String> streamCentralClinicLocation() {
    return _firestore
        .collection(clinicCollection)
        .doc(centralClinicDocId)
        .snapshots()
        .map((doc) {
          if (doc.exists && doc.data() != null) {
            return doc.data()!['location'] as String? ??
                'Central Clinic Location';
          }
          return 'Central Clinic Location';
        });
  }

  Future<String> getCentralClinicLocation() async {
    try {
      final doc = await _firestore
          .collection(clinicCollection)
          .doc(centralClinicDocId)
          .get();
      if (doc.exists && doc.data() != null) {
        return doc.data()!['location'] as String? ?? 'Central Clinic Location';
      }
    } catch (e) {
      debugPrint('AdminService.getCentralClinicLocation error: $e');
    }
    return 'Central Clinic Location';
  }

  Future<void> updateCentralClinicLocation(String newLocation) async {
    try {
      await _firestore.collection(clinicCollection).doc(centralClinicDocId).set(
        {'location': newLocation, 'updatedAt': FieldValue.serverTimestamp()},
        SetOptions(merge: true),
      );
    } catch (e) {
      debugPrint('AdminService.updateCentralClinicLocation error: $e');
      rethrow;
    }
  }
}
