import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User user;

  AuthSuccess(this.user);
}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}
