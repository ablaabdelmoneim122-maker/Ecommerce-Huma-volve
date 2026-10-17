import 'package:dio/dio.dart';

import '../models/category_model.dart';
import '../models/product_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<ProductModel>> getProducts({int? categoryId, String? title});
  Future<List<CategoryModel>> getCategories();
  Future<ProductModel> getProductById(int id);
}


class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio _dio;
  HomeRemoteDataSourceImpl(this._dio);

  @override
  Future<List<ProductModel>> getProducts({int? categoryId, String? title}) async {
    final path = categoryId == null
        ? '/products'
        : '/categories/$categoryId/products';
    final res = await _dio.get(
      path,
      queryParameters: {
        'offset': 0,
        'limit': 20,
        'title': ?title,
      },
    );
    return (res.data as List).map((e) => ProductModel.fromJson(e)).toList();
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final res = await _dio.get('/categories');
    return (res.data as List).map((e) => CategoryModel.fromJson(e)).toList();
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    final res = await _dio.get('/products/$id');
    return ProductModel.fromJson(res.data);
  }
}