import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure/failure.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repos/home_repo.dart';


class GetCategoriesUseCase {
  final HomeRepo _repo;
  GetCategoriesUseCase(this._repo);

  Future<Either<Failure, List<CategoryEntity>>> call() => _repo.getCategories();
}