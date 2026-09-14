
import 'package:equatable/equatable.dart';

sealed class AuthEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class CheckAuthStatusEvent extends AuthEvent {}

class SignUpEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;
  SignUpEvent({
    required this.name,
    required this.email,
    required this.password,
  });
  @override
  List<Object?> get props => [name,email,password];
}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;
  SignInEvent({required this.email, required this.password});
  @override
  List<Object?> get props => [email,password];
}

class LogoutEvent extends AuthEvent {}

class AccoutDeleteEvent extends AuthEvent {}

class ResetAccountEvent extends AuthEvent {
  final String email;
  ResetAccountEvent({required this.email});
  @override
  List<Object?> get props => [email];
}

class SignInWithGoolge extends AuthEvent{}