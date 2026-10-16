
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure/failure.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';

abstract class HomeRepo {
  Future<Either<Failure, List<ProductEntity>>> getProducts(
      {int? categoryId, String? title});
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
}