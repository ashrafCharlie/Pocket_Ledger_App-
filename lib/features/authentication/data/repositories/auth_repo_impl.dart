import 'package:pocket_ledger_app/features/authentication/data/datasource/auth_remote_datasource.dart';
import 'package:pocket_ledger_app/features/authentication/domain/entities/app_user_entity.dart';
import 'package:pocket_ledger_app/features/authentication/domain/repositories/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource authRemoteDataSource;
  AuthRepoImpl({required this.authRemoteDataSource});

  @override
  Future<AppUser?> getCurrentUser() async {
    return await authRemoteDataSource.getCurrentser();
  }

  @override
  Future<AppUser?> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    return await authRemoteDataSource.signUp(name: name, email: email, password: password);
  }

  @override
  Future<AppUser?> login({
    required String email,
    required String password,
  }) async {
    return await authRemoteDataSource.login(email: email, password: password);
  }

  @override
  Future<void> resetPassword({required String email}) async {
    await authRemoteDataSource.resetPassword(email: email);
  }

  @override
  Future<AppUser?> signInwithGoogle() async {
   return await authRemoteDataSource.signInwithGoogle();
  }

  @override
  Future<void> logout() async {
    await authRemoteDataSource.logout();
  }

  @override
  Future<void> deleteAccount() async {
    await authRemoteDataSource.deleteAccount();
  }
}