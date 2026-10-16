import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure/failure.dart';
import '../../../../core/errors/handler/error_handler.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repos/home_repo.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepoImpl implements HomeRepo {
  final HomeRemoteDataSource _remote;
  HomeRepoImpl(this._remote);

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts(
      {int? categoryId, String? title}) async {
    try {
      final products = await _remote.getProducts(categoryId: categoryId, title: title);
      return Right(products);
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      return Right(await _remote.getCategories());
    } catch (e) {
      return Left(ErrorHandler.handle(e));
    }
  }
}