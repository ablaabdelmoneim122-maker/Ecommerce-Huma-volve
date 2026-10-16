import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure/failure.dart';
import '../repos/auth_repo.dart';

class LoginUseCase {
  final AuthRepo _repo;
  LoginUseCase(this._repo);

  Future<Either<Failure, Unit>> call(String email, String password) async {
    final result = await _repo.login(email, password);
    return result.fold<Either<Failure, Unit>>(
      (error) => Left<Failure, Unit>(error as Failure),
      (unit) => Right<Failure, Unit>(unit),
    );
  }
}
