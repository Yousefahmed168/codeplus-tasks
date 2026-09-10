import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../features/doctors/models/doctor.dart';

class AdminService {
  AdminService._();
  static final AdminService instance = AdminService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String adminsCollection = 'admins';
  static const String doctorsCollection = 'doctors';

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
          (snapshot) => snapshot.docs
              .map((doc) {
                final data = doc.data();
                data['uid'] = doc.id;
                return Doctor.fromJson(data);
              })
              .toList(),
        );
  }


  // The doctor is given a default password '12345678'.
  Future<String> createDoctor(Doctor doctor) async {
    try {
      final tempApp = await Firebase.initializeApp(
        name: 'TempCreateDoctorApp',
        options: Firebase.app().options,
      );

      try {
        final userCredential = await FirebaseAuth.instanceFor(app: tempApp)
            .createUserWithEmailAndPassword(
          email: doctor.email?.trim() ?? '',
          password: '12345678', // Default password
        );

        final uid = userCredential.user!.uid;

        final docData = doctor.toJson();
        docData['uid'] = uid; 

        await _firestore.collection(doctorsCollection).doc(uid).set(docData);

        return uid;
      } finally {
        await tempApp.delete();
      }
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

  Future<void> deleteDoctor(String uid) async {
    try {
      await _firestore.collection(doctorsCollection).doc(uid).delete();
    } catch (e) {
      debugPrint('AdminService.deleteDoctor error: $e');
      rethrow;
    }
  }
}
