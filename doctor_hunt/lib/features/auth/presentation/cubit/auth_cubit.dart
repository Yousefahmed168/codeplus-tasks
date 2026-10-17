import '../../../../core/di/service_locator.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/auth_service.dart';
import '../../../../core/enums/user_role.dart';
import '../../../../i18n/strings.g.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitialState());

  final _authService = sl<AuthService>();

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoadingState());
    try {
      await _authService.login(email: email, password: password);
      final user = _authService.currentUser;
      if (user != null) {
        final role = await _authService.getUserRole(user.uid);
        if (role == null) {
          await _authService.logout();
          emit(AuthErrorState(t.auth.errors.noAccountFound));
          return;
        }
        if (role == UserRole.admin) {
          await _authService.logout();
          emit(AuthErrorState(t.auth.errors.useAdminLogin));
          return;
        }
        emit(AuthLoginSuccessState(role.name));
      } else {
        emit(AuthErrorState(t.auth.errors.userNotFound));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthErrorState(_authService.getErrorMessage(e.code)));
    } catch (e) {
      debugPrint('AuthCubit: auth action failed: $e');
      emit(AuthErrorState(t.common.errorGeneric));
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    emit(AuthLoadingState());
    try {
      await _authService.sendPasswordResetEmail(email);
      emit(AuthPasswordResetSuccessState(t.auth.resetEmailSent));
    } on FirebaseAuthException catch (e) {
      emit(AuthErrorState(_authService.getErrorMessage(e.code)));
    } catch (e) {
      debugPrint('AuthCubit: auth action failed: $e');
      emit(AuthErrorState(t.common.errorGeneric));
    }
  }

  Future<void> loginWithGoogle() async {
    emit(AuthLoadingState());
    try {
      final role = await _authService.signInWithGoogle();
      if (role == null) {
        // User cancelled — silently return to initial state
        emit(AuthInitialState());
        return;
      }
      if (role == UserRole.admin) {
        await _authService.logout();
        emit(AuthErrorState(t.auth.errors.useAdminLogin));
        return;
      }
      emit(AuthLoginSuccessState(role.name));
    } on FirebaseAuthException catch (e) {
      emit(AuthErrorState(_authService.getErrorMessage(e.code)));
    } catch (e) {
      debugPrint('AuthCubit: auth action failed: $e');
      emit(AuthErrorState(t.common.errorGeneric));
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
      emit(AuthSuccessState(message: t.auth.registrationSuccessful));
    } on FirebaseAuthException catch (e) {
      emit(AuthErrorState(_authService.getErrorMessage(e.code)));
    } catch (e) {
      debugPrint('AuthCubit: auth action failed: $e');
      emit(AuthErrorState(t.common.errorGeneric));
    }
  }
}
