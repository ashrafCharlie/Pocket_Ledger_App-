import 'package:equatable/equatable.dart';
import 'package:pocket_ledger_app/features/authentication/domain/entities/app_user_entity.dart';

sealed class AuthState  extends Equatable{
  @override
  List<Object?> get props => [];
}

class AuthInitState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthenticateState extends AuthState {
  final AppUser user;
  AuthenticateState({required this.user});
  @override
  List<Object?> get props => [user];
}

class UnAuthenticateState extends AuthState {}

class AuthErrorState extends AuthState {
  final String errorMsg;
  AuthErrorState({required this.errorMsg});
  @override
  List<Object?> get props => [errorMsg];
}