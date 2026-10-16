import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/services/admin_service.dart';
import '../../../../core/services/cloudinary_service.dart';

enum EditAdminProfileStatus { idle, saving, success, failed }

class EditAdminProfileState {
  const EditAdminProfileState({
    this.status = EditAdminProfileStatus.idle,
    this.imagePath,
    this.clinicLocation,
    this.emailChangeDetected = false,
    this.errorMessage,
  });

  final EditAdminProfileStatus status;

  /// Path of a freshly picked avatar, not yet uploaded.
  final String? imagePath;

  /// Central clinic location loaded from Firestore.
  final String? clinicLocation;

  /// Changing the account email requires re-authentication, which this screen
  /// cannot do — the profile is still saved, the user is just told about it.
  final bool emailChangeDetected;

  final String? errorMessage;
}

/// Owns the admin profile write: avatar upload, display-name/photo updates and
/// the central clinic location. The screen keeps only its controllers.
class EditAdminProfileCubit extends Cubit<EditAdminProfileState> {
  EditAdminProfileCubit() : super(const EditAdminProfileState());

  final AdminService _adminService = sl<AdminService>();
  final CloudinaryService _cloudinary = sl<CloudinaryService>();

  User? get _user => FirebaseAuth.instance.currentUser;

  Future<void> load() async {
    try {
      final location = await _adminService.getCentralClinicLocation();
      emit(
        EditAdminProfileState(
          status: state.status,
          imagePath: state.imagePath,
          clinicLocation: location,
        ),
      );
    } catch (e) {
      emit(
        EditAdminProfileState(
          status: EditAdminProfileStatus.failed,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> pickImage() async {
    try {
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picked == null) return;
      emit(
        EditAdminProfileState(
          status: state.status,
          imagePath: picked.path,
          clinicLocation: state.clinicLocation,
        ),
      );
    } catch (e) {
      emit(
        EditAdminProfileState(
          status: EditAdminProfileStatus.failed,
          imagePath: state.imagePath,
          clinicLocation: state.clinicLocation,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> save({
    required String name,
    required String email,
    required String clinicLocation,
  }) async {
    final user = _user;
    if (user == null) return;

    emit(
      EditAdminProfileState(
        status: EditAdminProfileStatus.saving,
        imagePath: state.imagePath,
        clinicLocation: state.clinicLocation,
      ),
    );

    try {
      String? photoUrl;
      final imagePath = state.imagePath;
      if (imagePath != null) {
        photoUrl = await _cloudinary.uploadImage(
          filePath: imagePath,
          folder: 'admin_profiles',
        );
      }

      if (name != user.displayName) {
        await user.updateDisplayName(name);
      }
      if (photoUrl != null) {
        await user.updatePhotoURL(photoUrl);
      }

      // A changed email needs a fresh sign-in. Firebase sends a verification
      // link and only applies the change after the user confirms it.
      var emailChanged = false;
      if (email.isNotEmpty && email != user.email) {
        emailChanged = true;
        try {
          await user.verifyBeforeUpdateEmail(email);
        } on FirebaseAuthException catch (e) {
          // Stale sessions cannot change the email; surface it via the state
          // (the screen shows the re-auth warning) instead of failing the save.
          if (e.code != 'requires-recent-login') rethrow;
        }
      }

      if (clinicLocation.isNotEmpty) {
        await _adminService.updateCentralClinicLocation(clinicLocation);
      }

      emit(
        EditAdminProfileState(
          status: EditAdminProfileStatus.success,
          imagePath: state.imagePath,
          clinicLocation: clinicLocation,
          emailChangeDetected: emailChanged,
        ),
      );
    } catch (e) {
      emit(
        EditAdminProfileState(
          status: EditAdminProfileStatus.failed,
          imagePath: state.imagePath,
          clinicLocation: state.clinicLocation,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
