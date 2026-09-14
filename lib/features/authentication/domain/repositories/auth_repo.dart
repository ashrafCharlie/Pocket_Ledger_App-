import 'package:pocket_ledger_app/features/authentication/domain/entities/app_user_entity.dart';

abstract class AuthRepo {
  Future<AppUser?> getCurrentUser();
  Future<AppUser?> signUp({required String name, required String email, required String password});
  Future<AppUser?> login({required String email, required String password});
  Future<AppUser?> signInwithGoogle();
  Future<void> resetPassword({required String email});
  Future<void> logout();
  Future<void> deleteAccount();
}