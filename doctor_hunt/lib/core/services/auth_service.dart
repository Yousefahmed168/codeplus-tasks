import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../core/models/patient_model.dart';
import '../../core/enums/user_role.dart';
import '../../i18n/strings.g.dart';

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

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> logout() async {
    // Sign out from Google to clear the cached OAuth token.
    // disconnect() revokes access so the account-picker is shown on next sign-in.
    try {
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
        await _googleSignIn.disconnect();
      }
    } catch (e) {
      debugPrint('AuthService.logout Google sign-out error: $e');
    }
    await _auth.signOut();
  }

  /// Maps a Firebase Auth error [code] to a localized, user-facing message.
  String getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return t.auth.errors.noAccountFound;
      case 'wrong-password':
      case 'invalid-credential':
        return t.auth.errors.invalidCredentials;
      case 'email-already-in-use':
        return t.auth.errors.emailAlreadyInUse;
      case 'weak-password':
        return t.auth.errors.weakPassword;
      case 'invalid-email':
        return t.auth.errors.invalidEmail;
      case 'user-disabled':
        return t.auth.errors.userDisabled;
      case 'too-many-requests':
        return t.auth.errors.tooManyRequests;
      case 'network-request-failed':
        return t.auth.errors.networkRequestFailed;
      default:
        return t.common.errorGeneric;
    }
  }
}