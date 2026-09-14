import 'package:pocket_ledger_app/features/authentication/data/models/app_user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AppUserModel?> getCurrentser();
  Future<AppUserModel?> signUp({required String name, required String email, required String password});
  Future<AppUserModel?> login({required String email, required String password});
  Future<AppUserModel?> signInwithGoogle();
  Future<void> resetPassword({required String email});
  Future<void> logout();
  Future<void> deleteAccount();

}