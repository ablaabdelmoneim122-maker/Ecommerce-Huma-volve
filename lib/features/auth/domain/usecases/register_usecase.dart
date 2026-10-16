import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure/failure.dart';
import '../repos/auth_repo.dart';


class RegisterUseCase {
  final AuthRepo _repo;
  RegisterUseCase(this._repo);

  Future<Either<Failure, Unit>> call(String name, String email, String password) async {
    final result = await _repo.register(name, email, password);
    return result.fold< Either<Failure, Unit> >(
      (error) => Left(error as Failure),
      (unit) => Right(unit),
    );
  }
}