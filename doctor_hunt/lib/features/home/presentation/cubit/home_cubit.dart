import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/user_service.dart';
import '../../../../core/services/favorite_service.dart';
import '../../../../features/auth/data/models/patient_model.dart';
import '../../../../features/doctors/models/doctor.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final UserService _userService = UserService.instance;
  final AuthService _authService = AuthService.instance;
  final FavoriteService _favoriteService = FavoriteService.instance;

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
      onError: (e) => emit(HomeError('Failed to load doctors: $e')),
    );

    if (uid != null) {
      _patientSub = _userService.streamPatient(uid).listen(
        (patient) {
          _currentPatient = patient;
          _emitLoaded();
        },
        onError: (e) => emit(HomeError('Failed to load patient: $e')),
      );

      _favoritesSub = _favoriteService.streamFavoriteIds(uid).listen(
        (favorites) {
          _currentFavorites = favorites;
          _emitLoaded();
        },
        onError: (e) => emit(HomeError('Failed to load favorites: $e')),
      );
    } else {
      _emitLoaded();
    }
  }
  
  void _emitLoaded() {
    emit(HomeLoaded(
      patient: _currentPatient,
      doctors: _currentDoctors,
      favoriteIds: _currentFavorites,
    ));
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
