import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../features/doctors/models/doctor_model.dart';
import '../../features/auth/data/models/patient_model.dart';
import '../../features/auth/models/user_model.dart';

/// Singleton that wraps FirebaseAuth for login, registration, and role lookup.
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Firestore collection names
  static const String patientsCollection = 'patients';
  static const String doctorsCollection = 'doctors';

  /// Returns the correct Firestore collection for the given [role].
  static String collectionForRole(UserRole role) {
    return role == UserRole.doctor ? doctorsCollection : patientsCollection;
  }

  /// Currently signed-in Firebase user (nullable).
  User? get currentUser => _auth.currentUser;

  /// Stream of auth state changes.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Determines a user's role by checking both Firestore collections.
  /// Returns [UserRole.doctor], [UserRole.patient], or null if not found.
  Future<UserRole?> getUserRole(String uid) async {
    try {
      final doctorDoc =
          await _firestore.collection(doctorsCollection).doc(uid).get();
      if (doctorDoc.exists) return UserRole.doctor;

      final patientDoc =
          await _firestore.collection(patientsCollection).doc(uid).get();
      if (patientDoc.exists) return UserRole.patient;

      return null;
    } catch (e) {
      debugPrint('AuthService.getUserRole error: $e');
      return null;
    }
  }

  /// Sign in with email + password.
  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  /// Register a new patient and write their profile to Firestore.
  Future<UserCredential> registerPatient({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final user = credential.user;
    if (user != null) {
      await _firestore.collection(patientsCollection).doc(user.uid).set(
            PatientModel(
              uid: user.uid,
              name: name.trim(),
              email: email.trim(),
              phone: phone.trim(),
            ).toJson(),
          );
      await user.updateDisplayName(name.trim());
    }
    return credential;
  }

  /// Register a new doctor and write their profile to Firestore.
  Future<UserCredential> registerDoctor({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String specialty,
    String bio = '',
    int experienceYears = 0,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final user = credential.user;
    if (user != null) {
      await _firestore.collection(doctorsCollection).doc(user.uid).set(
            DoctorModel(
              uid: user.uid,
              name: name.trim(),
              email: email.trim(),
              phone1: phone.trim(),
              specialization: specialty.trim(),
              bio: bio.trim(),
              rating: 0,
            ).toJson(),
          );
      await user.updateDisplayName(name.trim());
    }
    return credential;
  }

  /// Send a password-reset email.
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  /// Sign out the current user.
  Future<void> logout() async {
    await _auth.signOut();
  }

  /// Converts a FirebaseAuth error code into a human-readable message.
  String getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'email-already-in-use':
        return 'An account already exists with this email';
      case 'weak-password':
        return 'Password is too weak';
      case 'invalid-email':
        return 'Invalid email address';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      case 'network-request-failed':
        return 'Network error. Check your connection';
      case 'invalid-credential':
        return 'Invalid email or password';
      default:
        return 'An error occurred. Please try again';
    }
  }
}