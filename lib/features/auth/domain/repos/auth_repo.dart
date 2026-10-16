import 'package:dartz/dartz.dart';

abstract class AuthRepo {
  Future<Either<Object, Unit>> login(String email, String password);
  Future<Either<Object, Unit>> register(String name, String email, String password);
}