import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/favorite_service.dart';
import '../../../../core/services/user_service.dart';
import '../../../../core/models/patient_model.dart';
import '../../../../core/models/doctor.dart';
import '../../../../i18n/strings.g.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final UserService _userService = sl<UserService>();
  final AuthService _authService = sl<AuthService>();
  final FavoriteService _favoriteService = sl<FavoriteService>();

  StreamSubscription? _patientSub;
  StreamSubscription? _doctorsSub;
  StreamSubscription? _favoritesSub;

  PatientModel? _currentPatient;
  List<Doctor> _currentDoctors = [];
  Set<String> _currentFavorites = {};

  HomeCubit() : super(HomeLoading());

  void loadHomeData() {
    emit(HomeLoading());
    final uid = _authService.currentUser?.uid;

    _patientSub?.cancel();
    _doctorsSub?.cancel();
    _favoritesSub?.cancel();

    _doctorsSub = _userService.streamDoctors().listen(
      (doctors) {
        _currentDoctors = doctors;
        _emitLoaded();
      },
      onError: (e) {
        debugPrint('HomeCubit: failed to load doctors: $e');
        emit(HomeError(t.common.errorGeneric));
      },
    );

    if (uid != null) {
      _patientSub = _userService.streamPatient(uid).listen(
        (patient) {
          _currentPatient = patient;
          _emitLoaded();
        },
        onError: (e) {
          debugPrint('HomeCubit: failed to load patient: $e');
          emit(HomeError(t.common.errorGeneric));
        },
      );

      _favoritesSub = _favoriteService.streamFavoriteIds(uid).listen(
        (favorites) {
          _currentFavorites = favorites;
          _emitLoaded();
        },
        onError: (e) {
          debugPrint('HomeCubit: failed to load favorites: $e');
          emit(HomeError(t.common.errorGeneric));
        },
      );
    } else {
      _emitLoaded();
    }
  }
  
  void _emitLoaded() {
    // Popular = most reviewed, Top Rated = highest rating (locked MVP scope).
    final popular = [..._currentDoctors]
      ..sort((a, b) => b.reviewsCount.compareTo(a.reviewsCount));
    final topRated = [..._currentDoctors]
      ..sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));

    emit(
      HomeLoaded(
        patient: _currentPatient,
        doctors: _currentDoctors,
        popularDoctors: popular,
        topRatedDoctors: topRated,
        favoriteIds: _currentFavorites,
      ),
    );
  }

  Future<void> toggleFavorite(String doctorUid) async {
    final uid = _authService.currentUser?.uid;
    if (uid != null) {
      await _favoriteService.toggleFavorite(patientUid: uid, doctorUid: doctorUid);
    }
  }

  @override
  Future<void> close() {
    _patientSub?.cancel();
    _doctorsSub?.cancel();
    _favoritesSub?.cancel();
    return super.close();
  }
}
