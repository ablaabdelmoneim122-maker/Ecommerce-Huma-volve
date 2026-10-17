import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure/failure.dart';
import '../entities/product_entity.dart';
import '../repos/home_repo.dart';

class GetProductByIdUseCase {
  final HomeRepo _homeRepo;

  GetProductByIdUseCase(this._homeRepo);

  Future<Either<Failure, ProductEntity>> invoke(int id) =>
      _homeRepo.getProductById(id);
}