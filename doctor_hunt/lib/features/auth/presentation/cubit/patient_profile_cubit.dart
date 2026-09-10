import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/user_service.dart';
import '../../../../core/services/cloudinary_service.dart';
import '../../data/models/patient_model.dart';
import '../../data/models/user_model.dart';
import 'patient_profile_state.dart';

class PatientProfileCubit extends Cubit<PatientProfileState> {
  final UserService _userService = UserService.instance;
  final AuthService _authService = AuthService.instance;
  final CloudinaryService _cloudinaryService = CloudinaryService.instance;
  
  StreamSubscription<PatientModel?>? _patientSubscription;

  PatientProfileCubit() : super(PatientProfileInitial());

  void loadProfile() {
    emit(PatientProfileLoading());
    final uid = _authService.currentUser?.uid;
    if (uid == null) {
      emit(const PatientProfileError('User not logged in'));
      return;
    }

    _patientSubscription?.cancel();
    _patientSubscription = _userService.streamPatient(uid).listen(
      (patient) {
        if (patient != null) {
          emit(PatientProfileLoaded(patient: patient));
        } else {
          emit(const PatientProfileError('Patient profile not found'));
        }
      },
      onError: (error) {
        emit(PatientProfileError('Failed to load profile: $error'));
      },
    );
  }

  Future<void> updateProfile({
    required PatientModel currentPatient,
    String? name,
    String? phone,
    String? age,
    String? city,
    String? bio,
    int? gender,
    String? localImagePath,
  }) async {
    final uid = _authService.currentUser?.uid;
    if (uid == null) return;
    
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
        age: age?.trim().isEmpty == true ? null : age?.trim(),
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
      
      // We don't need to emit Loaded here since the stream will push the new data,
      // but emitting success/loaded ensures UI unblocks immediately.
      // Wait for stream to update naturally.
    } catch (e) {
      emit(PatientProfileError('Failed to update profile: $e'));
      // Revert to loaded state after showing error
      emit(PatientProfileLoaded(patient: currentPatient));
    }
  }
  
  Future<void> logout() async {
    await _authService.logout();
  }

  @override
  Future<void> close() {
    _patientSubscription?.cancel();
    return super.close();
  }
}
