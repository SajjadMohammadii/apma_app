// Authentication events for BLoC state management.
// Relates to: auth_bloc.dart, auth_state.dart, login_page.dart

import 'package:equatable/equatable.dart';

// Base class for all authentication events.
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

// Event triggered when user attempts to login manually.
class LoginEvent extends AuthEvent {
  final String username;
  final String password;

  const LoginEvent({required this.username, required this.password});

  @override
  List<Object> get props => [username, password];
}

// Event triggered when user logs out.
class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}

// Event to check current authentication status.
class CheckAuthStatusEvent extends AuthEvent {
  const CheckAuthStatusEvent();
}

// Event triggered for automatic login with saved credentials.
class AutoLoginEvent extends AuthEvent {
  final String username;
  final String password;

  const AutoLoginEvent({required this.username, required this.password});

  @override
  List<Object> get props => [username, password];
}
