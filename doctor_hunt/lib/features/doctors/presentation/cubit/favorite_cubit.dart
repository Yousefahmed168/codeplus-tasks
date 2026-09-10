import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/user_service.dart';
import '../../../../core/services/favorite_service.dart';
import 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final _userService = UserService.instance;
  final _authService = AuthService.instance;
  final _favoriteService = FavoriteService.instance;

  StreamSubscription? _doctorsSub;
  StreamSubscription? _favoritesSub;

  FavoriteCubit() : super(FavoriteInitial());

  void loadFavorites() {
    final uid = _authService.currentUser?.uid;
    if (uid == null) {
      emit(FavoriteError('Not logged in'));
      return;
    }

    emit(FavoriteLoading());

    _doctorsSub?.cancel();
    _favoritesSub?.cancel();

    Set<String> currentFavoriteIds = {};
    List<dynamic> allDoctors = []; // using dynamic temporarily, will cast to List<Doctor>

    void emitIfReady() {
      if (allDoctors.isNotEmpty) {
        final favoriteDoctors = allDoctors
            .where((d) => d.uid != null && currentFavoriteIds.contains(d.uid))
            .toList();
        emit(FavoriteLoaded(favoriteDoctors.cast()));
      } else {
        emit(FavoriteLoaded([]));
      }
    }

    _favoritesSub = _favoriteService.streamFavoriteIds(uid).listen(
      (favorites) {
        currentFavoriteIds = favorites;
        emitIfReady();
      },
      onError: (e) => emit(FavoriteError('Failed to load favorites: $e')),
    );

    _doctorsSub = _userService.streamDoctors().listen(
      (doctors) {
        allDoctors = doctors;
        emitIfReady();
      },
      onError: (e) => emit(FavoriteError('Failed to load doctors: $e')),
    );
  }

  Future<void> removeFavorite(String doctorUid) async {
    final uid = _authService.currentUser?.uid;
    if (uid != null) {
      await _favoriteService.toggleFavorite(patientUid: uid, doctorUid: doctorUid);
    }
  }

  Future<void> addFavorite(String doctorUid) async {
    final uid = _authService.currentUser?.uid;
    if (uid != null) {
      await _favoriteService.addFavorite(patientUid: uid, doctorUid: doctorUid);
    }
  }

  @override
  Future<void> close() {
    _doctorsSub?.cancel();
    _favoritesSub?.cancel();
    return super.close();
  }
}
