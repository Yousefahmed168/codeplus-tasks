import 'dart:io';

import 'package:doctor_hunt/core/services/image_uploader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/auth_service.dart';
import '../../../../core/services/user_service.dart';
import '../../../doctors/models/doctor_model.dart';
import '../../models/user_model.dart';
import 'auth_state.dart';

/// Cubit that manages doctor profile creation and update.
///
/// Handles image picking, Cloudinary upload, form state, and Firestore writes.
class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitialState());

  final _authService = AuthService.instance;
  final _userService = UserService.instance;
  final _cloudinary = uploadImageToCloudinary;

  // ── Form key ──────────────────────────────────────────────────────────
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // ── Controllers ───────────────────────────────────────────────────────
  final TextEditingController bioController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController openHourController = TextEditingController();
  final TextEditingController closeHourController = TextEditingController();
  final TextEditingController phone1Controller = TextEditingController();
  final TextEditingController phone2Controller = TextEditingController();

  // ── State fields ──────────────────────────────────────────────────────
  String? specialization;
  File? imageFile;
  String? _existingImageUrl;

  /// Current user's UID, resolved from Firebase Auth.
  String? get _uid => _authService.currentUser?.uid;

  // ── Initialize from existing profile (for editing) ────────────────────
  /// Loads the current doctor's profile data into the controllers.
  Future<void> loadCurrentProfile() async {
    if (_uid == null) {
      emit(AuthErrorState('No signed-in user'));
      return;
    }

    emit(AuthLoadingState());
    try {
      final user = await _userService.getUser(_uid!);
      if (user is DoctorModel) {
        bioController.text = user.bio ?? '';
        addressController.text = user.address ?? '';
        openHourController.text = user.openHour ?? '';
        closeHourController.text = user.closeHour ?? '';
        phone1Controller.text = user.phone1 ?? '';
        phone2Controller.text = user.phone2 ?? '';
        specialization = user.specialization;
        _existingImageUrl = user.imageUrl;
        emit(AuthInitialState());
      } else {
        emit(AuthErrorState('Profile not found'));
      }
    } catch (e) {
      emit(AuthErrorState('Failed to load profile: $e'));
    }
  }

  // ── Image handling ────────────────────────────────────────────────────
  /// Sets the picked image file. Call this from the image picker callback.
  void setImage(File file) {
    imageFile = file;
    emit(AuthInitialState());
  }

  /// Uploads the picked image to Cloudinary and returns the secure URL.
  Future<String?> _uploadImageToCloudinary() async {
    if (imageFile == null) return _existingImageUrl;

    try {
      final url = await _cloudinary(imageFile!);
      return url;
    } catch (e) {
      debugPrint('Cloudinary upload failed: $e');
      return null;
    }
  }

  // ── Update doctor profile ─────────────────────────────────────────────
  /// Uploads the image to Cloudinary, then updates the Firestore document.
  Future<void> updateDoctor() async {
    if (_uid == null) {
      emit(AuthErrorState('No signed-in user'));
      return;
    }

    emit(AuthLoadingState());

    try {
      // 1. Upload image if one was picked
      final imageUrl = await _uploadImageToCloudinary();

      // 2. Build the update map
      final updateData = <String, dynamic>{
        'bio': bioController.text.trim(),
        'address': addressController.text.trim(),
        'openHour': openHourController.text.trim(),
        'closeHour': closeHourController.text.trim(),
        'phone1': phone1Controller.text.trim(),
        'phone2': phone2Controller.text.trim(),
        'specialization': specialization,
      };

      if (imageUrl != null) {
        updateData['image'] = imageUrl;
      }

      // 3. Write to Firestore
      await _userService.updateUser(
        _uid!,
        updateData,
        role: UserRole.doctor,
      );

      emit(AuthSuccessState(message: 'Profile updated successfully'));
    } catch (e) {
      emit(AuthErrorState('Failed to update profile: $e'));
    }
  }

  // ── Register new doctor ───────────────────────────────────────────────
  /// Registers a new doctor, uploads image, then creates the Firestore doc.
  Future<void> registerDoctor({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    if (specialization == null || specialization!.isEmpty) {
      emit(AuthErrorState('Please select a specialization'));
      return;
    }

    emit(AuthLoadingState());

    try {
      // 1. Register with Firebase Auth
      final credential = await _authService.registerDoctor(
        name: name,
        email: email,
        password: password,
        phone: phone,
        specialty: specialization!,
        bio: bioController.text.trim(),
      );

      final user = credential.user;
      if (user == null) {
        emit(AuthErrorState('Registration failed'));
        return;
      }

      // 2. Upload image if picked
      final imageUrl = await _uploadImageToCloudinary();

      // 3. Update the Firestore doc with additional fields
      final updateData = <String, dynamic>{
        'bio': bioController.text.trim(),
        'address': addressController.text.trim(),
        'openHour': openHourController.text.trim(),
        'closeHour': closeHourController.text.trim(),
        'phone1': phone1Controller.text.trim(),
        'phone2': phone2Controller.text.trim(),
        'specialization': specialization,
      };

      if (imageUrl != null) {
        updateData['image'] = imageUrl;
      }

      await _userService.updateUser(
        user.uid,
        updateData,
        role: UserRole.doctor,
      );

      emit(AuthSuccessState(message: 'Registration successful'));
    } catch (e) {
      emit(AuthErrorState('Registration failed: $e'));
    }
  }

  @override
  Future<void> close() {
    bioController.dispose();
    addressController.dispose();
    openHourController.dispose();
    closeHourController.dispose();
    phone1Controller.dispose();
    phone2Controller.dispose();
    return super.close();
  }
}
