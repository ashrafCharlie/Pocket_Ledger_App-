import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pocket_ledger_app/features/authentication/domain/repositories/auth_repo.dart';
import 'package:pocket_ledger_app/features/authentication/presentation/bloc/auth_event.dart';
import 'package:pocket_ledger_app/features/authentication/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepo authRepo;
  AuthBloc({required this.authRepo}) : super(AuthInitState()) {
    //check Auth status
    on<CheckAuthStatusEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        final user = await authRepo.getCurrentUser();
        if (user == null) {
          emit(UnAuthenticateState());
        } else {
          emit(AuthenticateState(user: user));
        }
      } catch (e) {
        emit(AuthErrorState(errorMsg: e.toString()));
      }
    });

    //signup
    on<SignUpEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        final user = await authRepo.signUp(
          name: event.name,
          email: event.email,
          password: event.password,
        );

        if (user != null) {
          emit(AuthenticateState(user: user));
        } else {
          emit(UnAuthenticateState());
        }
      } catch (e) {
        emit(AuthErrorState(errorMsg: e.toString()));
      }
    });

    //sign in
    on<SignInEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        final user = await authRepo.login(
          email: event.email,
          password: event.password,
        );
        if (user != null) {
          emit(AuthenticateState(user: user));
        } else {
          emit(UnAuthenticateState());
        }
      } catch (e) {
        emit(AuthErrorState(errorMsg: e.toString()));
      }
    });

    //signin with google
    on<SignInWithGoolge>((event, emit) async {
      emit(AuthLoadingState());
      try {
        final user = await authRepo.signInwithGoogle();
        if (user != null) {
          emit(AuthenticateState(user: user));
        } else {
          emit(UnAuthenticateState());
        }
      } catch (e) {
        emit(AuthErrorState(errorMsg: e.toString()));
      }
    });

    //logout
    on<LogoutEvent>((event, emit) async {
      try {
        await authRepo.logout();
        emit(UnAuthenticateState());
      } catch (e) {
        emit(AuthErrorState(errorMsg: e.toString()));
      }
    });

    //forget password
    on<ResetAccountEvent>((event, emit) async {
      try {
        await authRepo.resetPassword(email: event.email);
      } catch (e) {
        emit(AuthErrorState(errorMsg: e.toString()));
      }
    });

    //Delete Account
    on<AccoutDeleteEvent>((event, emit) async {
      try {
        await authRepo.deleteAccount();
        emit(UnAuthenticateState());
      } catch (e) {
        emit(AuthErrorState(errorMsg: e.toString()));
      }
    });
  }
}