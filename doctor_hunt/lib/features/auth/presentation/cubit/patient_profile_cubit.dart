import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/cloudinary_service.dart';
import '../../../../core/services/user_service.dart';
import '../../../../core/models/patient_model.dart';
import '../../../../core/enums/user_role.dart';
import '../../../../i18n/strings.g.dart';
import 'patient_profile_state.dart';

class PatientProfileCubit extends Cubit<PatientProfileState> {
  final UserService _userService = sl<UserService>();
  final AuthService _authService = sl<AuthService>();
  final CloudinaryService _cloudinaryService = sl<CloudinaryService>();
  
  StreamSubscription<PatientModel?>? _patientSubscription;

  PatientProfileCubit() : super(PatientProfileInitial());

  void loadProfile() {
    emit(PatientProfileLoading());
    final uid = _authService.currentUser?.uid;
    if (uid == null) {
      emit(PatientProfileError(t.common.errorGeneric));
      return;
    }

    _patientSubscription?.cancel();
    _patientSubscription = _userService.streamPatient(uid).listen(
      (patient) {
        if (patient != null) {
          emit(PatientProfileLoaded(patient: patient));
        } else {
          emit(PatientProfileError(t.common.errorGeneric));
        }
      },
      onError: (error) {
        debugPrint('PatientProfileCubit: failed to load profile: $error');
        emit(PatientProfileError(t.common.errorGeneric));
      },
    );
  }

  /// Updates the patient document and returns whether the write succeeded.
  Future<bool> updateProfile({
    required PatientModel currentPatient,
    String? name,
    String? phone,
    String? dob,
    String? city,
    String? bio,
    int? gender,
    String? localImagePath,
  }) async {
    final uid = _authService.currentUser?.uid;
    if (uid == null) return false;
    
    emit(PatientProfileSaving(patient: currentPatient));
    
    try {
      String? imageUrl = currentPatient.image;

      if (localImagePath != null) {
        imageUrl = await _cloudinaryService.uploadImage(
          filePath: localImagePath,
          folder: 'patients',
        );
      }

      final updated = PatientModel(
        uid: uid,
        email: currentPatient.email,
        name: name?.trim().isEmpty == true ? null : name?.trim(),
        phone: phone?.trim().isEmpty == true ? null : phone?.trim(),
        dob: dob?.trim().isEmpty == true ? null : dob?.trim(),
        city: city?.trim().isEmpty == true ? null : city?.trim(),
        bio: bio?.trim().isEmpty == true ? null : bio?.trim(),
        gender: gender,
        image: imageUrl,
      );

      await _userService.updateUser(
        uid,
        updated.toUpdateData(),
        role: UserRole.patient,
      );

      // Always exit the transient saving state. Relying on the Firestore stream
      // to push the new document is unsafe: a write that does not change any
      // field emits no snapshot, which would leave the UI stuck on "Loading...".
      if (isClosed) return true;
      emit(PatientProfileLoaded(patient: updated));
      return true;
    } catch (e) {
      debugPrint('PatientProfileCubit: failed to update profile: $e');
      emit(PatientProfileError(t.common.errorGeneric));
      // Revert to loaded state after showing error
      emit(PatientProfileLoaded(patient: currentPatient));
      return false;
    }
  }
  
  Future<void> logout() async {
    await _patientSubscription?.cancel();
    _patientSubscription = null;
    await _authService.logout();
  }

  @override
  Future<void> close() {
    _patientSubscription?.cancel();
    return super.close();
  }
}
