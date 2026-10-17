import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure/failure.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repos/home_repo.dart';

class GetProductsUseCase {
  final HomeRepo _repo;
  GetProductsUseCase(this._repo);

  Future<Either<Failure, List<ProductEntity>>> call(
          {int? categoryId, String? title}) =>
      _repo.getProducts(categoryId: categoryId, title: title);
}

