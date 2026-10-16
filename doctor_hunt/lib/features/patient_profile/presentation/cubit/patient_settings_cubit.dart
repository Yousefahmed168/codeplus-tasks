import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/user_service.dart';
import '../../../../core/models/patient_model.dart';
import 'patient_settings_state.dart';

/// Owns the settings screen: stored preferences, the app version and the live
/// patient document behind the quick information card.
class PatientSettingsCubit extends Cubit<PatientSettingsState> {
  PatientSettingsCubit() : super(const PatientSettingsState());

  /// SharedPreferences key for the notifications switch.
  static const String notificationsKey = 'patient_notifications_enabled';

  final UserService _userService = sl<UserService>();
  final AuthService _authService = sl<AuthService>();

  StreamSubscription<PatientModel?>? _patientSubscription;

  /// Loads preferences, the app version and starts listening to the patient
  /// document. Safe to call from `create`.
  Future<void> loadSettings() async {
    emit(state.copyWith(isLoading: true));
    await _loadPreferences();
    await _loadAppVersion();
    _listenToPatient();
    if (isClosed) return;
    emit(state.copyWith(isLoading: false));
  }

  Future<void> _loadPreferences() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      if (isClosed) return;
      emit(
        state.copyWith(
          notificationsEnabled:
              preferences.getBool(notificationsKey) ?? true,
        ),
      );
    } catch (e) {
      debugPrint('PatientSettingsCubit: failed to read preferences: $e');
    }
  }

  Future<void> _loadAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      if (isClosed) return;
      emit(
        state.copyWith(
          appVersion: 'v${packageInfo.version}+${packageInfo.buildNumber}',
        ),
      );
    } catch (e) {
      debugPrint('PatientSettingsCubit: failed to read app version: $e');
    }
  }

  void _listenToPatient() {
    final uid = _authService.currentUser?.uid;
    if (uid == null) return;

    _patientSubscription?.cancel();
    _patientSubscription = _userService.streamPatient(uid).listen(
      (patient) {
        if (isClosed) return;
        emit(state.copyWith(patient: patient));
      },
      onError: (Object error) {
        if (isClosed) return;
        emit(state.copyWith(error: 'Failed to load your profile: $error'));
      },
    );
  }

  /// Persists the notifications switch.
  Future<void> toggleNotifications(bool enabled) async {
    emit(state.copyWith(notificationsEnabled: enabled));
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setBool(notificationsKey, enabled);
    } catch (e) {
      debugPrint('PatientSettingsCubit: failed to save notifications: $e');
    }
  }

  /// Signs the patient out and releases the patient subscription.
  Future<void> logout() async {
    emit(state.copyWith(isLoggingOut: true));
    try {
      await _patientSubscription?.cancel();
      _patientSubscription = null;
      await _authService.logout();
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(error: 'Failed to log out: $e'));
      }
    } finally {
      if (!isClosed) {
        emit(state.copyWith(isLoggingOut: false));
      }
    }
  }

  @override
  Future<void> close() {
    _patientSubscription?.cancel();
    return super.close();
  }
}
