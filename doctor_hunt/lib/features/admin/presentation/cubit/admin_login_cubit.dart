import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../i18n/strings.g.dart';
import 'admin_login_state.dart';

class AdminLoginCubit extends Cubit<AdminLoginState> {
  final AuthService _authService = sl<AuthService>();

  AdminLoginCubit() : super(AdminLoginInitial());

  Future<void> login(String email, String password) async {
    emit(AdminLoginLoading());
    try {
      await _authService.loginAdmin(email: email, password: password);
      emit(AdminLoginSuccess());
    } on FirebaseAuthException catch (e) {
      emit(AdminLoginError(_authService.getErrorMessage(e.code)));
    } catch (e) {
      debugPrint('AdminLoginCubit: login failed: $e');
      emit(AdminLoginError(t.common.errorGeneric));
    }
  }
}
