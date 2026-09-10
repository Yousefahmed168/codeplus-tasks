import '../../../doctors/models/doctor.dart';

/// States for the AuthCubit.
abstract class AuthState {}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthSuccessState extends AuthState {
  final String? message;
  AuthSuccessState({this.message});
}

class AuthLoginSuccessState extends AuthState {
  final String? roleName;
  AuthLoginSuccessState(this.roleName);
}

class AuthPasswordResetSuccessState extends AuthState {
  final String message;
  AuthPasswordResetSuccessState(this.message);
}

class AuthErrorState extends AuthState {
  final String error;
  AuthErrorState(this.error);
}

class AuthImagePickedState extends AuthState {
  final String imagePath;
  AuthImagePickedState(this.imagePath);
}

class AuthProfileUpdatedState extends AuthState {
  AuthProfileUpdatedState();
}

class AuthProfileLoadedState extends AuthState {
  final Doctor doctorData;
  AuthProfileLoadedState(this.doctorData);
}
