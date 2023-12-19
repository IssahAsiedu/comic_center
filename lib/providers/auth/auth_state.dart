import 'package:comics_center/domain/user_data.dart';

abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthSuccess extends AuthState {
  final UserData user;

  const AuthSuccess(this.user);
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);
}
