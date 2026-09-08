import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_hunt/features/auth/data/models/user_model.dart';
import 'package:flutter/foundation.dart';
import '../../features/doctors/models/doctor_model.dart';
import '../../features/auth/data/models/patient_model.dart';
import 'auth_service.dart';

/// Singleton for reading and writing user documents in Firestore.
class UserService {
  UserService._();
  static final UserService instance = UserService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetches a user document by [uid], checking doctors then patients.
  /// Returns null if no document is found in either collection.
  Future<dynamic> getUser(String uid) async {
    try {
      final doctorDoc = await _firestore
          .collection(AuthService.doctorsCollection)
          .doc(uid)
          .get();
      if (doctorDoc.exists) {
        final data = doctorDoc.data()!;
        data['uid'] = doctorDoc.id;
        return DoctorModel.fromJson(data);
      }

      final patientDoc = await _firestore
          .collection(AuthService.patientsCollection)
          .doc(uid)
          .get();
      if (patientDoc.exists) {
        final data = patientDoc.data()!;
        data['uid'] = patientDoc.id;
        return PatientModel.fromJson(data);
      }

      return null;
    } catch (e) {
      debugPrint('UserService.getUser error: $e');
      return null;
    }
  }

  /// Streams all doctor documents from the doctors collection.
  Stream<List<DoctorModel>> streamDoctors() {
    return _firestore
        .collection(AuthService.doctorsCollection)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) {
                final data = doc.data();
                data['uid'] = doc.id;
                return DoctorModel.fromJson(data);
              })
              .toList(),
        );
  }

  /// Updates a user document in the correct collection based on [role].
  Future<void> updateUser(
    String uid,
    Map<String, dynamic> data, {
    required UserRole role,
  }) async {
    try {
      final collection = AuthService.collectionForRole(role);
      await _firestore.collection(collection).doc(uid).update(data);
    } catch (e) {
      debugPrint('UserService.updateUser error: $e');
      rethrow;
    }
  }

  /// Deletes a user document from the correct collection based on [role].
  Future<void> deleteUser(String uid, {required UserRole role}) async {
    try {
      final collection = AuthService.collectionForRole(role);
      await _firestore.collection(collection).doc(uid).delete();
    } catch (e) {
      debugPrint('UserService.deleteUser error: $e');
      rethrow;
    }
  }
}