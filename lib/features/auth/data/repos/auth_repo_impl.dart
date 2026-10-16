import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure/failure.dart';
import '../../../../core/errors/handler/error_handler.dart';
import '../../../../core/storage/token_storage.dart';
import '../../domain/repos/auth_repo.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource _remote;
  final TokenStorage _storage;
  AuthRepoImpl(this._remote, this._storage);

  @override
  Future<Either<Failure, Unit>> login(String email, String password) async {
    try {
      final token = await _remote.login(email, password);
      await _storage.save(token);
      return const Right(unit);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> register(
      String name, String email, String password) async {
    try {
      await _remote.register(name, email, password);
      return const Right(unit);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
}