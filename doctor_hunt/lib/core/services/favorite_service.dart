import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'auth_service.dart';


class FavoriteService {
  FavoriteService._();
  static final FavoriteService instance = FavoriteService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _favoritesRef(String patientUid) {
    return _firestore
        .collection(AuthService.patientsCollection)
        .doc(patientUid)
        .collection('favorites');
  }

  Stream<Set<String>> streamFavoriteIds(String patientUid) {
    return _favoritesRef(patientUid).snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => doc.id).toSet(),
        );
  }

  Future<bool> isFavorited({
    required String patientUid,
    required String doctorUid,
  }) async {
    try {
      final doc = await _favoritesRef(patientUid).doc(doctorUid).get();
      return doc.exists;
    } catch (e) {
      debugPrint('FavoriteService.isFavorited error: $e');
      return false;
    }
  }

  Future<bool> toggleFavorite({
    required String patientUid,
    required String doctorUid,
  }) async {
    try {
      final docRef = _favoritesRef(patientUid).doc(doctorUid);
      final doc = await docRef.get();

      if (doc.exists) {
        // Remove from favorites
        await docRef.delete();
        return false;
      } else {
        // Add to favorites
        await docRef.set({
          'addedAt': FieldValue.serverTimestamp(),
        });
        return true;
      }
    } catch (e) {
      debugPrint('FavoriteService.toggleFavorite error: $e');
      rethrow;
    }
  }

  Future<void> addFavorite({
    required String patientUid,
    required String doctorUid,
  }) async {
    try {
      await _favoritesRef(patientUid).doc(doctorUid).set({
        'addedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('FavoriteService.addFavorite error: $e');
      rethrow;
    }
  }

  Future<void> removeFavorite({
    required String patientUid,
    required String doctorUid,
  }) async {
    try {
      await _favoritesRef(patientUid).doc(doctorUid).delete();
    } catch (e) {
      debugPrint('FavoriteService.removeFavorite error: $e');
      rethrow;
    }
  }
}
