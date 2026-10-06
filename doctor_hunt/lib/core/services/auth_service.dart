import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../features/doctors/models/doctor.dart';
import '../../features/auth/data/models/patient_model.dart';
import '../../features/auth/data/models/user_model.dart';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  static const String patientsCollection = 'patients';
  static const String doctorsCollection = 'doctors';
  static const String adminsCollection = 'admins';

  static String collectionForRole(UserRole role) {
    return role == UserRole.doctor ? doctorsCollection : patientsCollection;
  }

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Signs in with Google and returns the [UserRole] detected for the account.
  /// New Google users are registered as patients automatically.
  Future<UserRole?> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      // User cancelled the sign-in dialog
      return null;
    }

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    final user = userCredential.user;
    if (user == null) throw Exception('Google sign-in failed: no user returned');

    // Determine if the account already exists in Firestore
    final role = await getUserRole(user.uid);
    if (role == null) {
      // New user — register as a patient
      await _firestore.collection(patientsCollection).doc(user.uid).set(
            PatientModel(
              uid: user.uid,
              name: user.displayName ?? googleUser.displayName ?? '',
              email: user.email ?? googleUser.email,
              phone: '',
            ).toJson(),
          );
      return UserRole.patient;
    }
    return role;
  }



  Future<UserRole?> getUserRole(String uid) async {
    try {
      final doctorDoc =
          await _firestore.collection(doctorsCollection).doc(uid).get();
      if (doctorDoc.exists) return UserRole.doctor;

      final patientDoc =
          await _firestore.collection(patientsCollection).doc(uid).get();
      if (patientDoc.exists) return UserRole.patient;

      final adminDoc =
          await _firestore.collection(adminsCollection).doc(uid).get();
      if (adminDoc.exists) return UserRole.admin;

      return null;
    } catch (e) {
      debugPrint('AuthService.getUserRole error: $e');
      return null;
    }
  }

  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<UserCredential> loginAdmin({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final uid = credential.user!.uid;
    final adminDoc = await _firestore.collection(adminsCollection).doc(uid).get();
    if (!adminDoc.exists) {
      await _auth.signOut();
      throw Exception('Access denied. You are not an admin.');
    }
    return credential;
  }

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
            Doctor(
              uid: user.uid,
              name: name.trim(),
             
              specialization: specialty.trim(),
              rating: 0,
            ).toJson(),
          );
      await user.updateDisplayName(name.trim());
    }
    return credential;
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> logout() async {
    // Sign out from Google to clear the cached OAuth token.
    // disconnect() revokes access so the account-picker is shown on next sign-in.
    if (await _googleSignIn.isSignedIn()) {
      await _googleSignIn.signOut();
      await _googleSignIn.disconnect();
    }
    await _auth.signOut();
  }

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