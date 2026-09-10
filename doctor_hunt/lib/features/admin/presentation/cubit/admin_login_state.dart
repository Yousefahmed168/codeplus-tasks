import 'package:equatable/equatable.dart';

abstract class AdminLoginState extends Equatable {
  const AdminLoginState();

  @override
  List<Object?> get props => [];
}

class AdminLoginInitial extends AdminLoginState {}

class AdminLoginLoading extends AdminLoginState {}

class AdminLoginSuccess extends AdminLoginState {}

class AdminLoginError extends AdminLoginState {
  final String message;

  const AdminLoginError(this.message);

  @override
  List<Object?> get props => [message];
}
