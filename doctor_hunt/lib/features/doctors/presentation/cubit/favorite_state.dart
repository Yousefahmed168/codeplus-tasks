import 'package:flutter/foundation.dart';
import '../../models/doctor.dart';

@immutable
abstract class FavoriteState {}

class FavoriteInitial extends FavoriteState {}
class FavoriteLoading extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  final List<Doctor> favoriteDoctors;
  FavoriteLoaded(this.favoriteDoctors);
}

class FavoriteError extends FavoriteState {
  final String message;
  FavoriteError(this.message);
}
