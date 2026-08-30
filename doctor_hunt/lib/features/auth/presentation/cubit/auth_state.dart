/// States for the AuthCubit.
abstract class AuthState {}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthSuccessState extends AuthState {
  final String? message;
  AuthSuccessState({this.message});
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
