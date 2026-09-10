import 'dart:io';

import 'package:doctor_hunt/core/services/image_uploader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/auth_service.dart';
import '../../../../core/services/user_service.dart';
import '../../../doctors/models/doctor.dart';
import '../../data/models/user_model.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitialState());

  final _authService = AuthService.instance;
  final _userService = UserService.instance;
  final _cloudinary = uploadImageToCloudinary;

  //  State fields 
  File? imageFile;
  String? _existingImageUrl;

  String? get _uid => _authService.currentUser?.uid;

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoadingState());
    try {
      await _authService.login(email: email, password: password);
      final user = _authService.currentUser;
      if (user != null) {
        final role = await _authService.getUserRole(user.uid);
        emit(AuthLoginSuccessState(role?.name));
      } else {
        emit(AuthErrorState('User not found after login'));
      }
    } catch (e) {
      emit(AuthErrorState(_authService.getErrorMessage(e.toString())));
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    emit(AuthLoadingState());
    try {
      await _authService.sendPasswordResetEmail(email);
      emit(AuthPasswordResetSuccessState('Password reset email sent'));
    } catch (e) {
      emit(AuthErrorState(_authService.getErrorMessage(e.toString())));
    }
  }

  Future<void> loadCurrentProfile() async {
    if (_uid == null) {
      emit(AuthErrorState('No signed-in user'));
      return;
    }

    emit(AuthLoadingState());
    try {
      final user = await _userService.getUser(_uid!);
      if (user is Doctor) {
        _existingImageUrl = user.imageUrl;
        emit(AuthProfileLoadedState(user));
      } else {
        emit(AuthErrorState('Profile not found'));
      }
    } catch (e) {
      emit(AuthErrorState('Failed to load profile: $e'));
    }
  }

  void setImage(File file) {
    imageFile = file;
    emit(AuthInitialState());
  }

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

  Future<void> updateDoctor({
    required String bio,
    required String address,
    required String openHour,
    required String closeHour,
    required String phone1,
    required String phone2,
    required String? specialization,
  }) async {
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
        'bio': bio.trim(),
        'address': address.trim(),
        'openHour': openHour.trim(),
        'closeHour': closeHour.trim(),
        'phone1': phone1.trim(),
        'phone2': phone2.trim(),
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

  Future<void> registerDoctor({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String specialty,
    required String bio,
    required int experienceYears,
  }) async {
    emit(AuthLoadingState());
    try {
      await _authService.registerDoctor(
        name: name,
        email: email,
        password: password,
        phone: phone,
        specialty: specialty,
        bio: bio,
        experienceYears: experienceYears,
      );
      emit(AuthSuccessState(message: 'Registration successful'));
    } catch (e) {
      emit(AuthErrorState(_authService.getErrorMessage(e.toString())));
    }
  }

  Future<void> registerPatient({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    emit(AuthLoadingState());
    try {
      await _authService.registerPatient(
        name: name,
        email: email,
        password: password,
        phone: phone,
      );
      emit(AuthSuccessState(message: 'Registration successful'));
    } catch (e) {
      emit(AuthErrorState(_authService.getErrorMessage(e.toString())));
    }
  }

}
